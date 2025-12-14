import Foundation

// MARK: - User Model Type

/// User type enum matching main YorNest app
enum UserModelType: String, Codable {
    case unknown
    case `public`
    case campus
}

// MARK: - Authenticate User

/// Request model for authenticating user with phone number
struct AuthenticateUserRequestModel: Codable {
    let mobileNumber: String
}

/// Response model from authenticateUser API
struct AuthenticateUserResultModel: Codable {
    var session: String?
    var userId: String?
    var mobileNumber: String?
}

// MARK: - Verify OTP

/// Request model for verifying OTP code
struct VerifyOTPRequestModel: Codable {
    let session: String
    let code: String
    let context: String  // "auth"
    let contact: String
    let userId: String
    let type: String     // "sms"
}

/// Response model from verifyOTP API
struct VerifyOTPResultModel: Codable {
    var accessToken: String?
    var refreshToken: String?
    var expiresIn: Int?
    var tokenType: String?
    var session: String?
}

// MARK: - Update Profile

/// Request model for updating user profile (matches backend UpdateUserRequest)
struct UpdateProfileRequestModel: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let username: String
}

/// Response model from updateProfile API
struct UpdateProfileResultModel: Codable {
    var success: Bool?
    var userId: String?
}

// MARK: - Verify Username

/// Response model from verifyUsername API
struct VerifyUsernameResultModel: Codable {
    var isTaken: Bool?

    /// Convenience property - returns true if username is available
    var available: Bool {
        return !(isTaken ?? true)
    }
}

// MARK: - Fetch User

/// Request model for fetching user details
struct FetchUserRequestModel: Codable {
    let userId: String
}

/// User model from fetchUser API
struct UserModel: Codable {
    var userId: String?
    var fullName: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var profileImage: String?
    var bio: String?
    var mobileNumber: String?
    var isCreator: Bool?
    var isPremium: Bool?
    var email: String?
    var isSignupComplete: Bool?
    var totalPostsCount: Int?
    var createdAt: Int?
    var type: UserModelType?

    init(
        userId: String? = nil,
        fullName: String? = nil,
        username: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        profileImage: String? = nil,
        bio: String? = nil,
        mobileNumber: String? = nil,
        isCreator: Bool? = nil,
        isPremium: Bool? = nil,
        email: String? = nil,
        isSignupComplete: Bool? = nil,
        totalPostsCount: Int? = nil,
        createdAt: Int? = nil,
        type: UserModelType? = nil
    ) {
        self.userId = userId
        self.fullName = fullName
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        self.bio = bio
        self.mobileNumber = mobileNumber
        self.isCreator = isCreator
        self.isPremium = isPremium
        self.email = email
        self.isSignupComplete = isSignupComplete
        self.totalPostsCount = totalPostsCount
        self.createdAt = createdAt
        self.type = type
    }
}

/// Response model from fetchUser API
struct FetchUserResultModel: Codable {
    var result: String?
    var message: String?
    var userExists: Bool?
    var isUserComplete: Bool?
    var user: UserModel?
    var error: String?
}

// MARK: - Logout

/// Response model from logout API
struct LogoutResultModel: Codable {
    var result: String?
    var message: String?
    var error: String?
}

// MARK: - Delete User

/// Response model from deleteUser API
struct DeleteUserResultModel: Codable {
    var result: String?
    var error: String?
}

// MARK: - Update Temp User To User

/// Request model for converting temp user to full user (matching main app)
struct UpdateTempUserToUserRequestModel: Codable {
    let userId: String
    let gender: String

    init(userId: String, gender: String = "prefer_not_to_say") {
        self.userId = userId
        self.gender = gender
    }
}

/// Response model from updateTempUserToUser API
struct UpdateTempUserToUserResultModel: Codable {
    var result: String?
    var userId: String?
    var error: String?

    private enum CodingKeys: String, CodingKey {
        case result
        case userId = "user_id"
        case error
    }
}

// MARK: - Auth Error

enum AuthError: Error, LocalizedError {
    case invalidCode
    case sessionExpired
    case networkError
    case serverError(String)
    case usernameTaken
    case invalidPhoneNumber
    
    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "Invalid verification code"
        case .sessionExpired:
            return "Session expired. Please try again"
        case .networkError:
            return "Network error. Please check your connection"
        case .serverError(let message):
            return message
        case .usernameTaken:
            return "Username is already taken"
        case .invalidPhoneNumber:
            return "Invalid phone number"
        }
    }
}

