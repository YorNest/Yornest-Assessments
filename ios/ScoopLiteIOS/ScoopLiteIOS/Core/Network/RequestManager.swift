import Foundation

/// Protocol for request management to enable mocking in tests
protocol RequestManagerProtocol {
    func request<T: Codable>(endPoint: EndPointProtocol) async throws -> T
}

/// Handles network requests to the API.
/// 
/// This is a simplified version of the RequestManager used in the main YorNest app.
/// For the assessment, it uses mock data by default.
///
/// In a real implementation, this would use URLSession or Alamofire for actual network calls.
final class RequestManager: RequestManagerProtocol {
    
    private let baseURL: String
    private let useMockData: Bool
    private let jsonDecoder: JSONDecoder
    
    init(baseURL: String = "https://api.yornest.com", useMockData: Bool = true) {
        self.baseURL = baseURL
        self.useMockData = useMockData
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    /// Performs a network request and returns the decoded response.
    /// - Parameter endPoint: The endpoint to request
    /// - Returns: The decoded response
    /// - Throws: RequestAPIError if the request fails
    func request<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        if useMockData {
            return try await mockRequest(endPoint: endPoint)
        }
        return try await realRequest(endPoint: endPoint)
    }
    
    // MARK: - Mock Implementation
    
    private func mockRequest<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Return mock data based on endpoint path
        guard let mockData = MockDataProvider.shared.getMockData(for: endPoint) else {
            throw RequestAPIError.notFound
        }
        
        guard let result = mockData as? T else {
            throw RequestAPIError.unknownResponseModel
        }
        
        return result
    }
    
    // MARK: - Real Implementation
    
    private func realRequest<T: Codable>(endPoint: EndPointProtocol) async throws -> T {
        let urlString = baseURL + endPoint.path
        
        guard let url = URL(string: urlString) else {
            throw RequestAPIError.notValid
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        // Add headers
        for (key, value) in endPoint.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Add parameters for POST/PUT/PATCH
        if endPoint.httpMethod != .get && !endPoint.parameters.isEmpty {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: endPoint.parameters)
        }
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestAPIError.unknownError
        }
        
        // Handle status codes
        switch httpResponse.statusCode {
        case 200..<300:
            do {
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                throw RequestAPIError.unknownResponseModel
            }
        case 401:
            throw RequestAPIError.authorizationError
        case 404:
            throw RequestAPIError.notFound
        case 400..<500:
            throw RequestAPIError.clientError("Client error: \(httpResponse.statusCode)")
        case 500..<600:
            throw RequestAPIError.serverError
        default:
            throw RequestAPIError.unknownError
        }
    }
}

