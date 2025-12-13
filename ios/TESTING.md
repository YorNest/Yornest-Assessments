# Testing Guide

## Overview

This project uses XCTest for both unit and UI testing, following the same patterns as the main YorNest iOS app.

## Test Structure

### Unit Tests (`ScoopLiteIOSTests/`)

| File | Description |
|------|-------------|
| `TestUtils.swift` | Utility functions for creating test data |
| `MessagesPresenterTests.swift` | Tests presenter logic and state changes |
| `MessagesStateTests.swift` | Tests state behavior (includes intentional incomplete test) |

### UI Tests (`ScoopLiteIOSUITests/`)

| File | Description |
|------|-------------|
| `MessagesViewControllerTests.swift` | Tests UI behavior and interactions |

## Running Tests

### Via Makefile
```bash
make test-unit    # Run unit tests only
make test-ui      # Run UI tests only
make test         # Run all tests
```

### Via Xcode
- **⌘ + U** to run all tests
- Click the diamond next to individual tests to run them

## Test Results

When you run tests, you should see:
- ✅ Some tests passing (demonstrates patterns work)
- ❌ Some tests failing (intentional bugs for assessment)
- ⚠️ Some tests incomplete (for candidates to implement)

## Writing New Tests

Follow the existing patterns:

```swift
class ExamplePresenterTests: XCTestCase {
    
    var presenter: ExamplePresenter!
    var mockService: MockExampleService!
    var stateChanges: [ExampleState] = []
    
    override func setUp() {
        super.setUp()
        mockService = MockExampleService()
        presenter = ExamplePresenter(service: mockService)
        
        presenter.stateSignal = { [weak self] state in
            self?.stateChanges.append(state)
        }
    }
    
    override func tearDown() {
        presenter = nil
        mockService = nil
        stateChanges = []
        super.tearDown()
    }
    
    func testLoadData_Success() async {
        // Given
        mockService.mockData = TestUtils.createSampleData()
        
        // When
        await presenter.loadData()
        
        // Then
        XCTAssertEqual(stateChanges.count, 2)
        XCTAssertEqual(stateChanges[0], .loading)
        // Assert loaded state...
    }
}
```

## Mock Services

Create mock services by conforming to the service protocol:

```swift
class MockMessagesService: MessagesServiceProtocol {
    var mockMessages: [MessageInfo] = []
    var shouldFail = false
    var errorMessage = "Mock error"
    
    func fetchMessages() async throws -> [MessageInfo] {
        if shouldFail {
            throw RequestAPIError.serverError(errorMessage)
        }
        return mockMessages
    }
}
```

