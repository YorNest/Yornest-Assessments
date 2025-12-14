import UIKit
import DialCountries

// MARK: - EnterPhone Coordinator

/// Handles navigation from the phone entry screen.
/// Matches main YorNest app's EnterPhoneCoordinator.
final class EnterPhoneCoordinator {

    // MARK: - Properties

    private weak var view: UIViewController?

    // MARK: - Init

    init(view: UIViewController) {
        self.view = view
    }

    // MARK: - Navigation

    func showConfirmPhoneNumber(_ session: String, _ number: String) {
        guard let vc = DIContainer.shared.resolve(ConfirmPhoneNumberViewController.self) else { return }
        vc.presenter.session = session
        vc.presenter.number = number
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func showCountries(delegate: DialCountriesControllerDelegate) {
        let countriesController = DialCountriesController(locale: Locale(identifier: "en"))
        countriesController.delegate = delegate
        countriesController.show(vc: view!)
    }

    func showTermsPolicy(_ isPrivacy: Bool) {
        // ScoopLite simplified: open URLs directly
        // In main app, this shows TermsPolicyViewController
        let urlString = isPrivacy
            ? "https://www.scoop.chat/privacy"
            : "https://www.scoop.chat/terms"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

