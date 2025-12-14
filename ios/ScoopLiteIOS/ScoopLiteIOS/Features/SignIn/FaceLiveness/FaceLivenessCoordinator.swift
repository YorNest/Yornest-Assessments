import UIKit

// MARK: - FaceLiveness Coordinator

/// Handles navigation from the Face Liveness verification screen.
final class FaceLivenessCoordinator {

    // MARK: - Properties

    private weak var view: UIViewController?

    // MARK: - Init

    init(view: UIViewController) {
        self.view = view
    }

    // MARK: - Navigation

    func goBack() {
        #if DEBUG
        print("🔙 [FaceLiveness.goBack] Called")
        #endif

        // Go back to CreateName screen
        view?.navigationController?.popViewController(animated: true)
    }

    func showHome() {
        #if DEBUG
        print("🏠 [FaceLiveness.showHome] Navigating to UserProfile")
        #endif

        guard let vc = DIContainer.shared.resolve(UserProfileViewController.self) else {
            #if DEBUG
            print("❌ [FaceLiveness.showHome] Failed to resolve UserProfileViewController")
            #endif
            return
        }

        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(navController, animated: false) { [weak self] in
            // Clear the navigation stack after presenting
            self?.view?.navigationController?.popToRootViewController(animated: false)
        }
    }
}

