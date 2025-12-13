import Foundation

/// Base presenter class that handles business logic and emits states/events.
/// 
/// This follows the MVP-Coordinator pattern used in the main YorNest app.
/// Presenters should be subclassed for each feature, defining their own State and Event types.
///
/// Usage:
/// ```swift
/// class MyPresenter: BasePresenter<MyState, MyEvent> {
///     func loadData() async {
///         updateState(.loading)
///         // ... fetch data
///         updateState(.loaded(data))
///     }
/// }
/// ```
open class BasePresenter<S, E> {
    
    /// Closure called when state changes. Set by the ViewController.
    public var stateSignal: ((_ state: S) -> Void)?
    
    /// Closure called when events are emitted. Set by the ViewController.
    public var eventSignal: ((_ event: E) -> Void)?
    
    public init() { }
    
    /// Called when the view has loaded. Override to perform initial data loading.
    open func loaded() { }
    
    /// Updates the state on the main thread.
    /// - Parameter state: The new state to emit
    open func updateState(_ state: S) {
        DispatchQueue.main.async {
            self.stateSignal?(state)
        }
    }
    
    /// Emits an event on the main thread.
    /// - Parameter event: The event to emit
    open func emitEvent(_ event: E) {
        DispatchQueue.main.async {
            self.eventSignal?(event)
        }
    }
    
    /// Updates the state when already on the main actor.
    /// Use this from async contexts that are MainActor-isolated.
    @MainActor
    open func updateMainActorState(_ state: S) {
        stateSignal?(state)
    }
    
    /// Emits an event when already on the main actor.
    /// Use this from async contexts that are MainActor-isolated.
    @MainActor
    open func emitMainActorEvent(_ event: E) {
        eventSignal?(event)
    }
}

