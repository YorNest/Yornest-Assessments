import UIKit
import SnapKit

/// Table view cell for displaying a single message.
final class MessageCell: UITableViewCell {
    
    static let reuseIdentifier = "MessageCell"
    
    // MARK: - UI Components
    
    private lazy var avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var senderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(avatarView)
        avatarView.addSubview(initialsLabel)
        contentView.addSubview(contentStackView)
        
        headerStackView.addArrangedSubview(senderLabel)
        headerStackView.addArrangedSubview(timestampLabel)
        headerStackView.addArrangedSubview(UIView()) // Spacer
        
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(messageLabel)
        
        // Layout
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(40)
        }
        
        initialsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - Configuration

    /// Configures the cell with message data.
    ///
    /// BUG #3: There's a UI bug here - the avatar color isn't reset properly
    /// in certain reuse scenarios.
    func configure(with message: MessageInfo) {
        initialsLabel.text = message.senderInitials
        senderLabel.text = message.sender
        timestampLabel.text = message.formattedTimestamp
        messageLabel.text = message.text

        // BUG: This color calculation can produce inconsistent results
        // because hashValue is not guaranteed to be stable across app runs
        // and the modulo operation with an array that changes size would break
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemPink]
        let colorIndex = abs(message.senderId.hashValue) % colors.count
        avatarView.backgroundColor = colors[colorIndex]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initialsLabel.text = nil
        senderLabel.text = nil
        timestampLabel.text = nil
        messageLabel.text = nil
    }
}

