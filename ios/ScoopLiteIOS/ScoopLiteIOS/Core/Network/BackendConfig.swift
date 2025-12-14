import Foundation

/// Backend configuration for API endpoints.
/// Matches the main YorNest app's BackendConfig pattern.
///
/// Environment flags are set in project.yml build settings:
/// - LOCAL: Local development (localhost)
/// - DEV: Development environment
/// - QA: QA/Staging environment
/// - PROD: Production environment
enum BackendConfig {

    // MARK: - REST API Base URL

    /// Base URL for the new REST API (Go backend)
    static var newBaseURL: String {
        #if LOCAL
        return "http://localhost:8080/"
        #elseif DEV
        return "https://dev.rest.api.scoop.chat/"
        #elseif QA
        return "https://dev.rest.api.scoop.chat/"
        #elseif PROD
        return "https://dev.rest.api.scoop.chat/"
        #else
        // Default fallback for assessment - use staging
        return "https://dev.rest.api.scoop.chat/"
        #endif
    }

    // MARK: - WebSocket Base URL

    /// Base URL for WebSocket connections
    static var socketBaseURL: String {
        #if LOCAL
        return "ws://localhost:8081/serveWebsocket"
        #elseif DEV
        return "wss://dev.ws.api.scoop.chat/serveWebsocket"
        #elseif QA
        return "wss://dev.ws.api.scoop.chat/serveWebsocket"
        #elseif PROD
        return "wss://dev.ws.api.scoop.chat/serveWebsocket"
        #else
        // Default fallback for assessment
        return "wss://dev.ws.api.scoop.chat/serveWebsocket"
        #endif
    }
}

