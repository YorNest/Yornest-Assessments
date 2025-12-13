import Foundation

/// API endpoints for the Messages feature.
/// 
/// This follows the same EndPointProtocol pattern used in the main YorNest app.
enum MessagesEndpoint: EndPointProtocol {
    case fetchMessages(groupId: String)
    case createMessage(CreateMessageRequest)
    case deleteMessage(messageId: String)
    
    // MARK: - EndPointProtocol
    
    var path: String {
        switch self {
        case .fetchMessages(let groupId):
            return "/groups/\(groupId)/messages"
        case .createMessage:
            return "/messages"
        case .deleteMessage(let messageId):
            return "/messages/\(messageId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchMessages:
            return .get
        case .createMessage:
            return .post
        case .deleteMessage:
            return .delete
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .fetchMessages:
            return [:]
        case .createMessage(let request):
            return asJSONDictionary(request)
        case .deleteMessage:
            return [:]
        }
    }
    
    var headers: [String: String] {
        var baseHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Add authorization header if user is logged in
        let token = UserManager.shared.accessToken
        if !token.isEmpty {
            baseHeaders["Authorization"] = "Bearer \(token)"
        }
        
        return baseHeaders
    }
}

