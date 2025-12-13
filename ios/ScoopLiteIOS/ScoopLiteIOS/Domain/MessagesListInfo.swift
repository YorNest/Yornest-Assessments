import Foundation

/// Wrapper for a list of messages with metadata.
/// 
/// This matches the MessagesListInfo structure used in the Android assessment.
struct MessagesListInfo: Codable, Equatable {
    let totalCount: Int
    let messages: [MessageInfo]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case messages
    }
    
    init(totalCount: Int, messages: [MessageInfo]) {
        self.totalCount = totalCount
        self.messages = messages
    }
}

// MARK: - Request/Response Models

/// Request model for creating a new message
struct CreateMessageRequest: Codable {
    let text: String
    let groupId: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case groupId = "group_id"
    }
}

/// Request model for deleting a message
struct DeleteMessageRequest: Codable {
    let messageId: String
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
    }
}

/// Generic API response wrapper
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: String?
}

