import Foundation
import Alamofire

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
            return BackendConfig.newBaseURL + "groups/\(groupId)/messages"
        case .createMessage:
            return BackendConfig.newBaseURL + "messages"
        case .deleteMessage(let messageId):
            return BackendConfig.newBaseURL + "messages/\(messageId)"
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

    var requestParameters: Parameters {
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
        // Authorization is handled by the auth interceptor in RequestManager
        return [:]
    }
}

