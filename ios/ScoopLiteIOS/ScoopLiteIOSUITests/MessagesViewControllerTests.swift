import XCTest

/// UI tests for MessagesViewController.
/// 
/// Tests the UI behavior and interactions following the patterns
/// used in the main YorNest app's UI tests.
final class MessagesViewControllerTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Initial State Tests
    
    func testMessagesScreen_ShowsTitle() throws {
        // Given the app is launched
        
        // Then
        let navigationBar = app.navigationBars["Messages"]
        XCTAssertTrue(navigationBar.exists)
    }
    
    func testMessagesScreen_ShowsFAB() throws {
        // Given the app is launched
        
        // Then
        let fabButton = app.buttons["CreateMessageButton"]
        XCTAssertTrue(fabButton.waitForExistence(timeout: 2))
    }
    
    func testMessagesScreen_ShowsTableView() throws {
        // Given the app is launched
        
        // Then
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 2))
    }
    
    // MARK: - Interaction Tests
    
    func testTapFAB_ShowsCreateMessageSheet() throws {
        // Given
        let fabButton = app.buttons["CreateMessageButton"]
        XCTAssertTrue(fabButton.waitForExistence(timeout: 2))
        
        // When
        fabButton.tap()
        
        // Then
        let headerLabel = app.staticTexts["New Message"]
        XCTAssertTrue(headerLabel.waitForExistence(timeout: 2))
    }
    
    func testCreateMessageSheet_HasRequiredElements() throws {
        // Given
        let fabButton = app.buttons["CreateMessageButton"]
        fabButton.tap()
        
        // Then
        XCTAssertTrue(app.staticTexts["New Message"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.textViews.firstMatch.exists)
        XCTAssertTrue(app.buttons["Cancel"].exists)
        XCTAssertTrue(app.buttons["Submit"].exists)
    }
    
    func testCreateMessageSheet_CancelDismissesSheet() throws {
        // Given
        let fabButton = app.buttons["CreateMessageButton"]
        fabButton.tap()
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 2))
        
        // When
        cancelButton.tap()
        
        // Then
        XCTAssertFalse(app.staticTexts["New Message"].exists)
    }
    
    func testCreateMessageSheet_SubmitButtonDisabledWhenEmpty() throws {
        // Given
        let fabButton = app.buttons["CreateMessageButton"]
        fabButton.tap()
        
        let submitButton = app.buttons["Submit"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 2))
        
        // Then
        XCTAssertFalse(submitButton.isEnabled)
    }
    
    func testCreateMessageSheet_SubmitButtonEnabledWithText() throws {
        // Given
        let fabButton = app.buttons["CreateMessageButton"]
        fabButton.tap()
        
        let textView = app.textViews.firstMatch
        XCTAssertTrue(textView.waitForExistence(timeout: 2))
        
        // When
        textView.tap()
        textView.typeText("Test message")
        
        // Then
        let submitButton = app.buttons["Submit"]
        XCTAssertTrue(submitButton.isEnabled)
    }
    
    // MARK: - Pull to Refresh Test
    
    func testPullToRefresh_TriggersRefresh() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 2))
        
        // When
        let start = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        let end = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        start.press(forDuration: 0, thenDragTo: end)
        
        // Then - the refresh should complete (we just verify no crash)
        XCTAssertTrue(tableView.exists)
    }
}

