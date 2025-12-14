import Foundation
import FaceLiveness
import AWSPluginsCore

// MARK: - AWS Credentials

/// Temporary AWS credentials for Face Liveness SDK
struct LivenessAWSCredentials: AWSTemporaryCredentials {
    let accessKeyId: String
    let secretAccessKey: String
    let sessionToken: String
    let expiration: Date
}

// MARK: - Credentials Provider

/// Custom credentials provider for Face Liveness SDK.
/// 
/// This provider fetches temporary AWS credentials from our backend,
/// which are used by the FaceLivenessDetectorView to communicate with AWS Rekognition.
final class LivenessCredentialsProvider: AWSCredentialsProvider {

    // MARK: - Properties

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - AWSCredentialsProvider

    func fetchAWSCredentials() async throws -> AWSCredentials {
        #if DEBUG
        print("🔐 [LivenessCredentialsProvider] Fetching AWS credentials...")
        #endif

        // Fetch temporary credentials from our backend
        let credentials = try await authService.getFaceLivenessCredentials()

        guard let accessKeyId = credentials.accessKeyId,
              let secretAccessKey = credentials.secretAccessKey,
              let sessionToken = credentials.sessionToken else {
            throw LivenessCredentialsError.missingCredentials
        }

        // Parse expiration date (default to 1 hour from now if not provided)
        let expiration: Date
        if let expirationString = credentials.expiration,
           let expirationDate = ISO8601DateFormatter().date(from: expirationString) {
            expiration = expirationDate
        } else {
            expiration = Date().addingTimeInterval(3600) // 1 hour
        }

        #if DEBUG
        print("✅ [LivenessCredentialsProvider] Credentials fetched successfully")
        #endif

        return LivenessAWSCredentials(
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey,
            sessionToken: sessionToken,
            expiration: expiration
        )
    }
}

// MARK: - Errors

enum LivenessCredentialsError: Error, LocalizedError {
    case missingCredentials

    var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "Failed to retrieve AWS credentials for liveness verification"
        }
    }
}

