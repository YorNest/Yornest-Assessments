# ScoopLite iOS Assessment

A minimal iOS application following the exact architecture and design patterns used in the main YorNest iOS app. This serves as an assessment tool for iOS developer candidates.

## Architecture Overview

This project implements the same architectural patterns as the main YorNest app:

### Core Architecture
- **MVP-Coordinator Pattern** with `BasePresenter<S, E>`
- **Clear separation of concerns** (Presentation, Service, Domain)
- **Dependency Injection** using Swinject
- **Coordinator Pattern** for navigation
- **Async/Await** for asynchronous operations

### Key Components

| Component | Role |
|-----------|------|
| `BaseState` | Protocol for state types (enums) |
| `BaseEvent` | Protocol for events/actions (enums) |
| `BasePresenter<S, E>` | Handles business logic, emits states/events |
| `BaseViewController<S, E, P>` | UI, receives states, handles events |
| `Coordinator` | Navigation between screens |
| `Services` | Network/API layer |

### Technology Stack
- **Swift 5.9**
- **iOS 15.0+**
- **Swinject** for dependency injection
- **SnapKit** for programmatic layouts
- **Starscream** for WebSocket
- **XCTest** for testing

## Getting Started

```bash
# Install dependencies and open workspace
make setup

# Build the project
make build

# Run tests
make test
```

## Project Structure

```
ScoopLiteIOS/
├── Core/                      # Core architecture
│   ├── Base/                  # BasePresenter, BaseViewController, protocols
│   ├── DI/                    # Swinject container
│   ├── Network/               # Request handling
│   └── Helpers/               # Utilities
├── Domain/                    # Models
├── Services/                  # API services
└── Features/                  # Feature modules
    └── Messages/              # Single feature for assessment
```

## Assessment Tasks

This project contains intentional issues for candidates to identify and fix:

1. **Debug existing code** - Find and fix bugs in the architecture
2. **Add new features** - Implement missing functionality following existing patterns
3. **Fix failing tests** - Complete test implementations
4. **Understand the flow** - ViewController → Presenter → Service → API

## Evaluation Criteria

- Understanding of MVP-Coordinator pattern
- Proper use of async/await
- State management via Presenter
- Following established patterns for new code
- Test coverage for new functionality

