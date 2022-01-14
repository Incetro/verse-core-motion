# VERSE Core Motion

VERSE Core Motion extends [VERSE](https://github.com/Incetro/verse) to support native [Core Motion](https://developer.apple.com/documentation/coremotion) API

* [Example](#example)
* [Basic usage](#basic-usage)
* [Installation](#installation)
* [License](#license)

## Example

Check out the [Meter](./Examples/Meter) demo to see VERSECoreMotion in practice. Launch it, tap on the rectangles and move your phone in your hands. If you tap again, MotionManager stops.

https://user-images.githubusercontent.com/66957916/145719970-a044503e-6fad-4b69-9125-5b95c4e8b898.MP4

## Basic Usage

To use `VERSECoreMotion` in your apps, add an action to your feature's module that represents the type of motion data you are interested in receiving. For example:

```swift
enum AppAction: Equatable {

    // MARK: - Cases

    ...
    
    /// Gyro data updates
    case gyroDataUpdate(Result<GyroData, NSError>)
    
    /// Device motion updates
    case deviceMotionUpdate(Result<DeviceMotion, NSError>)
    
    /// Magnetometer updates
    case magnetometerUpdate(Result<MagnetometerData, NSError>)
    
    /// Accelerometer updates
    case accelerometerUpdate(Result<AccelerometerData, NSError>)
}
```
These actions will be sent every time motion manager receives new data.

Let's see how to build a complete example app using VERSECoreMotion. Add action enum:

```swift
import Foundation
import VERSECoreMotion

// MARK: - MeterAction

enum MeterAction: Equatable {

    // MARK: - Cases

    case actionButtonTapped
    case deviceMotionUpdate(Result<DeviceMotion, NSError>)
}
```

Then, declare environemnt's dependency:

```swift
import Foundation
import VERSECoreMotion

// MARK: - MeterEnvironment

struct MeterEnvironment {

    // MARK: - Properties

    /// MotionManager instance
    let motionManager: MotionManager
}
```

Next, create module's state structure:

```swift
// MARK: - MeterState

struct MeterState: Equatable {

    // MARK: - Properties

    /// True if MotionManager is active at the moment
    var isActive = false

    /// Current device's pitch value
    var pitch: Double = 0.0

    /// Current device's roll value
    var roll: Double = 0.0
}
```

Then, create a motion manager by returning an effect from our reducer. You can either do this when your feature starts up, such as when `onAppear` is invoked, or you can do it when a user action occurs, such as when the user taps a button.

As an example, say we want to create a motion manager and start listening for motion updates when rectangle view is tapped. Then we can do both of those things by executing two effects, one after the other. Moreover, you can update your manager's properties the same way (in the example below we update motionManager's updating interval to fit 120FPS):

```swift
import VERSE
import Foundation

// MARK: - Reducer

let meterReducer = MeterReducer { state, action, environment in
    struct DeviceMotionID: Hashable {}
    switch action {
    case .actionButtonTapped:
        state.isActive.toggle()
        if state.isActive {
            return .concatenate(
                environment
                    .motionManager
                    .create(id: DeviceMotionID())
                    .fireAndForget(),
                environment
                    .motionManager
                    .setDeviceMotionUpdateInterval(1.0 / 120.0, id: DeviceMotionID())
                    .fireAndForget(),
                environment
                    .motionManager
                    .startDeviceMotionUpdates(id: DeviceMotionID())
                    .mapError { $0 as NSError }
                    .catchToEffect()
                    .map(MeterAction.deviceMotionUpdate)
            )
        } else {
            return .concatenate(
                environment
                    .motionManager
                    .stopDeviceMotionUpdates(id: DeviceMotionID())
                    .fireAndForget(),
                environment
                    .motionManager
                    .destroy(id: DeviceMotionID())
                    .fireAndForget()
            )
        }
    case .deviceMotionUpdate(.success(let deviceMotion)):
        state.pitch = deviceMotion.attitude.pitch
        state.roll = deviceMotion.attitude.roll
        return .none
    default:
        return .none
    }
}
```

Finally, add view implementation. We use `pitch` and `roll` with rectangles sequence, so they can move according to your motions and create beautiful perspective effect:

```swift
import VERSE
import SwiftUI

// MARK: - MeterView

struct MeterView: View {

    // MARK: - Properties

    /// Palette colors
    private let colors: [Color] = [
        .init(hex: "ffffff"),
        .init(hex: "f5f3f4"),
        .init(hex: "d3d3d3"),
        .init(hex: "b1a7a6"),
        .init(hex: "e5383b"),
        .init(hex: "a4161a"),
        .init(hex: "660708"),
        .init(hex: "161a1d"),
        .init(hex: "0b090a")
    ]

    /// `Meter` module `Store` instance
    private let store: MeterStore

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - store: MeterStore instance
    init(store: MeterStore) {
        self.store = store
    }

    // MARK: - View

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                let sizeStep: CGFloat = 35
                let magnitudeStep: CGFloat = 20
                ForEach(0..<colors.count) { index in
                    let size = CGFloat(colors.count - index) * sizeStep
                    let magnitude = 200 - CGFloat(index) * magnitudeStep
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                        .fill(colors[index])
                        .frame(width: size, height: size, alignment: .center)
                        .offset(x: CGFloat(viewStore.pitch * magnitude), y: CGFloat(viewStore.roll * magnitude))
                }
            }.onTapGesture {
                viewStore.send(.actionButtonTapped)
            }
        }
    }
}
```

This is only the tip of the iceberg. We can access any part of the `CMMotionManager` API in this way, and instantly unlock testability with how the motion functionality integrates with our core application logic. This can be incredibly powerful, and is typically not the kind of thing one can test easily.

## Installation

You can add ComposableCoreMotion to an Xcode project by adding it as a package dependency.

  1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
  2. Enter "https://github.com/Incetro/verse-core-motion" into the package repository URL text field

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
Thanks [pointfree](https://github.com/pointfreeco/composable-core-motion) very much for their idea 🖤
