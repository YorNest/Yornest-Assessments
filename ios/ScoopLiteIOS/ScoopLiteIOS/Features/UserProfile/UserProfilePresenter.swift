import Foundation

// MARK: - State

enum UserProfileState: BaseState {
    case loaded(UserModel)
    case error(String)
}

// MARK: - Event

enum UserProfileEvent: BaseEvent {
    case showSignIn
}

// MARK: - Presenter

/// Displays user info from local cache and provides logout functionality.
/// User data is fetched and stored during login flow (like main app).
final class UserProfileViewPresenter: BasePresenter<UserProfileState, UserProfileEvent> {

    // MARK: - Dependencies

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - Lifecycle

    override func loaded() {
        // Load from cached data (like main app's CurrentUserPreviewProfilePresenter)
        if let user = UserManager.shared.userModel {
            updateState(.loaded(user))
        } else {
            // Fallback: construct from individual fields
            let user = UserModel(
                userId: UserManager.shared.userId,
                fullName: UserManager.shared.fullName,
                username: UserManager.shared.username,
                mobileNumber: UserManager.shared.mobileNumber
            )
            updateState(.loaded(user))
        }
    }

    // MARK: - Public Methods

    func logout() {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                try await self.authService.logout(userId: UserManager.shared.userId)
            } catch {
                // Ignore logout API errors - proceed with local logout anyway
                print("⚠️ Logout API error (proceeding anyway): \(error)")
            }

            // Clear local user data
            UserManager.shared.logout()

            await self.emitMainActorEvent(.showSignIn)
        }
    }

    func deleteAccount() {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                try await self.authService.deleteUser()

                // Clear local user data
                UserManager.shared.logout()

                await self.emitMainActorEvent(.showSignIn)
            } catch {
                print("❌ Delete account error: \(error)")
                await self.updateMainActorState(.error("Failed to delete account: \(error.localizedDescription)"))
            }
        }
    }
}

