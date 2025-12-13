import UIKit

/// Coordinator for the Messages feature.
/// 
/// Handles navigation for the Messages screen following the Coordinator pattern
/// used in the main YorNest app.
final class MessagesCoordinator {
    
    // MARK: - Properties
    
    private weak var view: MessagesViewController?
    
    // MARK: - Init
    
    init(view: MessagesViewController) {
        self.view = view
    }
    
    // MARK: - Navigation
    
    /// Shows the create message bottom sheet.
    func showCreateMessageSheet() {
        guard let view = view else { return }
        
        let createMessageVC = CreateMessageViewController()
        createMessageVC.delegate = view
        
        if let sheet = createMessageVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        view.present(createMessageVC, animated: true)
    }
    
    /// Dismisses the create message bottom sheet.
    func dismissCreateMessageSheet() {
        view?.dismiss(animated: true)
    }
    
    /// Shows a user profile screen (for future extension).
    func showUserProfile(userId: String) {
        // TODO: Implement user profile navigation
        // This is left as an exercise for assessment candidates
        print("Navigate to user profile: \(userId)")
    }
    
    /// Shows the message detail screen (for future extension).
    func showMessageDetail(message: MessageInfo) {
        // TODO: Implement message detail navigation
        // This is left as an exercise for assessment candidates
        print("Navigate to message detail: \(message.id)")
    }
}

