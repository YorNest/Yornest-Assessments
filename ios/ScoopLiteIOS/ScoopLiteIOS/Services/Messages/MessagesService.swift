import Foundation

/// Protocol defining the messages service interface.
/// 
/// This allows for easy mocking in tests.
protocol MessagesServiceProtocol {
    func fetchMessages(groupId: String) async throws -> [MessageInfo]
    func createMessage(text: String, groupId: String) async throws -> MessageInfo
    func deleteMessage(messageId: String) async throws
}

/// Service for handling messages API operations.
/// 
/// This follows the same Service pattern used in the main YorNest app.
final class MessagesService: MessagesServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    /// Fetches all messages for the given group.
    /// - Parameter groupId: The ID of the group to fetch messages for
    /// - Returns: Array of messages
    /// - Throws: RequestAPIError if the request fails
    func fetchMessages(groupId: String) async throws -> [MessageInfo] {
        let endpoint = MessagesEndpoint.fetchMessages(groupId: groupId)
        let response: MessagesListInfo = try await requestManager.request(endPoint: endpoint)
        return response.messages
    }
    
    /// Creates a new message in the given group.
    /// - Parameters:
    ///   - text: The message text
    ///   - groupId: The ID of the group to post to
    /// - Returns: The created message
    /// - Throws: RequestAPIError if the request fails
    func createMessage(text: String, groupId: String) async throws -> MessageInfo {
        let request = CreateMessageRequest(text: text, groupId: groupId)
        let endpoint = MessagesEndpoint.createMessage(request)
        let response: MessageInfo = try await requestManager.request(endPoint: endpoint)
        return response
    }
    
    /// Deletes a message by ID.
    /// - Parameter messageId: The ID of the message to delete
    /// - Throws: RequestAPIError if the request fails
    func deleteMessage(messageId: String) async throws {
        let endpoint = MessagesEndpoint.deleteMessage(messageId: messageId)
        let _: EmptyResponse = try await requestManager.request(endPoint: endpoint)
    }
}

