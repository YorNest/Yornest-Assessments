import Foundation

// MARK: - State

enum FaceLivenessState: BaseState {
    case loading
    case sessionReady(sessionId: String)
    case verifying
    case success
    case failed(message: String)
}

// MARK: - Event

enum FaceLivenessEvent: BaseEvent {
    case showHome
    case showRetry
    case error(message: String)
    case internetError
}

// MARK: - Presenter

/// Handles Face Liveness verification flow with AWS Rekognition.
/// 
/// Flow:
/// 1. Create liveness session via BE → get sessionId
/// 2. Present AWS FaceLivenessDetector with sessionId
/// 3. On completion, get results from BE
/// 4. If passed, navigate to Home; if failed, show retry option
final class FaceLivenessViewPresenter: BasePresenter<FaceLivenessState, FaceLivenessEvent> {

    // MARK: Properties

    private let authService: AuthServiceProtocol
    private var sessionId: String?
    private var createSessionTask: Task<Void, Never>?
    private var verifyResultsTask: Task<Void, Never>?

    // MARK: Init

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: Lifecycle

    override func loaded() {
        createLivenessSession()
    }

    // MARK: Public Methods

    /// Creates a new liveness session with the backend
    func createLivenessSession() {
        updateState(.loading)

        createSessionTask?.cancel()
        createSessionTask = Task { [weak self] in
            guard let self = self else { return }

            do {
                let userId = UserManager.shared.userId
                let result = try await self.authService.createFaceLivenessSession(userId: userId)

                guard let sessionId = result.sessionId else {
                    throw AuthError.serverError(result.error ?? "Failed to create session")
                }

                self.sessionId = sessionId
                #if DEBUG
                print("✅ [FaceLiveness] Session created: \(sessionId)")
                #endif

                await self.updateMainActorState(.sessionReady(sessionId: sessionId))
            } catch let error as RequestAPIError {
                await self.handleError(error)
            } catch {
                #if DEBUG
                print("❌ [FaceLiveness] Error creating session: \(error)")
                #endif
                await self.emitMainActorEvent(.error(message: "Failed to start verification"))
            }
        }
    }

    /// Called when the AWS SDK liveness check completes
    func onLivenessCheckComplete(isSuccess: Bool) {
        if isSuccess {
            verifySessionResults()
        } else {
            updateState(.failed(message: "Liveness check was not completed"))
            emitEvent(.showRetry)
        }
    }

    /// Called when the AWS SDK liveness check fails with an error
    func onLivenessCheckError(_ error: Error) {
        #if DEBUG
        print("❌ [FaceLiveness] SDK Error: \(error)")
        #endif
        updateState(.failed(message: error.localizedDescription))
        emitEvent(.showRetry)
    }

    /// Retry the liveness check
    func retry() {
        createLivenessSession()
    }

    // MARK: Private Methods

    private func verifySessionResults() {
        guard let sessionId = sessionId else {
            emitEvent(.error(message: "No session ID"))
            return
        }

        updateState(.verifying)

        verifyResultsTask?.cancel()
        verifyResultsTask = Task { [weak self] in
            guard let self = self else { return }

            do {
                let result = try await self.authService.getFaceLivenessSessionResults(sessionId: sessionId)

                #if DEBUG
                print("✅ [FaceLiveness] Results: isLive=\(result.isLive ?? false), confidence=\(result.confidence ?? 0)")
                #endif

                if result.isLive == true {
                    // Mark liveness as verified so user can't skip by closing app
                    await MainActor.run {
                        UserManager.shared.livenessVerified = true
                    }
                    await self.updateMainActorState(.success)
                    await self.emitMainActorEvent(.showHome)
                } else {
                    let message = "Face verification failed (confidence: \(Int(result.confidence ?? 0))%)"
                    await self.updateMainActorState(.failed(message: message))
                    await self.emitMainActorEvent(.showRetry)
                }
            } catch let error as RequestAPIError {
                await self.handleError(error)
            } catch {
                #if DEBUG
                print("❌ [FaceLiveness] Error verifying results: \(error)")
                #endif
                await self.emitMainActorEvent(.error(message: "Failed to verify results"))
            }
        }
    }

    private func handleError(_ error: RequestAPIError) async {
        switch error {
        case .internetError:
            await emitMainActorEvent(.internetError)
        default:
            await emitMainActorEvent(.error(message: "Something went wrong"))
        }
    }
}

