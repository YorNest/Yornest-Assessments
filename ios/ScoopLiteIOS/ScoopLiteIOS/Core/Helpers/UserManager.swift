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

    /// Session token from authenticateUser
    var session: String? {
        get { UserDefaults.standard.string(forKey: "session") }
        set { UserDefaults.standard.set(newValue, forKey: "session") }
    }

    /// User's mobile number
    var mobileNumber: String {
        get { UserDefaults.standard.string(forKey: "mobileNumber") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "mobileNumber") }
    }

    /// User's full name (first + last)
    var fullName: String {
        get { UserDefaults.standard.string(forKey: "fullName") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "fullName") }
    }

    /// User's username
    var username: String {
        get { UserDefaults.standard.string(forKey: "username") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "username") }
    }

    /// User's profile image URL
    var profileImage: String {
        get { UserDefaults.standard.string(forKey: "profileImage") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "profileImage") }
    }

    /// User's type (public, campus, unknown)
    var type: String {
        get { UserDefaults.standard.string(forKey: "type") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "type") }
    }

    /// Whether user has completed face liveness verification
    var livenessVerified: Bool {
        get { UserDefaults.standard.bool(forKey: "livenessVerified") }
        set { UserDefaults.standard.set(newValue, forKey: "livenessVerified") }
    }

    /// Cached UserModel (like main app)
    var userModel: UserModel? {
        get {
            guard let data = UserDefaults.standard.value(forKey: "userModel") as? Data,
                  let model = try? PropertyListDecoder().decode(UserModel.self, from: data) else {
                return nil
            }
            return model
        }
        set {
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: "userModel")
                return
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "userModel")
        }
    }

    // MARK: - Authentication State

    /// Whether the user is currently logged in
    var isLoggedIn: Bool {
        return !accessToken.isEmpty
    }

    // MARK: - Data Management

    /// Saves user data from API response (like main app's saveData)
    func saveData(user: UserModel?) {
        userId = user?.userId ?? ""
        fullName = user?.fullName ?? ""
        username = user?.username ?? ""
        profileImage = user?.profileImage ?? ""
        type = user?.type?.rawValue ?? ""
        mobileNumber = user?.mobileNumber ?? ""
        userModel = user
    }

    /// Clears all user data (logout) - matching main app's logout() method
    func logout() {
        // Clear auth interceptor credential (like main app)
        authInterceptor.credential = JWTCredential(accessToken: "", refreshToken: "")

        userId = ""
        displayName = "Guest User"
        accessToken = ""
        refreshToken = ""
        session = nil
        mobileNumber = ""
        fullName = ""
        username = ""
        profileImage = ""
        type = ""
        userModel = nil
        livenessVerified = false
    }
}

