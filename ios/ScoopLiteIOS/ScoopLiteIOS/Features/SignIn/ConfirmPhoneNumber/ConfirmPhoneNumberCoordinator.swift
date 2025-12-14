import UIKit

// MARK: - ConfirmPhoneNumber Coordinator

/// Handles navigation from the OTP verification screen.
final class ConfirmPhoneNumberCoordinator {
    
    // MARK: - Properties
    
    private weak var view: UIViewController?
    
    // MARK: - Init
    
    init(view: UIViewController) {
        self.view = view
    }
    
    // MARK: - Navigation
    
    func showCreateName() {
        guard let vc = DIContainer.shared.resolve(CreateNameViewController.self) else { return }
        view?.navigationController?.pushViewController(vc, animated: true)
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

