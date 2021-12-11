#if canImport(CoreMotion)
import CoreMotion

// MARK: - DeviceMotion

/// Encapsulated measurements of the attitude, rotation rate, and acceleration of a device.
///
/// See the documentation for `CMDeviceMotion` for more info.
public struct DeviceMotion: Hashable {

    // MARK: - Properties

    /// Attitude instance
    public var attitude: Attitude

    /// CMAcceleration instance
    public var gravity: CMAcceleration

    /// Heading value
    public var heading: Double

    /// CMCalibratedMagneticField instance
    public var magneticField: CMCalibratedMagneticField

    /// CMRotationRate instance
    public var rotationRate: CMRotationRate

    /// Timestamp value
    public var timestamp: TimeInterval

    /// CMAcceleration instance
    public var userAcceleration: CMAcceleration

    // MARK: - Initializers

    /// CMDeviceMotion initializer
    /// - Parameter deviceMotion: CMDeviceMotion instance
    public init(_ deviceMotion: CMDeviceMotion) {
        self.attitude = Attitude(deviceMotion.attitude)
        self.gravity = deviceMotion.gravity
        self.heading = deviceMotion.heading
        self.magneticField = deviceMotion.magneticField
        self.rotationRate = deviceMotion.rotationRate
        self.timestamp = deviceMotion.timestamp
        self.userAcceleration = deviceMotion.userAcceleration
    }

    /// Default initializer
    /// - Parameters:
    ///   - attitude: Attitude instance
    ///   - gravity: CMAcceleration instance
    ///   - heading: heading value
    ///   - magneticField: CMCalibratedMagneticField instance
    ///   - rotationRate: CMRotationRate instance
    ///   - timestamp: timestamp value
    ///   - userAcceleration: CMAcceleration instance
    public init(
        attitude: Attitude,
        gravity: CMAcceleration,
        heading: Double,
        magneticField: CMCalibratedMagneticField,
        rotationRate: CMRotationRate,
        timestamp: TimeInterval,
        userAcceleration: CMAcceleration
    ) {
        self.attitude = attitude
        self.gravity = gravity
        self.heading = heading
        self.magneticField = magneticField
        self.rotationRate = rotationRate
        self.timestamp = timestamp
        self.userAcceleration = userAcceleration
    }

    // MARK: - Hashable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.attitude == rhs.attitude
        && lhs.gravity.x == rhs.gravity.x
        && lhs.gravity.y == rhs.gravity.y
        && lhs.gravity.z == rhs.gravity.z
        && lhs.heading == rhs.heading
        && lhs.magneticField.accuracy == rhs.magneticField.accuracy
        && lhs.magneticField.field.x == rhs.magneticField.field.x
        && lhs.magneticField.field.y == rhs.magneticField.field.y
        && lhs.magneticField.field.z == rhs.magneticField.field.z
        && lhs.rotationRate.x == rhs.rotationRate.x
        && lhs.rotationRate.y == rhs.rotationRate.y
        && lhs.rotationRate.z == rhs.rotationRate.z
        && lhs.timestamp == rhs.timestamp
        && lhs.userAcceleration.x == rhs.userAcceleration.x
        && lhs.userAcceleration.y == rhs.userAcceleration.y
        && lhs.userAcceleration.z == rhs.userAcceleration.z
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attitude)
        hasher.combine(gravity.x)
        hasher.combine(gravity.y)
        hasher.combine(gravity.z)
        hasher.combine(heading)
        hasher.combine(magneticField.accuracy)
        hasher.combine(magneticField.field.x)
        hasher.combine(magneticField.field.y)
        hasher.combine(magneticField.field.z)
        hasher.combine(rotationRate.x)
        hasher.combine(rotationRate.y)
        hasher.combine(rotationRate.z)
        hasher.combine(timestamp)
        hasher.combine(userAcceleration.x)
        hasher.combine(userAcceleration.y)
        hasher.combine(userAcceleration.z)
    }
}
#endif
