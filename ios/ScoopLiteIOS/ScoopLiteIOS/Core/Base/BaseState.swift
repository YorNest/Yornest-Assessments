import Foundation

/// Protocol that all state types must conform to.
/// States represent the current state of the UI and are emitted by Presenters.
public protocol BaseState { }

/// Protocol for view controllers that can update based on state changes.
public protocol StateUpdatable {
    associatedtype State: BaseState
    func update(with state: State)
}

