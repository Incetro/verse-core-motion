import VERSE
import Combine
import CoreMotion
import Foundation

// MARK: - MotionManagerImplementation

@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
final class MotionManagerImplementation {

    // MARK: - Properties

    /// All currently available motion managers
    private var managers: [AnyHashable: CMMotionManager] = [:]

    /// Accelerometer subscribers
    private var accelerometerUpdatesSubscribers: [AnyHashable: Effect<AccelerometerData, Error>.Subscriber] = [:]

    /// Device motion subscribers
    private var deviceMotionUpdatesSubscribers: [AnyHashable: Effect<DeviceMotion, Error>.Subscriber] = [:]

    /// Gyro subscribers
    private var deviceGyroUpdatesSubscribers: [AnyHashable: Effect<GyroData, Error>.Subscriber] = [:]

    /// Magnetometer subscribers
    private var deviceMagnetometerUpdatesSubscribers: [AnyHashable: Effect<MagnetometerData, Error>.Subscriber] = [:]

    // MARK: - Private

    /// Obtain a motion manager by its identifier
    /// - Parameter id: target motion manager id
    /// - Returns: result CMMotionManager instance
    private func requireMotionManager(id: AnyHashable) -> CMMotionManager? {
        if managers[id] == nil {
            couldNotFindMotionManager(id: id)
        }
        return managers[id]
    }

    /// Throws assertion about event when we cannot find necessary dependency
    /// - Parameter id: problem identifier
    private func couldNotFindMotionManager(id: Any) {
        assertionFailure(
        """
        A motion manager could not be found with the id \(id). This is considered a programmer error. \
        You should not invoke methods on a motion manager before it has been created or after it \
        has been destroyed. Refactor your code to make sure there is a motion manager created by the \
        time you invoke this endpoint.
        """
        )
    }

}

// MARK: - MotionManager

@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
extension MotionManagerImplementation: MotionManager {

    func isAccelerometerActive(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isAccelerometerActive ?? false
    }

    func isAccelerometerAvailable(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isAccelerometerAvailable ?? false
    }

    func isDeviceMotionActive(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isDeviceMotionActive ?? false
    }

    func isDeviceMotionAvailable(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isDeviceMotionAvailable ?? false
    }

    func isGyroActive(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isGyroActive ?? false
    }

    func isGyroAvailable(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isGyroAvailable ?? false
    }

    func isMagnetometerActive(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isDeviceMotionActive ?? false
    }

    func isMagnetometerAvailable(id: AnyHashable) -> Bool {
        requireMotionManager(id: id)?.isMagnetometerAvailable ?? false
    }

    func create(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            guard let self = self else { return }
            if self.managers[id] != nil {
                assertionFailure(
                """
                You are attempting to create a motion manager with the id \(id), but there is already \
                a running manager with that id. This is considered a programmer error since you may \
                be accidentally overwriting an existing manager without knowing.

                To fix you should either destroy the existing manager before creating a new one, or \
                you should not try creating a new one before this one is destroyed.
                """
                )
            }
            self.managers[id] = CMMotionManager()
        }
    }

    func destroy(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in self?.managers[id] = nil }
    }

    func deviceMotion(id: AnyHashable) -> DeviceMotion? {
        requireMotionManager(id: id)?.deviceMotion.map(DeviceMotion.init)
    }

    func gyroData(id: AnyHashable) -> GyroData? {
        requireMotionManager(id: id)?.gyroData.map(GyroData.init)
    }

    func accelerometerData(id: AnyHashable) -> AccelerometerData? {
        requireMotionManager(id: id)?.accelerometerData.map(AccelerometerData.init)
    }

    func attitudeReferenceFrame(id: AnyHashable) -> CMAttitudeReferenceFrame {
        requireMotionManager(id: id)?.attitudeReferenceFrame ?? .init()
    }

    func magnetometerData(id: AnyHashable) -> MagnetometerData? {
        requireMotionManager(id: id)?.magnetometerData.map(MagnetometerData.init)
    }

    func setAccelerometerUpdateInterval(_ accelerometerUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            self?.requireMotionManager(id: id).map { manager in
                manager.accelerometerUpdateInterval = accelerometerUpdateInterval
            }
        }
    }

    func setDeviceMotionUpdateInterval(_ deviceMotionUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            self?.requireMotionManager(id: id).map { manager in
                manager.deviceMotionUpdateInterval = deviceMotionUpdateInterval
            }
        }
    }

    func setGyroUpdateInterval(_ gyroUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            self?.requireMotionManager(id: id).map { manager in
                manager.gyroUpdateInterval = gyroUpdateInterval
            }
        }
    }

    func setMagnetometerUpdateInterval(_ magnetometerUpdateInterval: TimeInterval, id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            self?.requireMotionManager(id: id).map { manager in
                manager.magnetometerUpdateInterval = magnetometerUpdateInterval
            }
        }
    }

    func setShowsDeviceMovementDisplay(_ showsDeviceMovementDisplay: Bool, id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            self?.requireMotionManager(id: id).map { manager in
                manager.showsDeviceMovementDisplay = showsDeviceMovementDisplay
            }
        }
    }

    func startAccelerometerUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<AccelerometerData, Error> {
        .run { [weak self] subscriber in

            guard let self = self else { return AnyCancellable {} }
            guard let manager = self.requireMotionManager(id: id) else { return AnyCancellable {} }
            guard self.accelerometerUpdatesSubscribers[id] == nil else { return AnyCancellable {} }

            self.accelerometerUpdatesSubscribers[id] = subscriber
            manager.startAccelerometerUpdates(to: queue) { data, error in
                if let data = data {
                    subscriber.send(.init(data))
                } else if let error = error {
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable {
                manager.stopAccelerometerUpdates()
            }
        }
    }

    func startDeviceMotionUpdates(
        id: AnyHashable,
        using referenceFrame: CMAttitudeReferenceFrame,
        to queue: OperationQueue
    ) -> Effect<DeviceMotion, Error> {
        .run { [weak self] subscriber in

            guard let self = self else { return AnyCancellable {} }
            guard let manager = self.requireMotionManager(id: id) else { return AnyCancellable {} }
            guard self.deviceMotionUpdatesSubscribers[id] == nil else { return AnyCancellable {} }

            self.deviceMotionUpdatesSubscribers[id] = subscriber
            manager.startDeviceMotionUpdates(using: referenceFrame, to: queue) { data, error in
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

    func startGyroUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<GyroData, Error> {
        .run { [weak self] subscriber in

            guard let self = self else { return AnyCancellable {} }
            guard let manager = self.requireMotionManager(id: id) else { return AnyCancellable {} }
            guard self.deviceGyroUpdatesSubscribers[id] == nil else { return AnyCancellable {} }

            self.deviceGyroUpdatesSubscribers[id] = subscriber
            manager.startGyroUpdates(to: queue) { data, error in
                if let data = data {
                    subscriber.send(.init(data))
                } else if let error = error {
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable {
                manager.stopGyroUpdates()
            }
        }
    }

    func startMagnetometerUpdates(id: AnyHashable, to queue: OperationQueue) -> Effect<MagnetometerData, Error> {
        .run { [weak self] subscriber in

            guard let self = self else { return AnyCancellable {} }
            guard let manager = self.managers[id] else {
                self.couldNotFindMotionManager(id: id)
                return AnyCancellable {}
            }
            guard self.deviceMagnetometerUpdatesSubscribers[id] == nil else { return AnyCancellable {} }

            self.deviceMagnetometerUpdatesSubscribers[id] = subscriber
            manager.startMagnetometerUpdates(to: queue) { data, error in
                if let data = data {
                    subscriber.send(.init(data))
                } else if let error = error {
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable {
                manager.stopMagnetometerUpdates()
            }
        }
    }

    func stopAccelerometerUpdates(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            guard let self = self else { return }
            guard let manager = self.managers[id] else {
                self.couldNotFindMotionManager(id: id)
                return
            }
            manager.stopAccelerometerUpdates()
            self.accelerometerUpdatesSubscribers[id]?.send(completion: .finished)
            self.accelerometerUpdatesSubscribers[id] = nil
        }
    }

    func stopDeviceMotionUpdates(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            guard let self = self else { return }
            guard let manager = self.managers[id] else {
                self.couldNotFindMotionManager(id: id)
                return
            }
            manager.stopDeviceMotionUpdates()
            self.deviceMotionUpdatesSubscribers[id]?.send(completion: .finished)
            self.deviceMotionUpdatesSubscribers[id] = nil
        }
    }

    func stopGyroUpdates(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            guard let self = self else { return }
            guard let manager = self.managers[id] else {
                self.couldNotFindMotionManager(id: id)
                return
            }
            manager.stopGyroUpdates()
            self.deviceGyroUpdatesSubscribers[id]?.send(completion: .finished)
            self.deviceGyroUpdatesSubscribers[id] = nil
        }
    }

    func stopMagnetometerUpdates(id: AnyHashable) -> Effect<Never, Never> {
        .fireAndForget { [weak self] in
            guard let self = self else { return }
            guard let manager = self.managers[id] else {
                self.couldNotFindMotionManager(id: id)
                return
            }
            manager.stopMagnetometerUpdates()
            self.deviceMagnetometerUpdatesSubscribers[id]?.send(completion: .finished)
            self.deviceMagnetometerUpdatesSubscribers[id] = nil
        }
    }
}
