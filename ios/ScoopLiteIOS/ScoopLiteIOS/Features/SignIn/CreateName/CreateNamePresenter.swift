import Foundation
import UIKit
import UserNotifications

// MARK: - State

enum CreateNameState: BaseState {
    case startAnimating
    case valideUsername(String)
}

// MARK: - Event

enum CreateNameEvent: BaseEvent {
    case showHome
    case showNotificationSettings
    case updateButton(Bool)
    case chooseImage
    case updateImage(UIImage)
    case errorMissingName
    case errorMissingUsername
    case errorUsernameTaken
    case errorValidation
    case internetError
    case error
}

// MARK: - Presenter

/// Handles profile creation with first name, last name, and username.
/// Matches main YorNest app's CreateNameViewPresenter.
final class CreateNameViewPresenter: BasePresenter<CreateNameState, CreateNameEvent> {

    // MARK: Properties

    private let authService: AuthServiceProtocol

    private var firstName: String = ""
    private var lastName: String = ""
    private var username: String = ""
    private var profileImage: UIImage?
    private var isUsernameValid: Bool = false
    private var updateTask: Task<Void, Never>?
    private var usernameCheckTask: Task<Void, Never>?

    // MARK: Init

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: Lifecycle

    override func loaded() {
        // No initial state needed - matching main app
    }

    // MARK: Methods

    func chooseImage() {
        emitEvent(.chooseImage)
    }

    func updateImage(image: UIImage) {
        profileImage = image
        emitEvent(.updateImage(image))
        validateForm()
    }

    func shouldChange(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        let newString = text.replacingCharacters(in: textRange, with: string)

        switch textField.tag {
        case 0: // First name
            firstName = newString
        case 1: // Last name
            lastName = newString
        case 2: // Username
            username = newString.lowercased().replacingOccurrences(of: " ", with: "")
            checkUsernameAvailability()
        default:
            break
        }

        validateForm()
        return true
    }

    func signUp() {
        guard !firstName.isEmpty else {
            emitEvent(.errorMissingName)
            return
        }

        guard !username.isEmpty else {
            emitEvent(.errorMissingUsername)
            return
        }

        guard isUsernameValid else {
            emitEvent(.errorUsernameTaken)
            return
        }

        updateState(.startAnimating)

        updateTask?.cancel()
        updateTask = Task { [weak self] in
            guard let self = self else { return }

            do {
                let model = UpdateProfileRequestModel(
                    userId: UserManager.shared.userId,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    username: self.username
                )

                // Convert profile image to JPEG data for upload
                let imageData = self.profileImage?.jpegData(compressionQuality: 0.8)

                _ = try await self.authService.updateProfile(model: model, imageData: imageData)

                // Call updateTempUserToUser to convert temp user to full user (matching main app)
                let tempUserModel = UpdateTempUserToUserRequestModel(userId: UserManager.shared.userId)
                _ = try await self.authService.updateTempUserToUser(model: tempUserModel)

                // Fetch updated user data and save to UserManager
                let fetchResult = try await self.authService.fetchUser(userId: UserManager.shared.userId)
                if let user = fetchResult.user {
                    UserManager.shared.saveData(user: user)
                } else {
                    // Fallback: manually update fields
                    let fullName = "\(self.firstName) \(self.lastName)".trimmingCharacters(in: .whitespaces)
                    UserManager.shared.fullName = fullName
                    UserManager.shared.username = self.username
                }

                // Check notification permission before going to Home (matching main app)
                await self.checkNotificationAndNavigate()
            } catch let error as RequestAPIError {
                await self.handleSignUpError(error)
            } catch {
                await self.emitMainActorEvent(.error)
            }
        }
    }

    // MARK: Private Methods

    private func checkNotificationAndNavigate() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        if settings.authorizationStatus == .notDetermined {
            await emitMainActorEvent(.showNotificationSettings)
        } else {
            await emitMainActorEvent(.showHome)
        }
    }

    private func handleSignUpError(_ error: RequestAPIError) async {
        switch error {
        case .internetError:
            await emitMainActorEvent(.internetError)
        default:
            await emitMainActorEvent(.error)
        }
    }

    private func validateForm() {
        let isValid = !firstName.isEmpty && !username.isEmpty && isUsernameValid
        emitEvent(.updateButton(isValid))
    }

    private func checkUsernameAvailability() {
        guard !username.isEmpty else {
            isUsernameValid = false
            updateState(.valideUsername(""))
            return
        }

        // Validate username format
        let usernameWithoutAt = username.replacingOccurrences(of: "@", with: "")
        if usernameWithoutAt.isEmpty || !isValidUserName(usernameWithoutAt) {
            isUsernameValid = false
            updateState(.valideUsername("Username is not valid"))
            return
        }

        // Don't make API call if no auth token (user not logged in properly)
        guard !UserManager.shared.accessToken.isEmpty else {
            #if DEBUG
            print("⚠️ [verifyUsername] Skipping - no access token")
            #endif
            isUsernameValid = false
            updateState(.valideUsername("Please complete sign-in first"))
            return
        }

        usernameCheckTask?.cancel()
        usernameCheckTask = Task { [weak self] in
            guard let self = self else { return }

            // Debounce: wait 300ms before making request (rate limiting handled by RequestManager)
            try? await Task.sleep(nanoseconds: 300_000_000)  // 0.3s

            guard !Task.isCancelled else { return }

            do {
                let isAvailable = try await self.authService.verifyUsername(self.username)
                self.isUsernameValid = isAvailable

                if isAvailable {
                    await self.updateMainActorState(.valideUsername(""))
                } else {
                    await self.updateMainActorState(.valideUsername("Username is taken"))
                }
                self.validateForm()
            } catch {
                #if DEBUG
                print("❌ [verifyUsername ERROR] \(error)")
                #endif
                self.isUsernameValid = false
                await self.updateMainActorState(.valideUsername("Unable to verify"))
            }
        }
    }

    private func isValidUserName(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
}

