import Foundation
import UIKit

/// Base view controller that implements the MVP pattern.
///
/// This connects the ViewController to its Presenter and automatically
/// wires up state and event signals.
///
/// Usage:
/// ```swift
/// class MyViewController: BaseViewController<MyState, MyEvent, MyPresenter> {
///     override func update(with state: MyState) {
///         switch state {
///         case .loading: showLoading()
///         case .loaded(let data): showData(data)
///         }
///     }
///     
///     override func handle(_ event: MyEvent) {
///         switch event {
///         case .showError(let msg): showAlert(msg)
///         }
///     }
/// }
/// ```
open class BaseViewController<S, E, P>: UIViewController, StateUpdatable, EventHandler
where S: BaseState, E: BaseEvent, P: BasePresenter<S, E> {
    
    public typealias State = S
    public typealias Event = E
    
    /// The presenter that handles business logic for this view controller.
    /// Must be set before viewDidLoad (typically via DI container).
    public var presenter: P!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Wire up presenter signals
        presenter.stateSignal = { [weak self] state in
            self?.update(with: state)
        }
        presenter.eventSignal = { [weak self] event in
            self?.handle(event)
        }
        
        // Notify presenter that view is loaded
        presenter.loaded()
    }
    
    /// Override this method to set up UI components.
    /// Called before presenter signals are wired up.
    open func setupUI() { }
    
    /// Override this method to handle state updates from the presenter.
    /// - Parameter state: The new state
    open func update(with state: State) { }
    
    /// Override this method to handle events from the presenter.
    /// - Parameter event: The event to handle
    open func handle(_ event: Event) { }
}

