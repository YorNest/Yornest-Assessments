# YorNest Android Assessment Project

This is a minimal Android application that follows the exact architecture and design patterns used in the main Scoop Android app. It serves as an assessment tool for Android developer candidates.

## Architecture Overview

This project implements the same architectural patterns as the main YorNest app:

### Core Architecture
- **MVVM Pattern** with `BaseVm<S : BaseVmState>`
- **Clean Architecture** with clear separation of concerns
- **Modular Structure** with feature modules (`i_*`) and core modules
- **Dependency Injection** using Koin 3.2.0
- **Repository Pattern** with `RequestType` (CacheThenRemote, RemoteOnly, CacheOnly)
- **Use Case Pattern** with `OneInputFlowResultUseCase`, `OneInputResultUseCase`, etc.

### Key Components
- **RequestResult<T>** wrapper for API responses (not Kotlin's Result<T>)
- **RequestData<T>** wrapper for repository responses with cache metadata
- **VmDependencies** for ViewModel dependency injection
- **DispatchersProvider** abstraction for testability
- **Cicerone** navigation system
- **Flow-based** reactive data streams

### Technology Stack
- **Kotlin** 1.8.22
- **Koin** 3.2.0 for dependency injection
- **Retrofit** 2.9.0 with Kotlin Serialization
- **Coroutines** 1.6.4 for async operations
- **ViewBinding** for UI
- **Material Design Components** 1.9.0
- **RecyclerView** with DiffUtil

## Project Structure

```
app/                           # Main application module
├── features/messages/         # Messages feature implementation
├── di/                       # Dependency injection modules
core_arch/                    # Core architecture components (BaseVm, etc.)
core_base/                    # Base utilities (RequestResult, DispatchersProvider)
core_koin/                    # Koin configuration
core_navigation/              # Cicerone navigation setup
domain/                       # Domain models
network/                      # Network layer (Use cases, RequestResultHandler)
i_messages/                   # Messages interactor module
ui_kit/                       # Shared UI components
database/                     # Room database setup
logger/                       # Logging utilities
```

## Features

The app currently implements a single feature - **Messages List**:
- Displays a list of chat messages
- Implements pull-to-refresh
- Shows loading states and error handling
- Uses mock data with simulated network delay
- Follows the exact repository and use case patterns from the main app

## Building and Running

1. Open the project in Android Studio
2. Sync Gradle files
3. Run the app on an emulator or device

The app will display a list of mock messages with proper loading states and error handling.

## Assessment Usage

This project is designed to test candidates on:

1. **Debugging within the existing architecture**
   - Understanding the flow from UI → ViewModel → UseCase → Repository
   - Working with the RequestResult and RequestData patterns
   - Debugging Koin dependency injection issues

2. **Adding new features within the existing architecture**
   - Creating new use cases following the established patterns
   - Implementing new ViewModels with proper state management
   - Adding new repository methods with proper caching strategies

The architecture exactly matches the main YorNest app, so candidates who can work effectively in this codebase will be able to work effectively in the production codebase.
