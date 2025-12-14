import Foundation
import Alamofire
import UIKit
import LuciqSDK

/// Protocol for request management to enable mocking in tests
protocol RequestManagerProtocol {
    func request<T: Codable>(endPoint: EndPointProtocol) async throws -> T
    func uploadData<T: Codable>(endPoint: EndPointProtocol) async throws -> T
}

// MARK: - JWT Authenticator

/// JWT credential for Alamofire authentication
struct JWTCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String

    var requiresRefresh: Bool {
        // Don't try to refresh if we have no tokens (unauthenticated user)
        // This allows pre-auth endpoints like /authenticateUser to work
        guard !accessToken.isEmpty else { return false }

        // In production, would decode JWT and check expiry like main app
        // For now, never auto-refresh - let 401 trigger refresh
        return false
    }
}

/// JWT authenticator for handling token refresh
final class JWTAuthenticator: Authenticator {

    /// Track last refresh attempt to prevent rapid-fire retries
    private static var lastRefreshAttempt: Date?
    private static let minRefreshInterval: TimeInterval = 5.0 // 5 seconds between refresh attempts

    func apply(_ credential: JWTCredential, to urlRequest: inout URLRequest) {
        // Skip adding auth header if tokens are empty (pre-auth requests)
        guard !credential.accessToken.isEmpty, !credential.refreshToken.isEmpty else { return }
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(_ credential: JWTCredential,
                 for session: Session,
                 completion: @escaping (Result<JWTCredential, Error>) -> Void) {

        // Don't try to refresh if we have no tokens
        guard !credential.accessToken.isEmpty, !credential.refreshToken.isEmpty else {
            #if DEBUG
            print("🚫 [AUTH] Skipping refresh - no valid tokens")
            #endif
            completion(.failure(RequestAPIError.authorizationError))
            return
        }

        // Rate limit: prevent refresh attempts within 5 seconds of each other
        if let lastAttempt = Self.lastRefreshAttempt,
           Date().timeIntervalSince(lastAttempt) < Self.minRefreshInterval {
            #if DEBUG
            print("🚫 [AUTH] Rate limited - skipping refresh (last attempt: \(Date().timeIntervalSince(lastAttempt))s ago)")
            #endif
            completion(.failure(RequestAPIError.authorizationError))
            return
        }

        Self.lastRefreshAttempt = Date()

        Task {
            let refreshEndpoint = BackendConfig.newBaseURL + "refreshToken"

            let response = await AF.request(
                refreshEndpoint,
                method: .post,
                parameters: ["userId": UserManager.shared.userId],
                encoding: JSONEncoding.default,
                headers: [.authorization(bearerToken: credential.refreshToken)]
            ).validate().serializingDecodable(RefreshTokenResponse.self).response

            switch response.result {
            case .success(let tokenResponse):
                let newCredential = JWTCredential(
                    accessToken: tokenResponse.accessToken ?? credential.accessToken,
                    refreshToken: tokenResponse.refreshToken ?? credential.refreshToken
                )
                // Update stored tokens
                UserManager.shared.accessToken = newCredential.accessToken
                UserManager.shared.refreshToken = newCredential.refreshToken
                completion(.success(newCredential))
            case .failure(let error):
                // Handle 401 on refresh - trigger logout
                if response.response?.statusCode == 401 {
                    Task { @MainActor in
                        guard !UserManager.shared.accessToken.isEmpty else {
                            completion(.failure(error))
                            return
                        }
                        #if DEBUG
                        print("🚨 401 on token refresh - triggering logout")
                        #endif
                        handleAuthorizationError()
                    }
                }
                completion(.failure(error))
            }
        }
    }

    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        // Only treat as auth error if we actually have tokens
        // If no tokens, don't retry - the user needs to log in
        guard !UserManager.shared.accessToken.isEmpty else {
            return false
        }
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: JWTCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}

/// Response model for token refresh
struct RefreshTokenResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
}

// MARK: - Global Auth Interceptor

/// Global auth interceptor that can be updated from anywhere (like main app)
var authInterceptor: AuthenticationInterceptor<JWTAuthenticator> = {
    let accessToken = UserManager.shared.accessToken
    let refreshToken = UserManager.shared.refreshToken
    return AuthenticationInterceptor(
        authenticator: JWTAuthenticator(),
        credential: JWTCredential(accessToken: accessToken, refreshToken: refreshToken)
    )
}()

// MARK: - Rate Limiter

/// Centralized rate limiter to prevent rapid-fire requests to the same endpoint
final class RequestRateLimiter {
    static let shared = RequestRateLimiter()

    private var lastRequestTimes: [String: Date] = [:]
    private let lock = NSLock()

    /// Minimum interval between requests to the same endpoint (in seconds)
    private let minInterval: TimeInterval = 0.5

    /// Maximum requests per endpoint per time window
    private let maxRequestsPerWindow = 10
    private let windowDuration: TimeInterval = 5.0
    private var requestCounts: [String: [Date]] = [:]

    private init() {}

    /// Check if a request to the given endpoint should be rate limited
    /// Returns the delay needed before the request can proceed (0 if no delay needed)
    func shouldRateLimit(endpoint: String) -> TimeInterval {
        lock.lock()
        defer { lock.unlock() }

        let now = Date()

        // Clean up old request timestamps
        if var timestamps = requestCounts[endpoint] {
            timestamps = timestamps.filter { now.timeIntervalSince($0) < windowDuration }
            requestCounts[endpoint] = timestamps

            // Check if we've exceeded max requests in the window
            if timestamps.count >= maxRequestsPerWindow {
                let oldestInWindow = timestamps.first!
                let waitTime = windowDuration - now.timeIntervalSince(oldestInWindow)
                #if DEBUG
                print("⏱️ [RATE LIMIT] \(endpoint) - exceeded \(maxRequestsPerWindow) requests in \(windowDuration)s, waiting \(String(format: "%.2f", waitTime))s")
                #endif
                return waitTime
            }
        }

        // Check minimum interval between requests
        if let lastTime = lastRequestTimes[endpoint] {
            let elapsed = now.timeIntervalSince(lastTime)
            if elapsed < minInterval {
                return minInterval - elapsed
            }
        }

        return 0
    }

    /// Record that a request was made to the given endpoint
    func recordRequest(endpoint: String) {
        lock.lock()
        defer { lock.unlock() }

        let now = Date()
        lastRequestTimes[endpoint] = now

        if requestCounts[endpoint] == nil {
            requestCounts[endpoint] = []
        }
        requestCounts[endpoint]?.append(now)
    }
}

// MARK: - Request Manager

/// Handles network requests to the API.
/// Matches the main YorNest app's RequestManager pattern with Alamofire.
///
/// For the assessment, it can use mock data or real network calls.
final class RequestManager: RequestManagerProtocol {

    // MARK: Properties

    private let useMockData: Bool
    private let jsonDecoder: JSONDecoder
    private let session: Session
    private let rateLimiter = RequestRateLimiter.shared

    // MARK: Init

    init(useMockData: Bool = true) {
        self.useMockData = useMockData
        // Use plain JSONDecoder like main app - models use explicit CodingKeys where needed
        self.jsonDecoder = JSONDecoder()

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        // Enable rich network logging like main app
        NetworkLogger.enableLogging(for: configuration)
        self.session = Session(configuration: configuration)
    }

    // MARK: Request

    /// Performs a network request and returns the decoded response.
    /// Includes automatic rate limiting to prevent rapid-fire requests.
    func request<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        // Apply rate limiting
        let delay = rateLimiter.shouldRateLimit(endpoint: endPoint.path)
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        rateLimiter.recordRequest(endpoint: endPoint.path)

        if useMockData {
            return try await mockRequest(endPoint: endPoint)
        }
        return try await realRequest(endPoint: endPoint)
    }

    // MARK: - Mock Implementation

    private func mockRequest<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        try await Task.sleep(nanoseconds: 500_000_000)

        guard let mockData = MockDataProvider.shared.getMockData(for: endPoint) else {
            throw RequestAPIError.notFound
        }

        guard let result = mockData as? T else {
            throw RequestAPIError.unknownResponseModel
        }

        return result
    }

    // MARK: - Real Implementation (Alamofire)

    private func realRequest<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let params: Parameters? = endPoint.requestParameters.isEmpty ? nil : endPoint.requestParameters
            let headers = HTTPHeaders(endPoint.headers.map { HTTPHeader(name: $0.key, value: $0.value) })

            #if DEBUG
            print("🌐 [REQUEST] \(endPoint.httpMethod.rawValue) \(endPoint.path)")
            print("🔑 [ACCESS TOKEN - UserManager] \(UserManager.shared.accessToken)")
            print("🔑 [ACCESS TOKEN - Interceptor] \(authInterceptor.credential?.accessToken ?? "nil")")
            if let params = params {
                print("📦 [PARAMS] \(params)")
            }
            #endif

            session.request(
                endPoint.path,
                method: endPoint.httpMethod,
                parameters: params,
                encoding: endPoint.encoding,
                headers: headers,
                interceptor: authInterceptor
            )
            .validate()
            .responseDecodable(of: T.self, decoder: jsonDecoder) { response in
                #if DEBUG
                print("📨 [RESPONSE] \(endPoint.path)")
                print("   Status: \(response.response?.statusCode ?? 0)")
                if let data = response.data, let body = String(data: data, encoding: .utf8) {
                    print("   Body: \(body.prefix(500))")
                }
                if case .failure(let error) = response.result {
                    print("   ❌ Error: \(error.localizedDescription)")
                }
                #endif

                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: self.mapError(error, response: response.response, data: response.data))
                }
            }
        }
    }

    // MARK: - Multipart Upload Implementation

    /// Uploads data using multipart form data (for image/file uploads)
    func uploadData<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        // Apply rate limiting
        let delay = rateLimiter.shouldRateLimit(endpoint: endPoint.path)
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        rateLimiter.recordRequest(endpoint: endPoint.path)

        return try await withCheckedThrowingContinuation { continuation in
            let headers = HTTPHeaders(endPoint.headers.map { HTTPHeader(name: $0.key, value: $0.value) })

            #if DEBUG
            print("🌐 [UPLOAD] POST \(endPoint.path)")
            print("🔑 [ACCESS TOKEN - UserManager] \(UserManager.shared.accessToken)")
            print("🔑 [ACCESS TOKEN - Interceptor] \(authInterceptor.credential?.accessToken ?? "nil")")
            print("📦 [PARAMS] \(endPoint.requestParameters)")
            print("📎 [FILES] \(endPoint.multipartData.count) file(s)")
            #endif

            session.upload(
                multipartFormData: { multipartFormData in
                    // Add file data
                    endPoint.multipartData.forEach {
                        multipartFormData.append($0.data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
                    }
                    // Add parameters as form data
                    endPoint.requestParameters.forEach {
                        if let dictionary = $0.value as? [String: Any],
                           let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
                            multipartFormData.append(data, withName: $0.key)
                        }
                    }
                },
                to: endPoint.path,
                method: endPoint.httpMethod,
                headers: headers,
                interceptor: authInterceptor
            )
            .validate()
            .responseDecodable(of: T.self, decoder: jsonDecoder) { response in
                #if DEBUG
                print("📨 [UPLOAD RESPONSE] \(endPoint.path)")
                print("   Status: \(response.response?.statusCode ?? 0)")
                if let data = response.data, let body = String(data: data, encoding: .utf8) {
                    print("   Body: \(body.prefix(500))")
                }
                if case .failure(let error) = response.result {
                    print("   ❌ Error: \(error.localizedDescription)")
                }
                #endif

                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: self.mapError(error, response: response.response, data: response.data))
                }
            }
        }
    }

    private func mapError(_ error: AFError, response: HTTPURLResponse?, data: Data? = nil) -> RequestAPIError {
        // Try to extract error message from response body
        var serverMessage: String?
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            serverMessage = json["error"] as? String ?? json["message"] as? String
        }

        guard let statusCode = response?.statusCode else {
            #if DEBUG
            print("   ⚠️ No status code - network error")
            #endif
            return .internetError
        }

        switch statusCode {
        case 401:
            // Trigger logout as a safety net for any 401s that bypass the authenticator
            handleAuthorizationError()
            return .authorizationError
        case 404:
            return .notFound
        case 400..<500:
            let message = serverMessage ?? "Client error: \(statusCode)"
            return .clientError(message)
        case 500..<600:
            return .serverError
        default:
            return .unknownError
        }
    }
}

// MARK: - Authorization Error Handling

/// Handles 401 errors by clearing user data and navigating to sign in
func handleAuthorizationError() {
    Task { @MainActor in
        // Only trigger logout if user is currently logged in to prevent multiple logout calls
        guard !UserManager.shared.accessToken.isEmpty else { return }

        #if DEBUG
        print("🚨 401 Unauthorized detected - triggering logout")
        #endif

        UserManager.shared.logout()
        UserLogoutFlowHelper.showSignInFlow()
    }
}

// MARK: - User Logout Flow Helper

/// Helper to navigate to sign in flow after logout
enum UserLogoutFlowHelper {
    @MainActor
    static func showSignInFlow() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        guard let signInVC = DIContainer.shared.resolve(SignInViewController.self) else { return }
        let navigationController = UINavigationController(rootViewController: signInVC)

        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

