import VERSE
import CoreMotion
import Foundation

// MARK: - MotionManager

@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
public protocol MotionManager {

    /// A Boolean value that indicates whether accelerometer updates are currently happening
    func isAccelerometerActive(id: AnyHashable) -> Bool

    /// A Boolean value that indicates whether an accelerometer is available on the device
    func isAccelerometerAvailable(id: AnyHashable) -> Bool

    /// A Boolean value that determines whether the app is receiving updates from the device-motion
    /// service
    func isDeviceMotionActive(id: AnyHashable) -> Bool

    /// A Boolean value that indicates whether the device-motion service is available on the device
    func isDeviceMotionAvailable(id: AnyHashable) -> Bool

    /// A Boolean value that determines whether gyroscope updates are currently happening
    func isGyroActive(id: AnyHashable) -> Bool

    /// A Boolean value that indicates whether a gyroscope is available on the device
    func isGyroAvailable(id: AnyHashable) -> Bool

    /// A Boolean value that determines whether magnetometer updates are currently happening
    func isMagnetometerActive(id: AnyHashable) -> Bool

    /// A Boolean value that indicates whether a magnetometer is available on the device
    func isMagnetometerAvailable(id: AnyHashable) -> Bool

    /// Creates a motion manager
    ///
    /// A motion manager must be first created before you can use its functionality, such as starting
    /// device motion updates or accessing data directly from the manager
    func create(id: AnyHashable) -> Effect<Never, Never>

    /// Destroys a currently running motion manager
    ///
    /// In is good practice to destroy a motion manager once you are done with it, such as when you
    /// leave a screen or no longer need motion data
    func destroy(id: AnyHashable) -> Effect<Never, Never>

    /// The latest sample of device-motion data
    func deviceMotion(id: AnyHashable) -> DeviceMotion?

    /// The latest sample of gyroscope data
    func gyroData(id: AnyHashable) -> GyroData?

    /// The latest sample of accelerometer data
    func accelerometerData(id: AnyHashable) -> AccelerometerData?

    /// Returns either the reference frame currently being used or the default attitude reference
    /// frame
    func attitudeReferenceFrame(id: AnyHashable) -> CMAttitudeReferenceFrame

    /// The latest sample of magnetometer data
    func magnetometerData(id: AnyHashable) -> MagnetometerData?

    /// Sets certain properties on the motion manager.
    func setAccelerometerUpdateInterval(_ accelerometerUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never>

    /// Sets certain properties on the motion manager.
    func setDeviceMotionUpdateInterval(_ deviceMotionUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never>

    /// Sets certain properties on the motion manager.
    func setGyroUpdateInterval(_ gyroUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never>

    /// Sets certain properties on the motion manager.
    func setMagnetometerUpdateInterval(_ magnetometerUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never>

    /// Sets certain properties on the motion manager.
    func setShowsDeviceMovementDisplay(_ showsDeviceMovementDisplay: Bool, id: AnyHashable) -> Effect<Never, Never>

    /// Starts accelerometer updates without a handler.
    ///
    /// Returns a long-living effect that emits accelerometer data each time the motion manager
    /// receives a new value.
    func startAccelerometerUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<AccelerometerData, Error>

    /// Starts device-motion updates without a block handler.
    ///
    /// Returns a long-living effect that emits device motion data each time the motion manager
    /// receives a new value.
    func startDeviceMotionUpdates(
        id: AnyHashable,
        using referenceFrame: CMAttitudeReferenceFrame,
        to queue: OperationQueue
    ) -> Effect<DeviceMotion, Error>

    /// Starts device-motion updates without a block handler.
    ///
    /// Returns a long-living effect that emits device motion data each time the motion manager
    /// receives a new value.
    func startDeviceMotionUpdates(
        id: AnyHashable,
        to queue: OperationQueue
    ) -> Effect<DeviceMotion, Error>

    /// Starts gyroscope updates without a handler.
    ///
    /// Returns a long-living effect that emits gyro data each time the motion manager receives a
    /// new value.
    func startGyroUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<GyroData, Error>

    /// Starts magnetometer updates without a block handler.
    ///
    /// Returns a long-living effect that emits magnetometer data each time the motion manager
    /// receives a new value.
    func startMagnetometerUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<MagnetometerData, Error>

    /// Stops accelerometer updates.
    func stopAccelerometerUpdates(id: AnyHashable) -> Effect<Never, Never>

    /// Stops device-motion updates.
    func stopDeviceMotionUpdates(id: AnyHashable) -> Effect<Never, Never>

    /// Stops gyroscope updates.
    func stopGyroUpdates(id: AnyHashable) -> Effect<Never, Never>

    /// Stops magnetometer updates.
    func stopMagnetometerUpdates(id: AnyHashable) -> Effect<Never, Never>
}

@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
public extension MotionManager {

    /// Starts accelerometer updates without a handler.
    ///
    /// Returns a long-living effect that emits accelerometer data each time the motion manager
    /// receives a new value.
    func startAccelerometerUpdates(id: AnyHashable) -> Effect<AccelerometerData, Error> {
        startAccelerometerUpdates(id: id, to: .main)
    }

    /// Starts device-motion updates without a block handler.
    ///
    /// Returns a long-living effect that emits device motion data each time the motion manager
    /// receives a new value.
    func startDeviceMotionUpdates(id: AnyHashable, using referenceFrame: CMAttitudeReferenceFrame) -> Effect<DeviceMotion, Error> {
        startDeviceMotionUpdates(id: id, using: referenceFrame, to: .main)
    }

    /// Starts device-motion updates without a block handler.
    ///
    /// Returns a long-living effect that emits device motion data each time the motion manager
    /// receives a new value.
    func startDeviceMotionUpdates(id: AnyHashable) -> Effect<DeviceMotion, Error> {
        startDeviceMotionUpdates(id: id, to: .main)
    }

    /// Starts gyroscope updates without a handler.
    ///
    /// Returns a long-living effect that emits gyro data each time the motion manager receives a
    /// new value.
    func startGyroUpdates(id: AnyHashable) -> Effect<GyroData, Error> {
        startGyroUpdates(id: id, to: .main)
    }

    /// Starts magnetometer updates without a block handler.
    ///
    /// Returns a long-living effect that emits magnetometer data each time the motion manager
    /// receives a new value.
    func startMagnetometerUpdates(id: AnyHashable) -> Effect<MagnetometerData, Error> {
        startMagnetometerUpdates(id: id, to: .main)
    }
}
