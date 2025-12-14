import UIKit
import NVActivityIndicatorView
import SnapKit
import Toast_Swift

// MARK: - AlertWithTwoButtonType

/// Simplified version of main app's AlertWithTwoButtonType for ScoopLite
enum AlertWithTwoButtonType {
    case tooManyRequests

    var title: String {
        switch self {
        case .tooManyRequests:
            return "Too many requests"
        }
    }

    var description: String {
        switch self {
        case .tooManyRequests:
            return "Hey there, you sent too many requests. To ensure we protect your account, please contact support below."
        }
    }

    var leftTitleButton: String {
        return "Cancel"
    }

    var rightTitleButton: String {
        switch self {
        case .tooManyRequests:
            return "Support"
        }
    }
}

/// App-specific base view controller with common UI functionality.
/// 
/// Extends BaseViewController with:
/// - Activity indicator for loading states
/// - Error banner display
/// - Theme support
///
/// This matches the pattern used in the main YorNest app (AGBaseViewController).
class SLBaseViewController<S, E, P>: BaseViewController<S, E, P>
where S: BaseState, E: BaseEvent, P: BasePresenter<S, E> {
    
    // MARK: - UI Components
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero)
        indicator.color = .systemBlue
        indicator.type = .circleStrokeSpin
        return indicator
    }()
    
    private lazy var activityOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        applyTheme()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyTheme()
    }
    
    // MARK: - Setup
    
    private func setupActivityIndicator() {
        view.addSubview(activityOverlay)
        activityOverlay.addSubview(activityIndicator)
        
        activityOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
    }
    
    // MARK: - Theme
    
    /// Override to apply custom theming
    func applyTheme() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Loading State
    
    /// Shows the activity indicator overlay
    func showLoading() {
        activityOverlay.isHidden = false
        activityIndicator.startAnimating()
        view.bringSubviewToFront(activityOverlay)
    }
    
    /// Hides the activity indicator overlay
    func hideLoading() {
        activityOverlay.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Error Handling
    
    /// Shows an error alert with the given error
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    /// Shows an error banner at the top of the screen (matches main app style)
    func showErrorBanner(error: String? = nil, isInternetProblem: Bool = false) {
        var title = error ?? "Something went wrong"
        if isInternetProblem {
            title = "Your internet is offline"
        }

        var style = ToastStyle()
        style.backgroundColor = .black
        style.messageColor = .white
        style.messageFont = .systemFont(ofSize: 15, weight: .regular)
        style.messageAlignment = .center
        style.horizontalPadding = 12
        style.verticalPadding = 12

        navigationController?.view.makeToast(
            title,
            duration: 3.0,
            position: .top,
            style: style
        )

        // Round the corners to make it pill-shaped like the main app
        if let toastView = navigationController?.view.subviews.last {
            toastView.layer.cornerRadius = toastView.frame.height / 2
            toastView.clipsToBounds = true
        }
    }

    // MARK: - Alert with Two Buttons

    /// Shows an alert with two buttons (matching main app's showAlertWithToButtons)
    func showAlertWithTwoButtons(
        type: AlertWithTwoButtonType,
        completion: ((Bool) -> Void)?
    ) {
        let alert = UIAlertController(
            title: type.title,
            message: type.description,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: type.rightTitleButton, style: .destructive) { _ in
            completion?(true)
        }
        let cancel = UIAlertAction(title: type.leftTitleButton, style: .default) { _ in
            completion?(false)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(Colors.segmentColor, forKey: "titleTextColor")
        present(alert, animated: true, completion: nil)
    }
}

