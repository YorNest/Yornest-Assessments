import Foundation

/// Provides mock data for API endpoints during development and testing.
/// 
/// This allows the assessment app to work without a real backend connection.
final class MockDataProvider {
    
    static let shared = MockDataProvider()
    
    private init() {}
    
    /// Returns mock data for the given endpoint
    /// - Parameter endPoint: The endpoint to get mock data for
    /// - Returns: Mock data or nil if not found
    func getMockData(for endPoint: EndPointProtocol) -> Any? {
        let path = endPoint.path
        
        // Messages endpoints
        if path.contains("/messages") {
            if endPoint.httpMethod == .get {
                return createMockMessagesList()
            } else if endPoint.httpMethod == .post {
                return createMockMessage(id: UUID().uuidString, text: "New message")
            } else if endPoint.httpMethod == .delete {
                return EmptyResponse()
            }
        }
        
        return nil
    }
    
    // MARK: - Mock Data Generators
    
    private func createMockMessagesList() -> MessagesListInfo {
        let messages = [
            MessageInfo(
                id: "msg-1",
                text: "Welcome to ScoopLite! This is a sample message.",
                sender: "John Doe",
                senderId: "user-1",
                timestamp: Date().addingTimeInterval(-3600)
            ),
            MessageInfo(
                id: "msg-2",
                text: "Thanks for joining the conversation!",
                sender: "Jane Smith",
                senderId: "user-2",
                timestamp: Date().addingTimeInterval(-1800)
            ),
            MessageInfo(
                id: "msg-3",
                text: "Looking forward to collaborating with everyone.",
                sender: "Bob Wilson",
                senderId: "user-3",
                timestamp: Date().addingTimeInterval(-900)
            ),
            MessageInfo(
                id: "msg-4",
                text: "Don't forget about the meeting tomorrow!",
                sender: "Alice Johnson",
                senderId: "user-4",
                timestamp: Date().addingTimeInterval(-300)
            ),
            MessageInfo(
                id: "msg-5",
                text: "I've shared the documents in the channel.",
                sender: "Charlie Brown",
                senderId: "user-5",
                timestamp: Date()
            )
        ]
        
        return MessagesListInfo(totalCount: messages.count, messages: messages)
    }
    
    private func createMockMessage(id: String, text: String) -> MessageInfo {
        return MessageInfo(
            id: id,
            text: text,
            sender: "Current User",
            senderId: "current-user",
            timestamp: Date()
        )
    }
}

/// Empty response for DELETE operations
struct EmptyResponse: Codable {}

