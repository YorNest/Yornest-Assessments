import Foundation

/// Manages the current user's session and authentication state.
/// 
/// This is a simplified version for the assessment app.
/// In the main YorNest app, this handles actual authentication tokens.
final class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    // MARK: - User Properties
    
    /// The current user's ID
    var userId: String {
        get { UserDefaults.standard.string(forKey: "userId") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "userId") }
    }
    
    /// The current user's display name
    var displayName: String {
        get { UserDefaults.standard.string(forKey: "displayName") ?? "Guest User" }
        set { UserDefaults.standard.set(newValue, forKey: "displayName") }
    }
    
    /// Access token for API authentication
    var accessToken: String {
        get { UserDefaults.standard.string(forKey: "accessToken") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
    }
    
    /// Refresh token for obtaining new access tokens
    var refreshToken: String {
        get { UserDefaults.standard.string(forKey: "refreshToken") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "refreshToken") }
    }
    
    // MARK: - Authentication State
    
    /// Whether the user is currently logged in
    var isLoggedIn: Bool {
        return !accessToken.isEmpty
    }
    
    /// Clears all user data (logout)
    func clearUserData() {
        userId = ""
        displayName = "Guest User"
        accessToken = ""
        refreshToken = ""
    }
    
    // MARK: - Mock Setup
    
    /// Sets up mock user data for the assessment app
    func setupMockUser() {
        userId = "mock-user-123"
        displayName = "Test User"
        accessToken = "mock-access-token"
        refreshToken = "mock-refresh-token"
    }
}

