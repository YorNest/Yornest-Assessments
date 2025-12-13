import Foundation
import XCTest
@testable import ScoopLiteIOS

/// Test utilities for creating mock data and common test helpers.
/// 
/// This follows the testing patterns used in the main YorNest app.
enum TestUtils {
    
    // MARK: - Mock Data Generators
    
    /// Creates a sample MessageInfo for testing.
    static func createSampleMessage(
        id: String = "test-id",
        text: String = "Test message content",
        sender: String = "Test Author",
        senderId: String = "test-sender-id",
        timestamp: Date = Date()
    ) -> MessageInfo {
        return MessageInfo(
            id: id,
            text: text,
            sender: sender,
            senderId: senderId,
            timestamp: timestamp
        )
    }
    
    /// Creates a list of sample messages for testing.
    static func createSampleMessages(count: Int = 3) -> [MessageInfo] {
        return (1...count).map { index in
            createSampleMessage(
                id: "test-id-\(index)",
                text: "Test message content \(index)",
                sender: "Test Author \(index)",
                senderId: "test-sender-\(index)",
                timestamp: Date().addingTimeInterval(Double(-index * 1000))
            )
        }
    }
    
    /// Creates a MessagesListInfo with sample messages.
    static func createSampleMessagesList(count: Int = 3) -> MessagesListInfo {
        let messages = createSampleMessages(count: count)
        return MessagesListInfo(totalCount: messages.count, messages: messages)
    }
}

// MARK: - Mock Services

/// Mock implementation of MessagesServiceProtocol for testing.
class MockMessagesService: MessagesServiceProtocol {
    
    var mockMessages: [MessageInfo] = []
    var shouldFail = false
    var errorToThrow: Error = RequestAPIError.serverError
    var fetchMessagesCallCount = 0
    var createMessageCallCount = 0
    var deleteMessageCallCount = 0
    
    func fetchMessages(groupId: String) async throws -> [MessageInfo] {
        fetchMessagesCallCount += 1
        if shouldFail {
            throw errorToThrow
        }
        return mockMessages
    }
    
    func createMessage(text: String, groupId: String) async throws -> MessageInfo {
        createMessageCallCount += 1
        if shouldFail {
            throw errorToThrow
        }
        let newMessage = MessageInfo(
            id: UUID().uuidString,
            text: text,
            sender: "Current User",
            senderId: "current-user",
            timestamp: Date()
        )
        mockMessages.append(newMessage)
        return newMessage
    }
    
    func deleteMessage(messageId: String) async throws {
        deleteMessageCallCount += 1
        if shouldFail {
            throw errorToThrow
        }
        mockMessages.removeAll { $0.id == messageId }
    }
    
    func reset() {
        mockMessages = []
        shouldFail = false
        errorToThrow = RequestAPIError.serverError
        fetchMessagesCallCount = 0
        createMessageCallCount = 0
        deleteMessageCallCount = 0
    }
}

// MARK: - Async Test Helpers

extension XCTestCase {

    /// Waits for an async operation to complete.
    func waitForAsync(timeout: TimeInterval = 1.0, operation: @escaping () async -> Void) {
        let expectation = expectation(description: "Async operation")
        Task {
            await operation()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
}

