import VERSE
import Combine
import Foundation
import CoreMotion

// MARK: - HeadphoneMotionManagerImplmentation

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
public final class HeadphoneMotionManagerImplmentation {

    // MARK: - Properties

    /// All current HeadphoneMotionManagerImplmentation dependencies
    private var dependencies: [AnyHashable: Dependencies] = [:]

    /// Motion update subscribers
    private var deviceMotionUpdatesSubscribers: [AnyHashable: Effect<DeviceMotion, Error>.Subscriber] = [:]

    // MARK: - Initializers

    public init() {
    }

    // MARK: - Private

    /// Obtain CMHeadphoneMotionManager instance by the given id
    /// - Parameter id: target id value
    /// - Returns: CMHeadphoneMotionManager instance
    private func obtainHeadphoneMotionManager(id: AnyHashable) -> CMHeadphoneMotionManager? {
        if dependencies[id] == nil {
            couldNotFindHeadphoneMotionManager(id: id)
        }
        return dependencies[id]?.manager
    }

    /// Throws assertion about event when we cannot find necessary dependency
    /// - Parameter id: problem identifier
    private func couldNotFindHeadphoneMotionManager(id: Any) {
        assertionFailure("""
        A headphone motion manager could not be found with the id \(id). This is considered a \
        programmer error. You should not invoke methods on a motion manager before it has been \
        created or after it has been destroyed. Refactor your code to make sure there is a headphone \
        motion manager created by the time you invoke this endpoint.
        """
        )
    }
}

// MARK: - HeadphoneMotionManager

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
extension HeadphoneMotionManagerImplmentation: HeadphoneMotionManager {

    public func isDeviceMotionActive(id: AnyHashable) -> Bool {
        obtainHeadphoneMotionManager(id: id)?.isDeviceMotionActive ?? false
    }

    public func isDeviceMotionAvailable(id: AnyHashable) -> Bool {
        obtainHeadphoneMotionManager(id: id)?.isDeviceMotionAvailable ?? false
    }

    public func create(id: AnyHashable) -> Effect<HeadphoneMotionManagerAction, Never> {
        .run { [weak self] subscriber in

            guard let self = self else { return AnyCancellable {} }
            if self.dependencies[id] != nil {
                assertionFailure(
                """
                You are attempting to create a headphone motion manager with the id \(id), but there \
                is already a running manager with that id. This is considered a programmer error \
                since you may be accidentally overwriting an existing manager without knowing.

                To fix you should either destroy the existing manager before creating a new one, or \
                you should not try creating a new one before this one is destroyed.
                """
                )
            }

            let manager = CMHeadphoneMotionManager()
            let delegate = Delegate(subscriber)
            manager.delegate = delegate

            self.dependencies[id] = Dependencies(
                delegate: delegate,
                manager: manager,
                subscriber: subscriber
            )

            return AnyCancellable {
                self.dependencies[id] = nil
            }
        }
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            self?.dependencies[id] = nil
        }
    }

    public func deviceMotion(id: AnyHashable) -> DeviceMotion? {
        obtainHeadphoneMotionManager(id: id)?.deviceMotion.map(DeviceMotion.init)
    }

    public func startDeviceMotionUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<DeviceMotion, Error> {
        .run { [weak self] subscriber in

            guard let self = self else { return AnyCancellable {} }
            guard let manager = self.obtainHeadphoneMotionManager(id: id) else {
                self.couldNotFindHeadphoneMotionManager(id: id)
                return AnyCancellable {}
            }
            guard self.deviceMotionUpdatesSubscribers[id] == nil else { return AnyCancellable {} }

            self.deviceMotionUpdatesSubscribers[id] = subscriber
            manager.startDeviceMotionUpdates(to: queue) { data, error in
                if let data = data {
                    subscriber.send(.init(data))
                } else if let error = error {
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable {
                manager.stopDeviceMotionUpdates()
            }
        }
    }

    public func stopDeviceMotionUpdates(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            guard let self = self else { return }
            guard let manager = self.obtainHeadphoneMotionManager(id: id) else {
                self.couldNotFindHeadphoneMotionManager(id: id)
                return
            }
            manager.stopDeviceMotionUpdates()
            self.deviceMotionUpdatesSubscribers[id]?.send(completion: .finished)
            self.deviceMotionUpdatesSubscribers[id] = nil
        }
    }
}

// MARK: - Delegate

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
private class Delegate: NSObject, CMHeadphoneMotionManagerDelegate {

    // MARK: - Properties

    /// Subscriber instance
    let subscriber: Effect<HeadphoneMotionManagerAction, Never>.Subscriber

    // MARK: - Initializers

    /// Default initializer
    /// - Parameter subscriber: subscriber instance
    init(_ subscriber: Effect<HeadphoneMotionManagerAction, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    // MARK: - CMHeadphoneMotionManagerDelegate

    /// Invoked when a headphone is connected.
    /// Execution of the delegate callback occurs on the operation queue
    /// used to deliver the device motion updates.
    /// The main thread is used if the queue was not specified.
    /// - Parameter manager: CMHeadphoneMotionManager instance
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        subscriber.send(.didConnect)
    }

    /// Invoked when a headphone is disconnected.
    /// Execution of the delegate callback occurs on the operation queue
    /// used to deliver the device motion updates.
    /// The main thread is used if the queue was not specified.
    /// - Parameter manager: CMHeadphoneMotionManager instance
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        subscriber.send(.didDisconnect)
    }
}

// MARK: - Dependencies

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
private struct Dependencies {

    // MARK: - Properties

    /// Delegate instance
    let delegate: Delegate

    /// CMHeadphoneMotionManager instance
    let manager: CMHeadphoneMotionManager

    /// Subscriber instance
    let subscriber: Effect<HeadphoneMotionManagerAction, Never>.Subscriber
}
