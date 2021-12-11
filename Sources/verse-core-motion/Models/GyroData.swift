#if canImport(CoreMotion)
import CoreMotion

// MARK: - GyroData

/// A single measurement of the device's rotation rate
///
/// See the documentation for `CMGyroData` for more info
public struct GyroData: Hashable {

    // MARK: - Properties

    /// Rotation rate value
    public var rotationRate: CMRotationRate

    /// Timestamp value
    public var timestamp: TimeInterval

    // MARK: - Initializers

    /// CMGyroData initializer
    /// - Parameter gyroData: CMGyroData instance
    public init(_ gyroData: CMGyroData) {
        self.rotationRate = gyroData.rotationRate
        self.timestamp = gyroData.timestamp
    }

    /// CMRotationRate initializer
    /// - Parameters:
    ///   - rotationRate: rotation rate value
    ///   - timestamp: timestamp value
    public init(
        rotationRate: CMRotationRate,
        timestamp: TimeInterval
    ) {
        self.rotationRate = rotationRate
        self.timestamp = timestamp
    }

    // MARK: - Hashable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rotationRate.x == rhs.rotationRate.x
        && lhs.rotationRate.y == rhs.rotationRate.y
        && lhs.rotationRate.z == rhs.rotationRate.z
        && lhs.timestamp == rhs.timestamp
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rotationRate.x)
        hasher.combine(rotationRate.y)
        hasher.combine(rotationRate.z)
        hasher.combine(timestamp)
    }
}
#endif
