import UIKit

// MARK: - SignIn View Controller

/// Entry point view controller that routes user to appropriate auth screen.
/// Uses XIB for layout - matches main YorNest app pattern.
/// This is a simple splash screen that immediately routes to the appropriate screen.
final class SignInViewController: SLBaseViewController<SignInState, SignInEvent, SignInViewPresenter> {

    // MARK: Properties

    var coordinator: SignInCoordinator!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.entryInApp()
    }

    // MARK: - Setup

    override func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Update State

    override func update(with state: State) {
        switch state {
        case .idle:
            hideLoading()
        case .loading:
            showLoading()
        }
    }

    // MARK: - Handle Event

    override func handle(_ event: Event) {
        switch event {
        case .showEnterPhone:
            coordinator.showEnterPhone()
        case .showCreateName:
            coordinator.showCreateName()
        case .showFaceLiveness:
            coordinator.showFaceLiveness()
        case .showHome:
            coordinator.showHome()
        }
    }
}

