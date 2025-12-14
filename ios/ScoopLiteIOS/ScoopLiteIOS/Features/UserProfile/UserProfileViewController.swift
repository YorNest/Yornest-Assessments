import UIKit
import SnapKit
import Kingfisher

/// Displays authenticated user info and provides logout functionality.
/// Used to indicate successful auth for assessment purposes.
final class UserProfileViewController: SLBaseViewController<UserProfileState, UserProfileEvent, UserProfileViewPresenter> {

    // MARK: - Properties

    var coordinator: UserProfileCoordinator!

    // MARK: - UI Elements

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileImageView = UIImageView()
    private let fullNameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let mobileLabel = UILabel()
    private let userIdLabel = UILabel()
    private let statusLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    private let deleteAccountButton = UIButton(type: .system)
    private let loadingSpinner = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup

    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .white
        title = "User Profile"

        // Scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Profile image
        profileImageView.backgroundColor = Colors.segmentColor.withAlphaComponent(0.2)
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = Colors.segmentColor
        contentView.addSubview(profileImageView)

        // Status label (success indicator)
        statusLabel.text = "✅ Authentication Successful"
        statusLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        statusLabel.textColor = .systemGreen
        statusLabel.textAlignment = .center
        contentView.addSubview(statusLabel)

        // Full name
        fullNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        fullNameLabel.textAlignment = .center
        fullNameLabel.numberOfLines = 0
        contentView.addSubview(fullNameLabel)

        // Username
        usernameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        usernameLabel.textColor = .gray
        usernameLabel.textAlignment = .center
        contentView.addSubview(usernameLabel)

        // Mobile
        mobileLabel.font = .systemFont(ofSize: 14, weight: .regular)
        mobileLabel.textColor = .darkGray
        mobileLabel.textAlignment = .center
        contentView.addSubview(mobileLabel)

        // User ID
        userIdLabel.font = .systemFont(ofSize: 12, weight: .regular)
        userIdLabel.textColor = .lightGray
        userIdLabel.textAlignment = .center
        userIdLabel.numberOfLines = 0
        contentView.addSubview(userIdLabel)

        // Logout button
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = Colors.segmentColor
        logoutButton.layer.cornerRadius = 25
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        contentView.addSubview(logoutButton)

        // Delete account button
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.setTitleColor(.white, for: .normal)
        deleteAccountButton.backgroundColor = .systemRed
        deleteAccountButton.layer.cornerRadius = 25
        deleteAccountButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountTapped), for: .touchUpInside)
        contentView.addSubview(deleteAccountButton)

        // Loading spinner
        loadingSpinner.hidesWhenStopped = true
        view.addSubview(loadingSpinner)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        mobileLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        userIdLabel.snp.makeConstraints { make in
            make.top.equalTo(mobileLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(userIdLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
        }

        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc private func logoutTapped() {
        presenter.logout()
    }

    @objc private func deleteAccountTapped() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter.deleteAccount()
        })
        present(alert, animated: true)
    }

    // MARK: - State Updates

    override func update(with state: State) {
        switch state {
        case .loaded(let user):
            updateUI(with: user)
        case .error(let message):
            showErrorBanner(error: message)
        }
    }

    override func handle(_ event: Event) {
        switch event {
        case .showSignIn:
            coordinator.showSignIn()
        }
    }

    // MARK: - Private Methods

    private func updateUI(with user: UserModel) {
        fullNameLabel.text = user.fullName ?? "No Name"
        usernameLabel.text = user.username != nil ? "@\(user.username!)" : "No Username"
        mobileLabel.text = "📱 \(user.mobileNumber ?? UserManager.shared.mobileNumber)"
        userIdLabel.text = "ID: \(user.userId ?? UserManager.shared.userId)"

        // Load profile image using Kingfisher
        if let profileImageURL = user.profileImage, !profileImageURL.isEmpty,
           let url = URL(string: profileImageURL) {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle.fill"),
                options: [.transition(.fade(0.2))]
            )
        }
    }
}

