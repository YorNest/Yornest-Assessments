import Foundation

// MARK: - State

/// Represents the possible states of the Messages screen.
enum MessagesState: BaseState, Equatable {
    case idle
    case loading
    case loaded(messages: [MessageInfo])
    case error(message: String)
    case refreshing(messages: [MessageInfo])
    
    static func == (lhs: MessagesState, rhs: MessagesState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let lMessages), .loaded(let rMessages)):
            return lMessages == rMessages
        case (.refreshing(let lMessages), .refreshing(let rMessages)):
            return lMessages == rMessages
        case (.error(let lMsg), .error(let rMsg)):
            return lMsg == rMsg
        default:
            return false
        }
    }
}

// MARK: - Event

/// One-time events that the Messages view controller should handle.
enum MessagesEvent: BaseEvent {
    case showError(String)
    case showCreateMessageSheet
    case hideCreateMessageSheet
    case messageCreated
    case messageDeleted
    case scrollToBottom
}

// MARK: - Presenter

/// Handles business logic for the Messages feature.
/// 
/// This follows the MVP pattern used in the main YorNest app.
final class MessagesViewPresenter: BasePresenter<MessagesState, MessagesEvent> {
    
    private let messagesService: MessagesServiceProtocol
    private let groupId: String
    
    private var currentMessages: [MessageInfo] = []
    private var inputText: String = ""
    private var isSubmitting: Bool = false
    
    // MARK: - Init
    
    init(messagesService: MessagesServiceProtocol, groupId: String = "default-group") {
        self.messagesService = messagesService
        self.groupId = groupId
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func loaded() {
        Task {
            await loadMessages()
        }
    }
    
    // MARK: - Public Methods
    
    /// Loads messages from the server.
    @MainActor
    func loadMessages() async {
        updateMainActorState(.loading)
        
        do {
            let messages = try await messagesService.fetchMessages(groupId: groupId)
            currentMessages = messages
            updateMainActorState(.loaded(messages: messages))
        } catch {
            let errorMessage = (error as? RequestAPIError)?.localizedDescription ?? error.localizedDescription
            updateMainActorState(.error(message: errorMessage))
            emitMainActorEvent(.showError(errorMessage))
        }
    }
    
    /// Refreshes messages (pull-to-refresh).
    @MainActor
    func refresh() async {
        updateMainActorState(.refreshing(messages: currentMessages))
        
        do {
            let messages = try await messagesService.fetchMessages(groupId: groupId)
            currentMessages = messages
            updateMainActorState(.loaded(messages: messages))
        } catch {
            // On refresh error, keep existing messages but show error
            updateMainActorState(.loaded(messages: currentMessages))
            let errorMessage = (error as? RequestAPIError)?.localizedDescription ?? error.localizedDescription
            emitMainActorEvent(.showError(errorMessage))
        }
    }
    
    /// Shows the create message sheet.
    func showCreateMessageSheet() {
        emitEvent(.showCreateMessageSheet)
    }
    
    /// Hides the create message sheet.
    func hideCreateMessageSheet() {
        inputText = ""
        emitEvent(.hideCreateMessageSheet)
    }
    
    /// Updates the input text.
    func updateInputText(_ text: String) {
        inputText = text
    }
    
    /// Submits the new message.
    @MainActor
    func submitMessage() async {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !isSubmitting else { return }
        
        isSubmitting = true
        
        do {
            let newMessage = try await messagesService.createMessage(text: inputText, groupId: groupId)
            currentMessages.append(newMessage)
            updateMainActorState(.loaded(messages: currentMessages))
            inputText = ""
            isSubmitting = false
            emitMainActorEvent(.messageCreated)
            emitMainActorEvent(.hideCreateMessageSheet)
            emitMainActorEvent(.scrollToBottom)
        } catch {
            isSubmitting = false
            let errorMessage = (error as? RequestAPIError)?.localizedDescription ?? error.localizedDescription
            emitMainActorEvent(.showError(errorMessage))
        }
    }
    
    /// Deletes a message.
    ///
    /// BUG #1: There's a subtle bug in this method - can you find it?
    @MainActor
    func deleteMessage(at index: Int) async {
        guard index >= 0 && index < currentMessages.count else { return }

        let messageId = currentMessages[index].id

        do {
            try await messagesService.deleteMessage(messageId: messageId)
            // BUG: Wrong index used - should remove by messageId, not index
            // The index could have changed if another deletion happened
            currentMessages.remove(at: index)
            updateMainActorState(.loaded(messages: currentMessages))
            emitMainActorEvent(.messageDeleted)
        } catch {
            let errorMessage = (error as? RequestAPIError)?.localizedDescription ?? error.localizedDescription
            emitMainActorEvent(.showError(errorMessage))
        }
    }

    /// Gets the current message count.
    ///
    /// BUG #2: This method has a threading issue - can you fix it?
    var messageCount: Int {
        // BUG: Accessing currentMessages from potentially different thread
        // without proper synchronization
        return currentMessages.count
    }
}

