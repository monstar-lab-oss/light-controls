import ComposableArchitecture
import Models
import SwiftUI
import simd

/// A directional light uniformly casts light along its z-axis—specifically, along (0, 0, -1).
/// https://developer.apple.com/documentation/realitykit/directionallight

@Reducer
public struct DirectionalLight: Reducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var color: Color
    public var intensity: Illuminance
    public var isEnabled: Bool
    public var isRealWorldProxy: Bool
    public var orientation: simd_quatf
    let rotationRange: ClosedRange<Double> = -360...360
    var rotationX: Angle
    var rotationY: Angle
    public var shadowDepthBias: Float?
    public var shadowMaximumDistance: Float?

    public init(
      color: Color,
      intensity: Illuminance,
      isEnabled: Bool,
      isRealWorldProxy: Bool,
      orientation: simd_quatf,
      shadowDepthBias: Float?,
      shadowMaximumDistance: Float?
    ) {
      self.color = color
      self.isEnabled = isEnabled
      self.isRealWorldProxy = isRealWorldProxy
      self.intensity = intensity
      self.orientation = orientation
      self.rotationX = Angle(radians: Double(orientation.vector.x))
      self.rotationY = Angle(radians: Double(orientation.vector.y))
      self.shadowDepthBias = shadowDepthBias
      self.shadowMaximumDistance = shadowMaximumDistance
    }
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<DirectionalLight.State>)
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
