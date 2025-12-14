import Foundation
import Swinject

/// Dependency Injection Container setup using Swinject.
/// 
/// This follows the same pattern as the main YorNest app's Container.swift.
/// All services and view controllers are registered here and resolved via the container.
final class DIContainer {
    
    static let shared = DIContainer()
    
    let container: Container
    
    private init() {
        container = Container()
        setupServices()
        setupViewControllers()
    }
    
    // MARK: - Services Registration

    private func setupServices() {
        // Request Manager (using real API calls)
        container.register(RequestManagerProtocol.self) { _ in
            RequestManager(useMockData: false)
        }.inObjectScope(.container)

        // Messages Service
        container.register(MessagesServiceProtocol.self) { r in
            let requestManager = r.resolve(RequestManagerProtocol.self)!
            return MessagesService(requestManager: requestManager)
        }.inObjectScope(.container)

        // Auth Service (using real service for API calls)
        container.register(AuthServiceProtocol.self) { r in
            let requestManager = r.resolve(RequestManagerProtocol.self)!
            return AuthService(requestManager: requestManager)
        }.inObjectScope(.container)
    }
    
    // MARK: - View Controllers Registration

    private func setupViewControllers() {
        setupAuthViewControllers()
        setupMainViewControllers()
    }

    private func setupAuthViewControllers() {
        // SignIn (Entry Router) - uses XIB
        container.register(SignInViewController.self) { _ in
            let controller = SignInViewController(nibName: "SignInViewController", bundle: nil)
            let coordinator = SignInCoordinator(view: controller)
            let presenter = SignInViewPresenter()
            controller.coordinator = coordinator
            controller.presenter = presenter
            return controller
        }

        // EnterPhone - uses XIB
        container.register(EnterPhoneViewController.self) { r in
            let authService = r.resolve(AuthServiceProtocol.self)!
            let controller = EnterPhoneViewController(nibName: "EnterPhoneViewController", bundle: nil)
            let coordinator = EnterPhoneCoordinator(view: controller)
            let presenter = EnterPhoneViewPresenter(authService: authService)
            controller.coordinator = coordinator
            controller.presenter = presenter
            return controller
        }

        // ConfirmPhoneNumber (OTP) - uses XIB
        container.register(ConfirmPhoneNumberViewController.self) { r in
            let authService = r.resolve(AuthServiceProtocol.self)!
            let controller = ConfirmPhoneNumberViewController(nibName: "ConfirmPhoneNumberViewController", bundle: nil)
            let coordinator = ConfirmPhoneNumberCoordinator(view: controller)
            let presenter = ConfirmPhoneNumberViewPresenter(authService: authService)
            controller.coordinator = coordinator
            controller.presenter = presenter
            return controller
        }

        // CreateName (Profile) - uses programmatic layout with SnapKit
        container.register(CreateNameViewController.self) { r in
            let authService = r.resolve(AuthServiceProtocol.self)!
            let controller = CreateNameViewController()
            let coordinator = CreateNameCoordinator(view: controller)
            let presenter = CreateNameViewPresenter(authService: authService)
            controller.coordinator = coordinator
            controller.presenter = presenter
            return controller
        }

        // FaceLiveness (Identity Verification) - uses programmatic layout with SnapKit + AWS SDK
        container.register(FaceLivenessViewController.self) { r in
            let authService = r.resolve(AuthServiceProtocol.self)!
            let controller = FaceLivenessViewController()
            let coordinator = FaceLivenessCoordinator(view: controller)
            let presenter = FaceLivenessViewPresenter(authService: authService)
            let credentialsProvider = LivenessCredentialsProvider(authService: authService)
            controller.coordinator = coordinator
            controller.presenter = presenter
            controller.credentialsProvider = credentialsProvider
            return controller
        }
    }

    private func setupMainViewControllers() {
        // Messages View Controller
        container.register(MessagesViewController.self) { r in
            let messagesService = r.resolve(MessagesServiceProtocol.self)!
            let controller = MessagesViewController()
            let coordinator = MessagesCoordinator(view: controller)
            let presenter = MessagesViewPresenter(messagesService: messagesService)
            controller.coordinator = coordinator
            controller.presenter = presenter
            return controller
        }

        // UserProfile View Controller (shows user info after successful auth)
        container.register(UserProfileViewController.self) { r in
            let authService = r.resolve(AuthServiceProtocol.self)!
            let controller = UserProfileViewController()
            let coordinator = UserProfileCoordinator(view: controller)
            let presenter = UserProfileViewPresenter(authService: authService)
            controller.coordinator = coordinator
            controller.presenter = presenter
            return controller
        }
    }
    
    // MARK: - Resolution Helpers
    
    /// Resolves a service or view controller from the container
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    /// Resolves a service or view controller from the container, force unwrapping
    func resolveRequired<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Failed to resolve \(type). Make sure it's registered in the container.")
        }
        return resolved
    }
}

// MARK: - Convenience Extensions

extension DIContainer {
    
    /// Creates the main Messages view controller
    static func createMessagesViewController() -> MessagesViewController {
        return shared.resolveRequired(MessagesViewController.self)
    }
}

