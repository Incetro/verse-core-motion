#if canImport(CoreMotion)
import CoreMotion

// MARK: - MagnetometerData

/// Measurements of the Earth's magnetic field relative to the device.
///
/// See the documentation for `CMMagnetometerData` for more info.
public struct MagnetometerData: Hashable {

    // MARK: - Properties

    /// Magnetic field instance
    public var magneticField: CMMagneticField

    /// Timestamp value
    public var timestamp: TimeInterval

    // MARK: - Initializers

    /// CMMagnetometerData initializer
    /// - Parameter magnetometerData: megnetometer data
    public init(_ magnetometerData: CMMagnetometerData) {
        self.magneticField = magnetometerData.magneticField
        self.timestamp = magnetometerData.timestamp
    }

    /// CMMagneticField initializer
    /// - Parameters:
    ///   - magneticField: magnetic field instance
    ///   - timestamp: timestamp value
    public init(
        magneticField: CMMagneticField,
        timestamp: TimeInterval
    ) {
        self.magneticField = magneticField
        self.timestamp = timestamp
    }

    // MARK: - Hashable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.magneticField.x == rhs.magneticField.x
        && lhs.magneticField.y == rhs.magneticField.y
        && lhs.magneticField.z == rhs.magneticField.z
        && lhs.timestamp == rhs.timestamp
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(magneticField.x)
        hasher.combine(magneticField.y)
        hasher.combine(magneticField.z)
        hasher.combine(timestamp)
    }
}
#endif
