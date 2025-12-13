import UIKit
import SnapKit

/// Main view controller for displaying messages.
/// 
/// This follows the MVP pattern with BaseViewController from the main YorNest app.
final class MessagesViewController: SLBaseViewController<MessagesState, MessagesEvent, MessagesViewPresenter> {
    
    // MARK: - Properties
    
    var coordinator: MessagesCoordinator!
    private var messages: [MessageInfo] = []
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()
    
    private lazy var fabButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "CreateMessageButton"
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(handleFabTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No messages yet.\nTap the pencil button to create one!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private lazy var errorView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func setupUI() {
        super.setupUI()
        
        title = "Messages"
        view.backgroundColor = .systemBackground
        
        // Setup table view
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Setup FAB
        view.addSubview(fabButton)
        fabButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(56)
        }
        
        // Setup empty state
        view.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        // Setup error view
        errorView.addSubview(errorLabel)
        errorView.addSubview(retryButton)
        view.addSubview(errorView)
        
        errorLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(8)
            make.centerX.bottom.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - State Updates
    
    override func update(with state: MessagesState) {
        switch state {
        case .idle:
            hideLoading()
            
        case .loading:
            showLoading()
            emptyStateLabel.isHidden = true
            errorView.isHidden = true
            
        case .loaded(let messages):
            hideLoading()
            refreshControl.endRefreshing()
            self.messages = messages
            tableView.reloadData()
            emptyStateLabel.isHidden = !messages.isEmpty
            errorView.isHidden = true
            
        case .error(let message):
            hideLoading()
            refreshControl.endRefreshing()
            errorLabel.text = message
            errorView.isHidden = false
            emptyStateLabel.isHidden = true
            
        case .refreshing:
            errorView.isHidden = true
        }
    }
    
    // MARK: - Event Handling
    
    override func handle(_ event: MessagesEvent) {
        switch event {
        case .showError(let message):
            showErrorBanner(message: message)
            
        case .showCreateMessageSheet:
            coordinator.showCreateMessageSheet()
            
        case .hideCreateMessageSheet:
            coordinator.dismissCreateMessageSheet()
            
        case .messageCreated, .messageDeleted:
            // Already handled by state update
            break
            
        case .scrollToBottom:
            scrollToBottom()
        }
    }

    // MARK: - Actions

    @objc private func handleRefresh() {
        Task {
            await presenter.refresh()
        }
    }

    @objc private func handleFabTap() {
        presenter.showCreateMessageSheet()
    }

    @objc private func handleRetry() {
        Task {
            await presenter.loadMessages()
        }
    }

    // MARK: - Helpers

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageCell.reuseIdentifier,
            for: indexPath
        ) as? MessageCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = messages[indexPath.row]
        coordinator.showMessageDetail(message: message)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            Task {
                await self?.presenter.deleteMessage(at: indexPath.row)
                completion(true)
            }
        }
        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - CreateMessageDelegate

extension MessagesViewController: CreateMessageDelegate {

    func didSubmitMessage(text: String) {
        presenter.updateInputText(text)
        Task {
            await presenter.submitMessage()
        }
    }

    func didCancelCreateMessage() {
        presenter.hideCreateMessageSheet()
    }
}

