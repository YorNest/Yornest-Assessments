import UIKit
import NVActivityIndicatorView
import SnapKit

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
    
    /// Shows an error banner at the top of the screen
    func showErrorBanner(message: String) {
        // Simple toast-like error banner
        let banner = UILabel()
        banner.text = message
        banner.textColor = .white
        banner.backgroundColor = .systemRed
        banner.textAlignment = .center
        banner.font = .systemFont(ofSize: 14, weight: .medium)
        banner.layer.cornerRadius = 8
        banner.clipsToBounds = true
        
        view.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        // Auto-dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.3) {
                banner.alpha = 0
            } completion: { _ in
                banner.removeFromSuperview()
            }
        }
    }
}

