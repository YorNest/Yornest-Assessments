import UIKit

// MARK: - UserProfile Coordinator

/// Handles navigation from the user profile screen.
final class UserProfileCoordinator {

    // MARK: - Properties

    private weak var view: UIViewController?

    // MARK: - Init

    init(view: UIViewController) {
        self.view = view
    }

    // MARK: - Navigation

    func showSignIn() {
        // Dismiss current view and return to sign in
        guard let vc = DIContainer.shared.resolve(SignInViewController.self) else { return }
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navController.isNavigationBarHidden = true

        // Get the presenting view controller's window scene
        if let windowScene = view?.view.window?.windowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}

