import VERSE
import Combine
import Foundation

// MARK: - HeadphoneMotionManagerAction

/// Actions that correspond to `CMHeadphoneMotionManagerDelegate` methods
///
/// See `CMHeadphoneMotionManagerDelegate` for more information
public enum HeadphoneMotionManagerAction: Equatable {
    case didConnect
    case didDisconnect
}

// MARK: - HeadphoneMotionManager

/// A wrapper around Core Motion's `CMHeadphoneMotionManager` that exposes its functionality
/// through effects and actions, making it easy to use with the Composable Architecture, and easy
/// to test.
@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
public protocol HeadphoneMotionManager {

    /// A Boolean value that determines whether the app is receiving updates from the device-motion
    /// service
    func isDeviceMotionActive(id: AnyHashable) -> Bool

    /// A Boolean value that indicates whether the device-motion service is available on the device
    func isDeviceMotionAvailable(id: AnyHashable) -> Bool

    /// Creates a headphone motion manager
    ///
    /// A motion manager must be first created before you can use its functionality, such as
    /// starting device motion updates or accessing data directly from the manager
    func create(id: AnyHashable) -> Effect<HeadphoneMotionManagerAction, Never>

    /// Destroys a currently running headphone motion manager
    ///
    /// In is good practice to destroy a headphone motion manager once you are done with it, such as
    /// when you leave a screen or no longer need motion data
    func destroy(id: AnyHashable) -> Effect<Never, Never>

    /// The latest sample of device-motion data
    func deviceMotion(id: AnyHashable) -> DeviceMotion?

    /// Starts device-motion updates without a block handler
    ///
    /// Returns a long-living effect that emits device motion data each time the headphone motion
    /// manager receives a new value
    func startDeviceMotionUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<DeviceMotion, Error>

    /// Stops device-motion updates
    func stopDeviceMotionUpdates(id: AnyHashable) -> Effect<Never, Never>
}

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
public extension HeadphoneMotionManager {

    /// Starts device-motion updates without a block handler
    ///
    /// Returns a long-living effect that emits device motion data each time the headphone motion
    /// manager receives a new value
    func startDeviceMotionUpdates(id: AnyHashable) -> Effect<DeviceMotion, Error> {
        startDeviceMotionUpdates(id: id, to: .main)
    }
}
