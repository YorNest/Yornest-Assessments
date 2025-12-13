import UIKit
import SnapKit

/// Delegate protocol for the create message view controller.
protocol CreateMessageDelegate: AnyObject {
    func didSubmitMessage(text: String)
    func didCancelCreateMessage()
}

/// Bottom sheet view controller for creating a new message.
/// 
/// This follows the bottom sheet pattern used in the Android assessment.
final class CreateMessageViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CreateMessageDelegate?
    private var isSubmitting = false
    
    // MARK: - UI Components
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "New Message"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.delegate = self
        return textView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Type your message..."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerLabel)
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        view.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(submitButton)
        submitButton.addSubview(activityIndicator)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleCancel() {
        delegate?.didCancelCreateMessage()
    }
    
    @objc private func handleSubmit() {
        guard let text = textView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        setSubmitting(true)
        delegate?.didSubmitMessage(text: text)
    }
    
    private func setSubmitting(_ submitting: Bool) {
        isSubmitting = submitting
        submitButton.isEnabled = !submitting
        cancelButton.isEnabled = !submitting
        textView.isEditable = !submitting
        
        if submitting {
            submitButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            submitButton.setTitle("Submit", for: .normal)
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITextViewDelegate

extension CreateMessageViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let hasText = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        placeholderLabel.isHidden = !textView.text.isEmpty
        submitButton.isEnabled = hasText && !isSubmitting
    }
}

