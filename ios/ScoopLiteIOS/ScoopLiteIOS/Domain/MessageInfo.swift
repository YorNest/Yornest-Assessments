import Foundation

/// Represents a single message in the chat.
/// 
/// This model follows the same structure as the Android assessment's MessageInfo.
struct MessageInfo: Codable, Equatable, Identifiable {
    let id: String
    let text: String
    let sender: String
    let senderId: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case sender
        case senderId = "sender_id"
        case timestamp
    }
    
    init(id: String, text: String, sender: String, senderId: String, timestamp: Date) {
        self.id = id
        self.text = text
        self.sender = sender
        self.senderId = senderId
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        sender = try container.decode(String.self, forKey: .sender)
        senderId = try container.decode(String.self, forKey: .senderId)
        
        // Handle timestamp as either ISO8601 string or Unix timestamp
        if let timestampString = try? container.decode(String.self, forKey: .timestamp) {
            let formatter = ISO8601DateFormatter()
            timestamp = formatter.date(from: timestampString) ?? Date()
        } else if let timestampDouble = try? container.decode(Double.self, forKey: .timestamp) {
            timestamp = Date(timeIntervalSince1970: timestampDouble)
        } else {
            timestamp = Date()
        }
    }
}

// MARK: - Formatted Properties

extension MessageInfo {
    
    /// Returns a formatted timestamp string (e.g., "2:30 PM" or "Yesterday")
    var formattedTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    /// Returns initials from the sender's name (e.g., "JD" for "John Doe")
    var senderInitials: String {
        let components = sender.split(separator: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}

