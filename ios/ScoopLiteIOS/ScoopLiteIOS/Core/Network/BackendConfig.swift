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
        return "http://localhost:8080/"
        #elseif QA
        return "http://localhost:8080/"
        #elseif PROD
        return "http://localhost:8080/"
        #else
        // Default fallback for assessment - use localhost
        return "http://localhost:8080/"
        #endif
    }
    
    // MARK: - WebSocket Base URL
    
    /// Base URL for WebSocket connections
    static var socketBaseURL: String {
        #if LOCAL
        return "ws://localhost:8081/serveWebsocket"
        #elseif DEV
        return "ws://localhost:8081/serveWebsocket"
        #elseif QA
        return "ws://localhost:8081/serveWebsocket"
        #elseif PROD
        return "ws://localhost:8081/serveWebsocket"
        #else
        // Default fallback for assessment
        return "ws://localhost:8081/serveWebsocket"
        #endif
    }
}

