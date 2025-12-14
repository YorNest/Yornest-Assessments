import UIKit

// MARK: - CreateName Coordinator

/// Handles navigation from the profile creation screen.
final class CreateNameCoordinator {

    // MARK: - Properties

    private weak var view: UIViewController?

    // MARK: - Init

    init(view: UIViewController) {
        self.view = view
    }

    // MARK: - Navigation

    func goBack() {
        #if DEBUG
        print("🔙 [goBack] Called")
        print("🔙 [goBack] view: \(String(describing: view))")
        print("🔙 [goBack] navigationController: \(String(describing: view?.navigationController))")
        print("🔙 [goBack] viewControllers count: \(view?.navigationController?.viewControllers.count ?? 0)")
        #endif

        // Clear auth state so user can start fresh
        UserManager.shared.accessToken = ""
        UserManager.shared.refreshToken = ""
        UserManager.shared.session = nil
        UserManager.shared.mobileNumber = ""
        UserManager.shared.userId = ""

        // Reset auth interceptor
        authInterceptor.credential = JWTCredential(accessToken: "", refreshToken: "")

        // Pop to root (EnterPhone screen)
        view?.navigationController?.popToRootViewController(animated: true)
    }

    func showHome() {
        guard let vc = DIContainer.shared.resolve(UserProfileViewController.self) else { return }
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(navController, animated: false) { [weak self] in
            self?.view?.navigationController?.popToRootViewController(animated: false)
        }
    }

    func showNotificationSettings() {
        // For ScoopLite, we skip notification settings and go directly to Home
        // In the main app, this would show a notification permission screen
        showHome()
    }
}

