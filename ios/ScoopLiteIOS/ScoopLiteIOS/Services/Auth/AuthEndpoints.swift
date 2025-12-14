import Foundation
import Alamofire

// MARK: - Auth Endpoints

struct AuthenticateUserEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "authenticateUser" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(mobileNumber: String) {
        self.requestParameters = ["mobileNumber": mobileNumber]
    }
}

struct VerifyOTPEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "verifyOTP" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(session: String, code: String, context: String, contact: String, userId: String, type: String) {
        self.requestParameters = [
            "session": session,
            "code": code,
            "context": context,
            "contact": contact,
            "userId": userId,
            "type": type
        ]
    }
}

/// Update user profile endpoint - uses multipart form data for image upload (matches main app)
struct UpdateProfileEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "updateUser" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }
    var multipartData: [MultipartData] = []

    init(userId: String, firstName: String, lastName: String, username: String, imageData: Data? = nil) {
        // Parameters go in the "request" field as JSON for multipart (matches backend UpdateUserRequest)
        self.requestParameters = [
            "request": [
                "userId": userId,
                "firstName": firstName,
                "lastName": lastName,
                "username": username
            ]
        ]
        // Add image if provided
        if let imageData = imageData {
            self.multipartData = [.image(data: imageData, name: "file")]
        }
    }
}

struct VerifyUsernameEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "verifyUsername" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(username: String) {
        self.requestParameters = ["username": username]
    }
}

struct FetchUserEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "fetchUser" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(userId: String) {
        self.requestParameters = [
            "userId": userId,
            "with": "userId"
        ]
    }
}

struct LogoutEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "logout" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(userId: String) {
        self.requestParameters = ["userId": userId]
    }
}

struct DeleteUserEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "deleteUser" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init() {}
}

struct UpdateTempUserToUserEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "updateTempUserToUser" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(userId: String, gender: String = "prefer_not_to_say") {
        self.requestParameters = [
            "userId": userId,
            "gender": gender
        ]
    }
}

// MARK: - Face Liveness Endpoints

/// Create a Face Liveness session with AWS Rekognition
struct CreateFaceLivenessSessionEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "createFaceLivenessSession" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(userId: String) {
        self.requestParameters = ["userId": userId]
    }
}

/// Get Face Liveness session results from AWS Rekognition
struct GetFaceLivenessSessionResultsEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "getFaceLivenessSessionResults" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init(sessionId: String) {
        self.requestParameters = ["sessionId": sessionId]
    }
}

/// Get temporary AWS credentials for Face Liveness SDK
struct GetFaceLivenessCredentialsEndpoint: EndPointProtocol {
    var path: String { BackendConfig.newBaseURL + "getFaceLivenessCredentials" }
    var httpMethod: HTTPMethod { .post }
    var requestParameters: Parameters = [:]
    var headers: [String: String] { [:] }

    init() {}
}
