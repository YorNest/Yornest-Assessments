import UIKit
import SnapKit

// MARK: - CreateName View Controller

/// Profile creation screen for setting up user name and username.
/// Uses programmatic layout with SnapKit - matches main YorNest app pattern.
final class CreateNameViewController: SLBaseViewController<CreateNameState, CreateNameEvent, CreateNameViewPresenter> {

    // MARK: Constants

    private enum ImageSource {
        case photoLibrary
        case camera
    }

    // MARK: UI Elements

    private lazy var backButton: UIButton = {
        let tempView = UIButton(type: .system)
        tempView.setImage(UIImage(named: "ic_back"), for: .normal)
        tempView.tintColor = .black
        tempView.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return tempView
    }()

    private lazy var nextButton: LoadingButton = {
        let tempView = LoadingButton()
        tempView.alpha = 0.1
        tempView.isUserInteractionEnabled = false
        tempView.setImage(UIImage(named: "ic_registration_button"), for: .normal)
        tempView.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return tempView
    }()

    private lazy var scrollView: UIScrollView = {
        let tempView = UIScrollView()
        tempView.backgroundColor = .clear
        tempView.contentInsetAdjustmentBehavior = .never
        tempView.automaticallyAdjustsScrollIndicatorInsets = false
        tempView.showsVerticalScrollIndicator = false
        tempView.showsHorizontalScrollIndicator = false
        return tempView
    }()

    private lazy var mainContentView: UIView = {
        let tempView = UIView()
        return tempView
    }()

    private lazy var photoView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = Colors.backgroundColor
        tempView.layer.cornerRadius = 16
        tempView.clipsToBounds = true
        return tempView
    }()

    private lazy var photoImageView: UIImageView = {
        let tempView = UIImageView()
        tempView.contentMode = .scaleAspectFill
        tempView.layer.cornerRadius = 16
        tempView.clipsToBounds = true
        return tempView
    }()

    private lazy var selectPhotoButton: UIButton = {
        let tempView = UIButton(type: .system)
        tempView.setImage(UIImage(systemName: "person.fill")?.withTintColor(Colors.createNameDefaultImageColor, renderingMode: .alwaysOriginal), for: .normal)
        tempView.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
        return tempView
    }()

    private lazy var addProfilePhotoLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "Add Profile Picture"
        tempView.font = AppFonts.semibold_14
        tempView.textColor = .black
        return tempView
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    private lazy var nameTextField: UITextField = {
        let tempView = UITextField()
        tempView.autocapitalizationType = .words
        tempView.autocorrectionType = .no
        tempView.spellCheckingType = .no
        tempView.placeholder = "First Name"
        tempView.font = AppFonts.regular_16
        tempView.textColor = .black
        tempView.delegate = self
        tempView.tag = 0
        tempView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tempView.leftViewMode = .always
        tempView.layer.cornerRadius = 12
        tempView.layer.borderColor = Colors.collectionBackgroundColor.cgColor
        tempView.layer.borderWidth = 1.0
        return tempView
    }()

    private lazy var familyNameTextField: UITextField = {
        let tempView = UITextField()
        tempView.autocapitalizationType = .words
        tempView.autocorrectionType = .no
        tempView.spellCheckingType = .no
        tempView.placeholder = "Last Name"
        tempView.font = AppFonts.regular_16
        tempView.textColor = .black
        tempView.delegate = self
        tempView.tag = 1
        tempView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tempView.leftViewMode = .always
        tempView.layer.cornerRadius = 12
        tempView.layer.borderColor = Colors.collectionBackgroundColor.cgColor
        tempView.layer.borderWidth = 1.0
        return tempView
    }()

    private lazy var usernameTextField: UITextField = {
        let tempView = UITextField()
        tempView.autocapitalizationType = .none
        tempView.autocorrectionType = .no
        tempView.spellCheckingType = .no
        tempView.placeholder = "Username"
        tempView.font = AppFonts.regular_16
        tempView.textColor = .black
        tempView.delegate = self
        tempView.tag = 2
        tempView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tempView.leftViewMode = .always
        tempView.layer.cornerRadius = 12
        tempView.layer.borderColor = Colors.collectionBackgroundColor.cgColor
        tempView.layer.borderWidth = 1.0
        return tempView
    }()

    private lazy var errorLabel: UILabel = {
        let tempView = UILabel()
        tempView.textColor = Colors.E52E2EColor
        tempView.font = AppFonts.medium_14
        tempView.isHidden = true
        return tempView
    }()

    private lazy var spacerView = UIView()

    // MARK: Properties

    var coordinator: CreateNameCoordinator!
    private var imagePicker = UIImagePickerController()

    // MARK: LifeCycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        nameTextField.becomeFirstResponder()
    }

    // MARK: - Setup

    override func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        mainContentView.isUserInteractionEnabled = true

        scrollView.addSubview(mainContentView)

        mainContentView.addSubview(photoView)
        photoView.addSubview(photoImageView)
        photoView.addSubview(selectPhotoButton)

        mainContentView.addSubview(addProfilePhotoLabel)

        mainContentView.addSubview(stackView)

        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(familyNameTextField)

        mainContentView.addSubview(usernameTextField)
        mainContentView.addSubview(errorLabel)
        mainContentView.addSubview(spacerView)

        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(40)
        }

        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }

        mainContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.greaterThanOrEqualTo(354)
            make.width.equalTo(scrollView.snp.width).offset(-48)
        }

        photoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }

        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectPhotoButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addProfilePhotoLabel.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(addProfilePhotoLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(8)
            make.left.equalToSuperview()
        }

        spacerView.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }

        view.layoutIfNeeded()
    }

    // MARK: - Update State

    override func update(with state: State) {
        switch state {
        case .startAnimating:
            nextButton.showLoading(true, indicatorStyle: .medium, indicatorColor: .black)
        case .valideUsername(let message):
            nextButton.showLoading(false)
            errorLabel.isHidden = message.isEmpty
            errorLabel.text = message
        }
    }

    // MARK: - Handle Event

    override func handle(_ event: Event) {
        switch event {
        case .updateButton(let isEnable):
            nextButton.alpha = isEnable ? 1.0 : 0.1
            nextButton.isUserInteractionEnabled = isEnable
        case .showHome:
            view.endEditing(true)
            nextButton.showLoading(false)
            coordinator.showHome()
        case .showNotificationSettings:
            view.endEditing(true)
            nextButton.showLoading(false)
            coordinator.showNotificationSettings()
        case .chooseImage:
            chooseImage()
        case .updateImage(let image):
            selectPhotoButton.setImage(nil, for: .normal)
            photoImageView.image = image
        case .errorMissingName:
            view.endEditing(true)
            nextButton.showLoading(false)
            showErrorBanner(error: "Please enter your first name")
        case .errorMissingUsername:
            view.endEditing(true)
            nextButton.showLoading(false)
            showErrorBanner(error: "Please enter a username")
        case .errorUsernameTaken:
            nextButton.showLoading(false)
            errorLabel.isHidden = false
            errorLabel.text = "Username is taken"
        case .errorValidation:
            nextButton.showLoading(false)
            showErrorBanner(error: "Please check your input")
        case .internetError:
            nextButton.showLoading(false)
            showErrorBanner(error: "No internet connection")
        case .error:
            nextButton.showLoading(false)
            showErrorBanner(error: "Something went wrong")
        }
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        scrollView.contentSize.height = keyboardHeight + mainContentView.frame.height + 100
    }

    // MARK: Actions

    @objc private func backButtonTapped(_ sender: Any) {
        #if DEBUG
        print("🔙 [backButtonTapped] Called")
        #endif
        coordinator.goBack()
    }

    @objc private func selectPhotoButtonTapped(_ sender: Any) {
        presenter.chooseImage()
    }

    @objc private func nextButtonTapped(_ sender: Any) {
        presenter.signUp()
    }

    // MARK: Methods

    private func chooseImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        selectImageFrom(.photoLibrary)
    }

    private func selectImageFrom(_ source: ImageSource) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension CreateNameViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        presenter.updateImage(image: image)
    }
}

// MARK: UITextFieldDelegate

extension CreateNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return presenter.shouldChange(textField, range, string)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(textFieldFrame, animated: true)
    }
}

