import Foundation

/// HTTP methods supported by the API
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Protocol that all API endpoints must conform to.
/// 
/// This follows the same pattern as the main YorNest app for defining API endpoints.
///
/// Usage:
/// ```swift
/// enum MessagesEndpoint: EndPointProtocol {
///     case fetchMessages(groupId: String)
///     case createMessage(CreateMessageRequest)
///     
///     var path: String {
///         switch self {
///         case .fetchMessages(let groupId):
///             return "/groups/\(groupId)/messages"
///         case .createMessage:
///             return "/messages"
///         }
///     }
///     
///     var httpMethod: HTTPMethod {
///         switch self {
///         case .fetchMessages: return .get
///         case .createMessage: return .post
///         }
///     }
/// }
/// ```
protocol EndPointProtocol {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
}

extension EndPointProtocol {
    /// Default empty parameters
    var parameters: [String: Any] { [:] }
    
    /// Default empty headers
    var headers: [String: String] { [:] }
    
    /// Helper to convert a Codable model to a dictionary for use as parameters
    func asJSONDictionary<T: Codable>(_ model: T, snakeCase: Bool = false) -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        jsonEncoder.keyEncodingStrategy = snakeCase ? .convertToSnakeCase : .useDefaultKeys
        
        guard let data = try? jsonEncoder.encode(model),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}

