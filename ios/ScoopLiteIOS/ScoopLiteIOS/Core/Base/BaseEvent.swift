import Foundation

/// Protocol that all event types must conform to.
/// Events represent one-time actions that the View should handle (e.g., show alert, navigate).
public protocol BaseEvent { }

/// Protocol for view controllers that can handle events.
public protocol EventHandler {
    associatedtype Event: BaseEvent
    func handle(_ event: Event)
}

