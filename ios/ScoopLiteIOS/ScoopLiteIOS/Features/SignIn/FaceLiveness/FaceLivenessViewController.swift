import UIKit
import SnapKit
import SwiftUI
import FaceLiveness

// MARK: - FaceLiveness View Controller

/// Face Liveness verification screen using AWS Rekognition.
///
/// This screen:
/// 1. Shows a custom photosensitivity warning
/// 2. Creates a liveness session via BE
/// 3. Presents the AWS FaceLivenessDetector SwiftUI view
/// 4. Gets results from BE and navigates accordingly
final class FaceLivenessViewController: SLBaseViewController<FaceLivenessState, FaceLivenessEvent, FaceLivenessViewPresenter> {

    // MARK: UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify Your Identity"
        label.font = AppFonts.bold_24
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Position your face in the frame and follow the on-screen instructions"
        label.font = AppFonts.regular_16
        label.textColor = UIColor(white: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.medium_16
        label.textColor = UIColor(white: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.text = "Preparing..."
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = AppFonts.semibold_16
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.isHidden = true
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()



    private lazy var livenessContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    // MARK: Photosensitivity Warning Views

    private lazy var warningOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.isHidden = true
        return view
    }()

    private lazy var warningContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()

    private lazy var warningEmojiLabel: UILabel = {
        let label = UILabel()
        label.text = "⚠️"
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        return label
    }()

    private lazy var warningTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photosensitivity Warning"
        label.font = AppFonts.bold_20
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private lazy var warningDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "This verification uses flashing colors. If you have photosensitive epilepsy, please consult your doctor before proceeding."
        label.font = AppFonts.regular_16
        label.textColor = UIColor(white: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var warningContinueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I Understand", for: .normal)
        button.titleLabel?.font = AppFonts.semibold_16
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(warningContinueTapped), for: .touchUpInside)
        return button
    }()

    private lazy var warningCancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go Back", for: .normal)
        button.titleLabel?.font = AppFonts.medium_16
        button.setTitleColor(UIColor(white: 0.4, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(warningCancelTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Properties

    var coordinator: FaceLivenessCoordinator!
    var credentialsProvider: LivenessCredentialsProvider!
    private var livenessHostingController: UIHostingController<AnyView>?
    private var hasShownWarning = false
    private var pendingSessionId: String?

    // MARK: LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    // MARK: - Setup

    override func setupUI() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(livenessContainerView)
        view.addSubview(statusLabel)
        view.addSubview(retryButton)

        // Warning overlay (added last to be on top)
        view.addSubview(warningOverlayView)
        warningOverlayView.addSubview(warningContentView)
        warningContentView.addSubview(warningEmojiLabel)
        warningContentView.addSubview(warningTitleLabel)
        warningContentView.addSubview(warningDescriptionLabel)
        warningContentView.addSubview(warningContinueButton)
        warningContentView.addSubview(warningCancelButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
        }

        // Make container square for perfect circle
        livenessContainerView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(livenessContainerView.snp.width)  // Square aspect ratio
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(livenessContainerView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }

        retryButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }

        // Warning overlay constraints
        warningOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        warningContentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
        }

        warningEmojiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }

        warningTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(warningEmojiLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
        }

        warningDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(warningTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }

        warningContinueButton.snp.makeConstraints { make in
            make.top.equalTo(warningDescriptionLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }

        warningCancelButton.snp.makeConstraints { make in
            make.top.equalTo(warningContinueButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    // MARK: - Update State

    override func update(with state: State) {
        switch state {
        case .loading:
            showLoading()
            statusLabel.text = "Preparing verification..."
            statusLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
            retryButton.isHidden = true
            removeLivenessView()

        case .sessionReady(let sessionId):
            hideLoading()
            retryButton.isHidden = true
            // Show photosensitivity warning before starting
            if !hasShownWarning {
                pendingSessionId = sessionId
                showPhotosensitivityWarning()
                statusLabel.text = "Ready to verify"
                statusLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
            } else {
                statusLabel.text = ""
                presentLivenessDetector(sessionId: sessionId)
            }

        case .verifying:
            showLoading()
            statusLabel.text = "Verifying your identity..."
            statusLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
            retryButton.isHidden = true
            removeLivenessView()

        case .success:
            hideLoading()
            statusLabel.text = "Verification successful"
            statusLabel.textColor = UIColor(red: 0.2, green: 0.7, blue: 0.4, alpha: 1.0)
            retryButton.isHidden = true

        case .failed(let message):
            hideLoading()
            statusLabel.text = message
            statusLabel.textColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
            retryButton.isHidden = false
        }
    }

    // MARK: - Handle Event

    override func handle(_ event: Event) {
        switch event {
        case .showHome:
            coordinator.showHome()

        case .showRetry:
            retryButton.isHidden = false

        case .error(let message):
            hideLoading()
            showErrorBanner(error: message)

        case .internetError:
            hideLoading()
            showErrorBanner(error: "No internet connection")
        }
    }

    // MARK: - Actions

    @objc private func retryButtonTapped(_ sender: Any) {
        hasShownWarning = false  // Reset warning for retry
        presenter.retry()
    }

    @objc private func warningContinueTapped(_ sender: Any) {
        hidePhotosensitivityWarning()
        hasShownWarning = true
        if let sessionId = pendingSessionId {
            statusLabel.text = ""
            presentLivenessDetector(sessionId: sessionId)
        }
    }

    @objc private func warningCancelTapped(_ sender: Any) {
        // Just close the warning - user must proceed with verification
        // They can retry later by tapping outside or re-opening the screen
        hidePhotosensitivityWarning()
    }

    // MARK: - Photosensitivity Warning

    private func showPhotosensitivityWarning() {
        warningOverlayView.alpha = 0
        warningOverlayView.isHidden = false
        warningContentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.warningOverlayView.alpha = 1
            self.warningContentView.transform = .identity
        }
    }

    private func hidePhotosensitivityWarning() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.warningOverlayView.alpha = 0
            self.warningContentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.warningOverlayView.isHidden = true
        }
    }

    // MARK: - Liveness Detector

    private func presentLivenessDetector(sessionId: String) {
        removeLivenessView()

        // Create the FaceLivenessDetector SwiftUI view with custom credentials provider
        // disableStartView: true skips AWS's built-in start screen since we have our own warning
        let livenessView = FaceLivenessDetectorView(
            sessionID: sessionId,
            credentialsProvider: credentialsProvider,
            region: "us-east-1",  // Match your AWS region
            disableStartView: true,  // Skip AWS start view, we show our own warning
            isPresented: .constant(true),
            onCompletion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.presenter.onLivenessCheckComplete(isSuccess: true)
                    case .failure(let error):
                        self?.presenter.onLivenessCheckError(error)
                    }
                }
            }
        )

        let hostingController = UIHostingController(rootView: AnyView(livenessView))
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        livenessContainerView.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
        livenessHostingController = hostingController
    }

    private func removeLivenessView() {
        livenessHostingController?.willMove(toParent: nil)
        livenessHostingController?.view.removeFromSuperview()
        livenessHostingController?.removeFromParent()
        livenessHostingController = nil
    }
}

