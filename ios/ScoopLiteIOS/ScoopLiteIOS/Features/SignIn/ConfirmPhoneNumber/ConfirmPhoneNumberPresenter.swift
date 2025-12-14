import Foundation

// MARK: - State

enum ConfirmPhoneNumberState: BaseState {
    case idle
    case loading
}

// MARK: - Event

enum ConfirmPhoneNumberEvent: BaseEvent {
    case showHome
    case showCreateName
    case resendCode
    case updateButton(Bool)
    case updateCodeNumber(String)
    case backVC
    case error(String)
    case errorCode
    case errorManyRequest
}

// MARK: - Presenter

/// Handles OTP verification.
/// 
/// Flow:
/// 1. User enters 6-digit code
/// 2. Presenter calls verifyOTP API
/// 3. On success, checks if user has profile
/// 4. Navigates to CreateName or Messages based on profile state
final class ConfirmPhoneNumberViewPresenter: BasePresenter<ConfirmPhoneNumberState, ConfirmPhoneNumberEvent> {
    
    // MARK: - Dependencies
    
    private let authService: AuthServiceProtocol
    
    // MARK: - Properties
    
    var session: String?
    var number: String?
    private var verifyTask: Task<Void, Never>?
    
    // MARK: - Init
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    // MARK: - Lifecycle
    
    override func loaded() {
        updateState(.idle)
    }
    
    // MARK: - Public Methods

    /// Updates button state based on code length
    func updateButton(code: String) {
        emitEvent(.updateButton(code.count == 6))
    }

    /// Called when OTP code is submitted
    func fill(code: String) {
        emitEvent(.updateCodeNumber(code))

        if code.count == 6 {
            emitEvent(.updateButton(true))
            updateState(.loading)
            sendCodeVerification(codeVerification: code)
        } else {
            emitEvent(.updateButton(false))
        }
    }
    
    /// Resends the verification code
    func resendCode() {
        guard let number = number else { return }
        
        updateState(.loading)
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let model = AuthenticateUserRequestModel(mobileNumber: number)
                let result = try await self.authService.authenticateUser(model: model)
                
                self.session = result.session
                await self.emitMainActorEvent(.resendCode)
                await self.updateMainActorState(.idle)
            } catch {
                await self.emitMainActorEvent(.error("Failed to resend code"))
                await self.updateMainActorState(.idle)
            }
        }
    }
    
    /// Navigates back to phone entry
    func goBack() {
        emitEvent(.backVC)
    }
    
    // MARK: - Private Methods
    
    private func sendCodeVerification(codeVerification: String) {
        guard let session = session, let number = number else {
            emitEvent(.error("Session expired"))
            return
        }
        
        verifyTask?.cancel()
        verifyTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let model = VerifyOTPRequestModel(
                    session: UserManager.shared.session ?? session,
                    code: codeVerification,
                    context: "auth",
                    contact: number,
                    userId: UserManager.shared.userId,
                    type: "sms"
                )
                
                let result = try await self.authService.verifyOTP(model: model)

                UserManager.shared.session = nil
                UserManager.shared.accessToken = result.accessToken ?? ""
                UserManager.shared.refreshToken = result.refreshToken ?? ""
                UserManager.shared.mobileNumber = number

                #if DEBUG
                print("🔐 [OTP VERIFIED] AccessToken: \(result.accessToken?.prefix(20) ?? "nil")...")
                print("🔐 [OTP VERIFIED] UserManager.accessToken: \(UserManager.shared.accessToken.prefix(20))...")
                #endif

                // Update global auth interceptor with new credentials (like main app)
                authInterceptor.credential = JWTCredential(
                    accessToken: result.accessToken ?? "",
                    refreshToken: result.refreshToken ?? ""
                )

                #if DEBUG
                print("🔐 [OTP VERIFIED] Interceptor credential updated: \(authInterceptor.credential?.accessToken.prefix(20) ?? "nil")...")
                #endif

                // Fetch and store user data before navigating (like main app)
                await self.fetchUser()
            } catch let error as AuthError {
                await self.updateMainActorState(.idle)
                if case .invalidCode = error {
                    await self.emitMainActorEvent(.errorCode)
                } else {
                    await self.emitMainActorEvent(.error(error.localizedDescription))
                }
            } catch {
                await self.updateMainActorState(.idle)
                await self.emitMainActorEvent(.error("Verification failed"))
            }
        }
    }

    /// Fetches user data and stores it locally before navigating (like main app)
    /// Routes to CreateName for new users, Home for existing users
    private func fetchUser() async {
        do {
            let result = try await authService.fetchUser(userId: UserManager.shared.userId)

            if let user = result.user {
                // Store user data in UserManager (like main app's saveData)
                UserManager.shared.saveData(user: user)
            }

            await updateMainActorState(.idle)

            // Explicitly set type before routing check (like main app line 165)
            UserManager.shared.type = result.user?.type?.rawValue ?? ""

            // Check if user profile is incomplete (like main app's logic)
            // New users need to complete profile via CreateName screen
            // IMPORTANT: Also check for type == .unknown (matches main app line 166)
            if result.user?.username?.isEmpty ?? true || result.user?.fullName?.isEmpty ?? true || result.user?.type == .unknown {
                await emitMainActorEvent(.showCreateName)
            } else {
                await emitMainActorEvent(.showHome)
            }
        } catch {
            print("❌ fetchUser error: \(error)")
            await updateMainActorState(.idle)
            // On error, assume new user and go to CreateName
            await emitMainActorEvent(.showCreateName)
        }
    }
}

