import ComposableArchitecture
import Models
import SwiftUI
import simd

/// An entity that produces an omnidirectional light for virtual objects.
/// https://developer.apple.com/documentation/realitykit/pointlight

@Reducer
public struct PointLight: Reducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var color: Color
    public var attenuationRadius: Float
    public var intensity: Illuminance
    public var isEnabled: Bool
    public var orientation: simd_quatf
    let rotationRange: ClosedRange<Double> = -360...360
    var rotationX: Angle
    var rotationY: Angle

    public init(
      attenuationRadius: Float,
      color: Color,
      intensity: Illuminance,
      isEnabled: Bool,
      orientation: simd_quatf
    ) {
      self.attenuationRadius = attenuationRadius
      self.color = color
      self.isEnabled = isEnabled
      self.intensity = intensity
      self.orientation = orientation
      self.rotationX = Angle(radians: Double(orientation.vector.x))
      self.rotationY = Angle(radians: Double(orientation.vector.y))
    }
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<PointLight.State>)
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
