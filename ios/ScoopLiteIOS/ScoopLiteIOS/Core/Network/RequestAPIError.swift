import Foundation

// MARK: - Closure Type Aliases (matching main app's Global.swift)

public typealias ClosureEmpty = () -> Void
public typealias Closure<T> = (T) -> Void
public typealias ClosureTwo<T, U> = (T, U) -> Void

/// API error types that can occur during network requests.
///
/// This matches the error handling pattern used in the main YorNest app.
enum RequestAPIError: Error, Equatable {
    case authorizationError
    case unknownError
    case unknownResponseModel
    case notFound
    case serverError
    case clientError(String)
    case internetError
    case notValid
    case notApproved
    case incorrectRestrictError
    case duplicate
}

extension RequestAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authorizationError:
            return "Authorization Error"
        case .unknownError:
            return "An unknown error occurred"
        case .unknownResponseModel:
            return "Unable to parse response"
        case .notFound:
            return "Resource not found"
        case .serverError:
            return "Server Error"
        case .clientError(let message):
            return message
        case .internetError:
            return "No internet connection"
        case .notValid:
            return "Invalid data"
        case .notApproved:
            return "Not approved"
        case .incorrectRestrictError:
            return "Incorrect restriction"
        case .duplicate:
            return "Duplicate entry"
        }
    }
}

