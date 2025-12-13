import XCTest
@testable import ScoopLiteIOS

/// Unit tests for MessagesState.
/// 
/// This test file has an intentional incomplete test that candidates need to implement.
/// It demonstrates testing state behavior in the MVP pattern.
final class MessagesStateTests: XCTestCase {
    
    // MARK: - Equality Tests
    
    func testIdleState_Equality() {
        // Given
        let state1 = MessagesState.idle
        let state2 = MessagesState.idle
        
        // Then
        XCTAssertEqual(state1, state2)
    }
    
    func testLoadingState_Equality() {
        // Given
        let state1 = MessagesState.loading
        let state2 = MessagesState.loading
        
        // Then
        XCTAssertEqual(state1, state2)
    }
    
    func testLoadedState_Equality_SameMessages() {
        // Given
        let messages = TestUtils.createSampleMessages(count: 2)
        let state1 = MessagesState.loaded(messages: messages)
        let state2 = MessagesState.loaded(messages: messages)
        
        // Then
        XCTAssertEqual(state1, state2)
    }
    
    func testLoadedState_Inequality_DifferentMessages() {
        // Given
        let messages1 = TestUtils.createSampleMessages(count: 2)
        let messages2 = TestUtils.createSampleMessages(count: 3)
        let state1 = MessagesState.loaded(messages: messages1)
        let state2 = MessagesState.loaded(messages: messages2)
        
        // Then
        XCTAssertNotEqual(state1, state2)
    }
    
    func testErrorState_Equality_SameMessage() {
        // Given
        let state1 = MessagesState.error(message: "Network error")
        let state2 = MessagesState.error(message: "Network error")
        
        // Then
        XCTAssertEqual(state1, state2)
    }
    
    func testErrorState_Inequality_DifferentMessage() {
        // Given
        let state1 = MessagesState.error(message: "Network error")
        let state2 = MessagesState.error(message: "Server error")
        
        // Then
        XCTAssertNotEqual(state1, state2)
    }
    
    func testDifferentStates_Inequality() {
        // Given
        let idleState = MessagesState.idle
        let loadingState = MessagesState.loading
        let loadedState = MessagesState.loaded(messages: [])
        let errorState = MessagesState.error(message: "Error")
        
        // Then
        XCTAssertNotEqual(idleState, loadingState)
        XCTAssertNotEqual(loadingState, loadedState)
        XCTAssertNotEqual(loadedState, errorState)
    }
    
    // MARK: - Intentional Incomplete Test
    // TODO: Candidates should implement this test
    
    func testRefreshingState_ShouldMaintainExistingMessages() {
        // This test is intentionally incomplete.
        // 
        // ASSESSMENT TASK:
        // Implement this test to verify that the refreshing state
        // correctly maintains the existing messages.
        //
        // Hint: Create a refreshing state with some messages and verify
        // that you can access those messages.
        
        // Write your test here:
        XCTFail("Test not implemented - implement this test as part of the assessment")
    }
}

