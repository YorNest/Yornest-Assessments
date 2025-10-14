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

### Test Results
When you run `make test-unit`, you should see:
- ✅ Some tests passing (MessagesStateTest basic functionality)
- ❌ Some tests failing (the intentional bugs and setup issues)
- This is expected! Fixing the failing tests (or providing ones you think are better) is a bonus