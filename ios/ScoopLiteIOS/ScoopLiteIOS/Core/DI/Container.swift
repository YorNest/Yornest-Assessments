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
        // Request Manager
        container.register(RequestManagerProtocol.self) { _ in
            RequestManager(useMockData: true)
        }.inObjectScope(.container)
        
        // Messages Service
        container.register(MessagesServiceProtocol.self) { r in
            let requestManager = r.resolve(RequestManagerProtocol.self)!
            return MessagesService(requestManager: requestManager)
        }.inObjectScope(.container)
    }
    
    // MARK: - View Controllers Registration
    
    private func setupViewControllers() {
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

