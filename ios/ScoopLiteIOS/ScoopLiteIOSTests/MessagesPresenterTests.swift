import XCTest
@testable import ScoopLiteIOS

/// Unit tests for MessagesViewPresenter.
/// 
/// Tests the core functionality of loading, refreshing, and creating messages
/// following the MVP pattern used in the main YorNest app.
final class MessagesPresenterTests: XCTestCase {
    
    var presenter: MessagesViewPresenter!
    var mockService: MockMessagesService!
    var stateChanges: [MessagesState] = []
    var eventChanges: [MessagesEvent] = []
    
    override func setUp() {
        super.setUp()
        mockService = MockMessagesService()
        presenter = MessagesViewPresenter(messagesService: mockService, groupId: "test-group")
        
        // Capture state and event changes
        presenter.stateSignal = { [weak self] state in
            self?.stateChanges.append(state)
        }
        presenter.eventSignal = { [weak self] event in
            self?.eventChanges.append(event)
        }
    }
    
    override func tearDown() {
        presenter = nil
        mockService = nil
        stateChanges = []
        eventChanges = []
        super.tearDown()
    }
    
    // MARK: - Load Messages Tests
    
    func testLoadMessages_Success() async {
        // Given
        let mockMessages = TestUtils.createSampleMessages(count: 3)
        mockService.mockMessages = mockMessages
        
        // When
        await presenter.loadMessages()
        
        // Then
        XCTAssertEqual(stateChanges.count, 2)
        XCTAssertEqual(stateChanges[0], .loading)
        XCTAssertEqual(stateChanges[1], .loaded(messages: mockMessages))
        XCTAssertEqual(mockService.fetchMessagesCallCount, 1)
    }
    
    func testLoadMessages_Error() async {
        // Given
        mockService.shouldFail = true
        mockService.errorToThrow = RequestAPIError.serverError
        
        // When
        await presenter.loadMessages()
        
        // Then
        XCTAssertEqual(stateChanges.count, 2)
        XCTAssertEqual(stateChanges[0], .loading)
        
        if case .error(let message) = stateChanges[1] {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
        
        // Verify error event was emitted
        XCTAssertTrue(eventChanges.contains { event in
            if case .showError = event { return true }
            return false
        })
    }
    
    func testLoadMessages_EmptyResult() async {
        // Given
        mockService.mockMessages = []
        
        // When
        await presenter.loadMessages()
        
        // Then
        XCTAssertEqual(stateChanges.count, 2)
        XCTAssertEqual(stateChanges[1], .loaded(messages: []))
    }
    
    // MARK: - Refresh Tests
    
    func testRefresh_Success() async {
        // Given
        let initialMessages = TestUtils.createSampleMessages(count: 2)
        mockService.mockMessages = initialMessages
        await presenter.loadMessages()
        stateChanges.removeAll()
        
        let refreshedMessages = TestUtils.createSampleMessages(count: 5)
        mockService.mockMessages = refreshedMessages
        
        // When
        await presenter.refresh()
        
        // Then
        XCTAssertEqual(stateChanges.count, 2)
        if case .refreshing = stateChanges[0] {
            // Expected
        } else {
            XCTFail("Expected refreshing state")
        }
        XCTAssertEqual(stateChanges[1], .loaded(messages: refreshedMessages))
    }
    
    func testRefresh_Error_KeepsExistingMessages() async {
        // Given
        let existingMessages = TestUtils.createSampleMessages(count: 3)
        mockService.mockMessages = existingMessages
        await presenter.loadMessages()
        stateChanges.removeAll()
        eventChanges.removeAll()
        
        mockService.shouldFail = true
        
        // When
        await presenter.refresh()
        
        // Then - should keep existing messages
        XCTAssertEqual(stateChanges[1], .loaded(messages: existingMessages))
        XCTAssertTrue(eventChanges.contains { event in
            if case .showError = event { return true }
            return false
        })
    }
    
    // MARK: - Create Message Tests
    
    func testSubmitMessage_Success() async {
        // Given
        mockService.mockMessages = []
        await presenter.loadMessages()
        stateChanges.removeAll()
        eventChanges.removeAll()
        
        presenter.updateInputText("New test message")
        
        // When
        await presenter.submitMessage()
        
        // Then
        XCTAssertEqual(mockService.createMessageCallCount, 1)
        XCTAssertTrue(eventChanges.contains { if case .messageCreated = $0 { return true }; return false })
        XCTAssertTrue(eventChanges.contains { if case .hideCreateMessageSheet = $0 { return true }; return false })
    }
    
    func testSubmitMessage_EmptyText_DoesNothing() async {
        // Given
        presenter.updateInputText("   ")
        
        // When
        await presenter.submitMessage()
        
        // Then
        XCTAssertEqual(mockService.createMessageCallCount, 0)
    }
}

