# ScoopLite Testing Guide

This document outlines the testing setup and expectations for the ScoopLite assessment app.

## Testing Framework

The app uses the same testing patterns and libraries as the main YorNest Android app:

### Dependencies
- **JUnit 4.13.2** - Unit testing framework
- **Mockito 5.5.0** - Mocking framework for Java
- **Mockito-Kotlin 5.1.0** - Kotlin extensions for Mockito
- **Kotlinx Coroutines Test 1.7.3** - Testing coroutines
- **AndroidX Core Testing 2.2.0** - Architecture components testing (LiveData, etc.)
- **Espresso 3.5.1** - UI testing framework

## Test Structure

### Unit Tests (`src/test/`)
Located in `app/src/test/java/com/yornest/scooplite/`

- **MessagesViewModelTest.kt** - Tests ViewModel logic, coroutines, and state management
- **MessagesStateTest.kt** - Tests state class behavior (includes intentional bug to fix)
- **TestUtils.kt** - Utility functions for creating test data

### Instrumented Tests (`src/androidTest/`)
Located in `app/src/androidTest/java/com/yornest/scooplite/`

- **MessagesActivityTest.kt** - Tests UI behavior and user interactions

## Running Tests

### Unit Tests
```bash
./gradlew :app:testDevelopDebugUnitTest
# OR use the Makefile
make test-unit
```

### Instrumented Tests
```bash
./gradlew connectedAndroidTest
```

### All Tests
```bash
./gradlew check
```

## Testing Patterns

### ViewModel Testing
- Use `InstantTaskExecutorRule` for LiveData testing
- Mock dependencies with Mockito
- Test coroutines with `UnconfinedTestDispatcher`
- Verify state changes and use case interactions

### UI Testing
- Use Espresso for view interactions
- Test user flows and UI state
- Verify proper component setup

### State Testing
- Test initial state values
- Verify state updates work correctly
- Handle edge cases and null values

## Assessment Tasks

### 1. Fix the Broken Tests
There are several failing tests that need attention:

**a) Intentional Bug Test**: `MessagesStateTest.kt` has a test named `INTENTIONAL_BUG_messages_state_should_handle_null_values` that fails by design.
- **Your task**: Identify the issue and either fix the test or improve the `MessagesState` class to handle null values gracefully

**b) ViewModel Test Failures**: The `MessagesViewModelTest.kt` tests are failing with NullPointerExceptions.
- **Your task**: Debug and fix the test setup issues. Consider:
  - Proper mocking of dependencies
  - Correct handling of suspend functions
  - LiveData observation in tests

### 2. Understand the Test Results
When you run `make test-unit`, you should see:
- ✅ Some tests passing (MessagesStateTest basic functionality)
- ❌ Some tests failing (the intentional bugs and setup issues)
- This is expected! Your job is to fix the failing tests.

### 3. Add Missing Test Coverage
After fixing the existing tests, consider adding:
- Error handling scenarios in ViewModel
- Loading state transitions
- Edge cases for empty message lists
- Activity lifecycle scenarios

### 4. Improve Test Quality
Review the existing tests and suggest improvements for:
- Test readability and maintainability
- Better assertion messages
- More comprehensive edge case coverage

## Best Practices

1. **Follow AAA Pattern**: Arrange, Act, Assert
2. **Use descriptive test names** with backticks for readability
3. **Mock external dependencies** but test real object interactions
4. **Test behavior, not implementation details**
5. **Keep tests focused and independent**
6. **Use test utilities** for common setup and data creation

## Notes

- The testing setup mirrors the main YorNest app architecture
- Focus on testing the MVVM pattern implementation
- Pay attention to coroutine testing and LiveData behavior
- Consider both happy path and error scenarios
