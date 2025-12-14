import UIKit

// MARK: - SignIn Coordinator

/// Handles navigation from the SignIn entry point screen.
final class SignInCoordinator {
    
    // MARK: - Properties
    
    private weak var view: UIViewController?
    
    // MARK: - Init
    
    init(view: UIViewController) {
        self.view = view
    }
    
    // MARK: - Navigation
    
    func showEnterPhone() {
        guard let vc = DIContainer.shared.resolve(EnterPhoneViewController.self) else { return }
        view?.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showCreateName() {
        guard let vc = DIContainer.shared.resolve(CreateNameViewController.self) else { return }
        view?.navigationController?.pushViewController(vc, animated: false)
    }

    func showFaceLiveness() {
        guard let vc = DIContainer.shared.resolve(FaceLivenessViewController.self) else { return }
        view?.navigationController?.pushViewController(vc, animated: false)
    }

    func showHome() {
        guard let vc = DIContainer.shared.resolve(UserProfileViewController.self) else { return }
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(navController, animated: false) { [weak self] in
            self?.view?.navigationController?.popToRootViewController(animated: false)
        }
    }
}

