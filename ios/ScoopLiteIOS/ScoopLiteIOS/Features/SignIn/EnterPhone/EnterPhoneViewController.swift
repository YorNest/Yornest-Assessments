import UIKit
import DialCountries

// MARK: - EnterPhone View Controller

/// Phone number entry screen for authentication.
/// Uses XIB for layout - matches main YorNest app pattern.
final class EnterPhoneViewController: SLBaseViewController<EnterPhoneState, EnterPhoneEvent, EnterPhoneViewPresenter> {

    // MARK: IBOutlets

    @IBOutlet private var numberView: UIView!
    @IBOutlet private var numberTextField: UITextField!
    @IBOutlet private var prefixLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var nextButton: LoadingButton!
    @IBOutlet private var chooseImageView: UIImageView!
    @IBOutlet private var icMainTopConstraint: NSLayoutConstraint!

    // MARK: Properties

    private var checkEnable = false
    private var dialCodeLabel = UILabel()

    var coordinator: EnterPhoneCoordinator!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        numberTextField.becomeFirstResponder()
        presenter.setupCurrentCountry()
    }

    // MARK: - Setup

    override func setupUI() {
        view.backgroundColor = .white
        presenter.setupCurrentCountry()

        prefixLabel.font = .systemFont(ofSize: 18, weight: .medium)
        prefixLabel.backgroundColor = Colors.backgroundColor
        prefixLabel.textAlignment = .center
        prefixLabel.textColor = .black
        prefixLabel.layer.cornerRadius = 15
        prefixLabel.layer.masksToBounds = true

        dialCodeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        dialCodeLabel.backgroundColor = .clear
        dialCodeLabel.textAlignment = .center
        dialCodeLabel.textColor = Colors.placeholderChatPostColor

        numberView.backgroundColor = Colors.backgroundColor
        numberView.layer.cornerRadius = 15.0
        numberTextField.backgroundColor = .clear
        numberTextField.leftViewMode = .always
        numberTextField.leftView = dialCodeLabel
        numberTextField.textContentType = .none
        numberTextField.font = .systemFont(ofSize: 18, weight: .medium)
        numberTextField.textContentType = .telephoneNumber
        numberTextField.delegate = self

        // T&C checkbox and label - matching main app text
        descriptionLabel.text = "I agree to the Terms of Service."
        descriptionLabel.textColor = .black
        descriptionLabel.font = AppFonts.medium_14

        // Checkbox - initially unchecked
        chooseImageView.image = UIImage(named: "ic_empty_cicrle")

        nextButton.alpha = 0.1
        nextButton.isUserInteractionEnabled = false
        nextButton.setImage(UIImage(named: "ic_registration_button"), for: .normal)

        prefixLabel.isUserInteractionEnabled = true
        prefixLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPrefixLabelTapped)))
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let remainingHeightBelowLabel = UIScreen.main.bounds.height - descriptionLabel.frame.minY
            if remainingHeightBelowLabel < keyboardFrame.height {
                icMainTopConstraint.constant = 106
            }
        }
    }

    // MARK: - Update State

    override func update(with state: State) {
        switch state {
        case .setupCountry(let country, let dialCode):
            numberTextField.text = nil
            dialCodeLabel.text = dialCode
            dialCodeLabel.textColor = Colors.placeholderChatPostColor
            prefixLabel.text = country
            prefixLabel.sizeToFit()
        case .updateNextButton(let isValid):
            nextButton.alpha = isValid ? 1.0 : 0.1
            nextButton.isUserInteractionEnabled = isValid
        }
    }

    // MARK: - Handle Event

    override func handle(_ event: Event) {
        switch event {
        case .updateColorForDialLabel(let isEmpty):
            dialCodeLabel.textColor = isEmpty ? Colors.placeholderChatPostColor : .black
        case .showConfirmPhoneNumber(let session, let number):
            nextButton.showLoading(false)
            nextButton.alpha = 0.1
            nextButton.isUserInteractionEnabled = false
            dialCodeLabel.textColor = Colors.placeholderChatPostColor
            coordinator.showConfirmPhoneNumber(session ?? "", number ?? "")
        case .showTermsPolicy(let isPrivacy):
            coordinator.showTermsPolicy(isPrivacy)
        case .showCountries:
            coordinator.showCountries(delegate: self)
        case .updateAgreement(let checkEnable):
            self.checkEnable = checkEnable
            chooseImageView.image = checkEnable ? UIImage(named: "ic_selected") : UIImage(named: "ic_empty_cicrle")
        case .error:
            nextButton.showLoading(false)
            showErrorBanner()
        case .internetError:
            nextButton.showLoading(false)
            showErrorBanner(isInternetProblem: true)
        case .errorManyRequest(let completion):
            nextButton.showLoading(false)
            showAlertWithTwoButtons(type: .tooManyRequests, completion: completion)
        case .showHelpAndFeedback:
            if let url = URL(string: "mailto:support@scoop.chat") {
                UIApplication.shared.open(url)
            }
        case .errorPleaseContact:
            nextButton.showLoading(false)
            showErrorBanner(error: "Too many requests, Please contact Scoop Support.")
        }
    }

    // MARK: Actions

    @IBAction func allow(_ sender: Any) {
        presenter.updateAgreement()
    }

    @IBAction func next(_ sender: Any) {
        nextButton.showLoading(true, indicatorStyle: .medium, indicatorColor: .black)
        presenter.signIn(numberTextField.text ?? "")
    }

    // MARK: Methods

    @objc private func onPrefixLabelTapped() {
        presenter?.showCountries()
    }
}

// MARK: DialCountriesControllerDelegate

extension EnterPhoneViewController: DialCountriesControllerDelegate {
    func didSelected(with country: Country) {
        presenter.updateCountry(country.flag, country.dialCode ?? "")
    }
}

// MARK: UITextFieldDelegate

extension EnterPhoneViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return presenter.shouldChange(textField, range, string)
    }
}

