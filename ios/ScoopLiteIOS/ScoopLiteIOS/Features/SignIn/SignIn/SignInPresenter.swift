import Foundation

// MARK: - State

enum SignInState: BaseState {
    case idle
    case loading
}

// MARK: - Event

enum SignInEvent: BaseEvent {
    case showEnterPhone
    case showCreateName
    case showFaceLiveness
    case showHome
}

// MARK: - Presenter

/// Entry point presenter that routes user to appropriate screen based on auth state.
///
/// This matches the main YorNest app's SignInPresenter behavior exactly:
/// - If user has no mobile number stored → EnterPhone
/// - If user type is unknown → Logout and EnterPhone
/// - If user has no fullName → CreateName
/// - If user has no username AND no profileImage → CreateName
/// - If user has no tokens → Logout and EnterPhone
/// - Otherwise → Home (Messages)
final class SignInViewPresenter: BasePresenter<SignInState, SignInEvent> {

    // MARK: - Lifecycle

    override func loaded() {
        updateState(.idle)
    }

    // MARK: - Public Methods

    /// Determines which screen to show based on current auth state.
    /// Matches main YorNest app's entryInApp() logic exactly, plus liveness check.
    func entryInApp() {
        if !UserManager.shared.mobileNumber.isEmpty {
            if UserModelType(rawValue: UserManager.shared.type) == .unknown {
                LogoutHelper.removeUserData()
                emitEvent(.showEnterPhone)
            } else if UserManager.shared.fullName.isEmpty {
                emitEvent(.showCreateName)
            } else if UserManager.shared.username.isEmpty && UserManager.shared.profileImage.isEmpty {
                emitEvent(.showCreateName)
            } else if UserManager.shared.accessToken.isEmpty || UserManager.shared.refreshToken.isEmpty {
                LogoutHelper.removeUserData()
                emitEvent(.showEnterPhone)
            } else if !UserManager.shared.livenessVerified {
                // User must complete face liveness verification before accessing home
                emitEvent(.showFaceLiveness)
            } else {
                emitEvent(.showHome)
            }
        } else {
            LogoutHelper.removeUserData()
            emitEvent(.showEnterPhone)
        }
    }
}

// MARK: - Logout Helper

/// Helper to clear user data on logout or fresh start
enum LogoutHelper {
    static func removeUserData() {
        UserManager.shared.logout()
    }
}

