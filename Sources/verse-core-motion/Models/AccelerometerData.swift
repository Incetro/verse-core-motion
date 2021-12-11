#if canImport(CoreMotion)
import CoreMotion

// MARK: - AccelerometerData

/// A data sample from the device's three accelerometers.
///
/// See the documentation for `CMAccelerometerData` for more info.
public struct AccelerometerData: Hashable {

    // MARK: - Properties

    /// CMAcceleration value
    public var acceleration: CMAcceleration

    // MARK: - Initializers

    /// CMAccelerometerData initializer
    /// - Parameter accelerometerData: CMAccelerometerData instance
    public init(_ accelerometerData: CMAccelerometerData) {
        self.acceleration = accelerometerData.acceleration
    }

    /// CMAcceleration initializer
    /// - Parameter acceleration: CMAcceleration instance
    public init(acceleration: CMAcceleration) {
        self.acceleration = acceleration
    }

    // MARK: - Hashable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.acceleration.x == rhs.acceleration.x
        && lhs.acceleration.y == rhs.acceleration.y
        && lhs.acceleration.z == rhs.acceleration.z
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(acceleration.x)
        hasher.combine(acceleration.y)
        hasher.combine(acceleration.z)
    }
}
#endif
