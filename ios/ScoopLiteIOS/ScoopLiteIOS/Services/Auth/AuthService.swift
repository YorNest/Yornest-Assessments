import Foundation

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol {
    func authenticateUser(model: AuthenticateUserRequestModel) async throws -> AuthenticateUserResultModel
    func verifyOTP(model: VerifyOTPRequestModel) async throws -> VerifyOTPResultModel
    func updateProfile(model: UpdateProfileRequestModel, imageData: Data?) async throws -> UpdateProfileResultModel
    func verifyUsername(_ username: String) async throws -> Bool
    func fetchUser(userId: String) async throws -> FetchUserResultModel
    func updateTempUserToUser(model: UpdateTempUserToUserRequestModel) async throws -> UpdateTempUserToUserResultModel
    func logout(userId: String) async throws
    func deleteUser() async throws

    // Face Liveness
    func createFaceLivenessSession(userId: String) async throws -> CreateFaceLivenessSessionResultModel
    func getFaceLivenessSessionResults(sessionId: String) async throws -> GetFaceLivenessSessionResultsResultModel
    func getFaceLivenessCredentials() async throws -> GetFaceLivenessCredentialsResultModel
}

// MARK: - Auth Service Implementation

/// Real implementation of AuthServiceProtocol that makes actual API calls.
final class AuthService: AuthServiceProtocol {

    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func authenticateUser(model: AuthenticateUserRequestModel) async throws -> AuthenticateUserResultModel {
        let endpoint = AuthenticateUserEndpoint(mobileNumber: model.mobileNumber)
        return try await requestManager.request(endPoint: endpoint)
    }

    func verifyOTP(model: VerifyOTPRequestModel) async throws -> VerifyOTPResultModel {
        let endpoint = VerifyOTPEndpoint(
            session: model.session,
            code: model.code,
            context: model.context,
            contact: model.contact,
            userId: model.userId,
            type: model.type
        )
        return try await requestManager.request(endPoint: endpoint)
    }

    func updateProfile(model: UpdateProfileRequestModel, imageData: Data?) async throws -> UpdateProfileResultModel {
        let endpoint = UpdateProfileEndpoint(
            userId: model.userId,
            firstName: model.firstName,
            lastName: model.lastName,
            username: model.username,
            imageData: imageData
        )
        // Use uploadData for multipart form data (required by backend for this endpoint)
        return try await requestManager.uploadData(endPoint: endpoint)
    }

    func verifyUsername(_ username: String) async throws -> Bool {
        let endpoint = VerifyUsernameEndpoint(username: username)
        let result: VerifyUsernameResultModel = try await requestManager.request(endPoint: endpoint)
        return result.available
    }

    func fetchUser(userId: String) async throws -> FetchUserResultModel {
        let endpoint = FetchUserEndpoint(userId: userId)
        return try await requestManager.request(endPoint: endpoint)
    }

    func updateTempUserToUser(model: UpdateTempUserToUserRequestModel) async throws -> UpdateTempUserToUserResultModel {
        let endpoint = UpdateTempUserToUserEndpoint(userId: model.userId, gender: model.gender)
        return try await requestManager.request(endPoint: endpoint)
    }

    func logout(userId: String) async throws {
        let endpoint = LogoutEndpoint(userId: userId)
        let _: LogoutResultModel = try await requestManager.request(endPoint: endpoint)
    }

    func deleteUser() async throws {
        let endpoint = DeleteUserEndpoint()
        let _: DeleteUserResultModel = try await requestManager.request(endPoint: endpoint)
    }

    // MARK: - Face Liveness

    func createFaceLivenessSession(userId: String) async throws -> CreateFaceLivenessSessionResultModel {
        let endpoint = CreateFaceLivenessSessionEndpoint(userId: userId)
        return try await requestManager.request(endPoint: endpoint)
    }

    func getFaceLivenessSessionResults(sessionId: String) async throws -> GetFaceLivenessSessionResultsResultModel {
        let endpoint = GetFaceLivenessSessionResultsEndpoint(sessionId: sessionId)
        return try await requestManager.request(endPoint: endpoint)
    }

    func getFaceLivenessCredentials() async throws -> GetFaceLivenessCredentialsResultModel {
        let endpoint = GetFaceLivenessCredentialsEndpoint()
        return try await requestManager.request(endPoint: endpoint)
    }
}
