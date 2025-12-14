import UIKit
import Toast_Swift

// MARK: - ConfirmPhoneNumber View Controller

/// OTP code entry screen for phone verification.
/// Uses XIB for layout - matches main YorNest app pattern.
final class ConfirmPhoneNumberViewController: SLBaseViewController<ConfirmPhoneNumberState, ConfirmPhoneNumberEvent, ConfirmPhoneNumberViewPresenter> {

    // MARK: IBOutlets

    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var codeTextField: UITextField!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var nextButton: LoadingButton!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var icMainTopConstraint: NSLayoutConstraint!
    @IBOutlet private var titleLabelTopConstraint: NSLayoutConstraint!

    // MARK: Properties

    var coordinator: ConfirmPhoneNumberCoordinator!
    private var code: String = ""

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        codeTextField.becomeFirstResponder()
    }

    // MARK: - Setup

    override func setupUI() {
        view.backgroundColor = .white

        // Back button - set image programmatically
        backButton.setImage(UIImage(named: "ic_back"), for: .normal)

        // Title - matches main app
        titleLabel.text = "We texted you the code"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black

        // Code text field
        codeTextField.backgroundColor = .clear
        codeTextField.font = .systemFont(ofSize: 18, weight: .regular)
        codeTextField.keyboardType = .numberPad
        codeTextField.textContentType = .oneTimeCode
        codeTextField.textColor = .black
        codeTextField.textAlignment = .left
        codeTextField.delegate = self

        // Description with "Resend Code" underlined in red
        let fullText = "Didn't receive it? Resend Code"
        descriptionLabel.text = fullText
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .black
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.setUnderline(
            with: fullText,
            subtext: "Resend Code",
            color: Colors.segmentColor,
            font: AppFonts.semibold_14
        )
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendTapped)))

        contentView.layer.cornerRadius = 12.0
        contentView.clipsToBounds = true

        nextButton.alpha = 0.1
        nextButton.isUserInteractionEnabled = false
    }

    @objc private func resendTapped() {
        presenter.resendCode()
    }

    // MARK: - Update State

    override func update(with state: State) {
        switch state {
        case .idle:
            nextButton.showLoading(false)
        case .loading:
            nextButton.showLoading(true, indicatorStyle: .medium, indicatorColor: .black)
        }
    }

    // MARK: - Handle Event

    override func handle(_ event: Event) {
        switch event {
        case .showHome:
            nextButton.showLoading(false)
            view.endEditing(true)
            coordinator.showHome()
        case .showCreateName:
            nextButton.showLoading(false)
            view.endEditing(true)
            coordinator.showCreateName()
        case .resendCode:
            view.makeToast("Code has been resent", duration: 2.0, position: .top)
        case .updateButton(let isEnabled):
            nextButton.alpha = isEnabled ? 1.0 : 0.1
            nextButton.isUserInteractionEnabled = isEnabled
        case .updateCodeNumber(let code):
            self.code = code
        case .backVC:
            navigationController?.popViewController(animated: true)
        case .error(let message):
            nextButton.showLoading(false)
            showErrorBanner(error: message)
        case .errorCode:
            nextButton.showLoading(false)
            showErrorBanner(error: "Incorrect Code")
            codeTextField.text = ""
        case .errorManyRequest:
            nextButton.showLoading(false)
            showErrorBanner(error: "Too many requests. Please try again later.")
        }
    }

    // MARK: Actions

    @IBAction func back(_ sender: Any) {
        presenter.goBack()
    }

    @IBAction func next(_ sender: Any) {
        presenter.fill(code: code)
    }

    @IBAction func resend(_ sender: Any) {
        presenter.resendCode()
    }
}

// MARK: UITextFieldDelegate

extension ConfirmPhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        let newString = text.replacingCharacters(in: textRange, with: string)

        // Limit to 6 digits
        if newString.count > 6 {
            return false
        }

        code = newString
        presenter.updateButton(code: newString)

        // Auto-submit when 6 digits entered
        if newString.count == 6 {
            presenter.fill(code: newString)
        }

        return true
    }
}

