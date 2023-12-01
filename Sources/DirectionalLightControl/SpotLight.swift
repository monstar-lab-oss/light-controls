import ComposableArchitecture
import Models
import SwiftUI
import simd

/// An entity that illuminates virtual content in a cone-shaped volume.
/// https://developer.apple.com/documentation/realitykit/spotlight

@Reducer
public struct SpotLight: Reducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var attenuationRadius: Float
    public var color: Color
    public var intensity: Illuminance
    public var innerAngleInDegrees: Float
    public var isEnabled: Bool
    public var orientation: simd_quatf
    public var outerAngleInDegrees: Float
    let rotationRange: ClosedRange<Double> = -360...360
    var rotationX: Angle
    var rotationY: Angle

    public init(
      attenuationRadius: Float,
      color: Color,
      intensity: Illuminance,
      innerAngleInDegrees: Float,
      isEnabled: Bool,
      orientation: simd_quatf,
      outerAngleInDegrees: Float
    ) {
      self.attenuationRadius = attenuationRadius
      self.color = color
      self.isEnabled = isEnabled
      self.intensity = intensity
      self.innerAngleInDegrees = innerAngleInDegrees
      self.orientation = orientation
      self.outerAngleInDegrees = outerAngleInDegrees
      self.rotationX = Angle(radians: Double(orientation.vector.x))
      self.rotationY = Angle(radians: Double(orientation.vector.y))
    }
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<SpotLight.State>)
    case lightOrientationDidChange
    case toggle
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
        case .binding(\.rotationX):
          return .send(.lightOrientationDidChange)

        case .binding(\.rotationY):
          return .send(.lightOrientationDidChange)

        case .binding(_):
          return .none

        case .lightOrientationDidChange:
          state.orientation = simd_quatf(
            vector: vector_float4(
              Float(state.rotationX.radians),
              Float(state.rotationY.radians),
              state.orientation.vector.z,
              state.orientation.vector.w
            )
          )
          return .none

        case .toggle:
          state.isEnabled.toggle()
          return .none
      }
    }
  }
}
