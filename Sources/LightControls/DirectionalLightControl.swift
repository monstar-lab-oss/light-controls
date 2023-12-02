import ComposableArchitecture
import Models
import RealityKit
import SwiftUI

public struct DirectionalLightControl: View {
  @State private var store: StoreOf<DirectionalLight>
  let directionalLight: RealityKit.DirectionalLight

  public init(
    light directionalLight: RealityKit.DirectionalLight
  ) {
    self.directionalLight = directionalLight
    self.store = Store(
      initialState: DirectionalLight.State(
        color: Color(directionalLight.light.color),
        intensity: Illuminance(lux: directionalLight.light.intensity),
        isEnabled: directionalLight.isEnabled,
        isRealWorldProxy: directionalLight.light.isRealWorldProxy,
        orientation: directionalLight.orientation,
        shadowDepthBias: directionalLight.shadow?.depthBias,
        shadowMaximumDistance: directionalLight.shadow?.maximumDistance
      )
    ) {
      DirectionalLight()
    }
  }

  public var body: some View {
    Form {
      LightComponentControl(store: store)
        .onChange(of: store.color) { _, newValue in
          directionalLight.light.color = UIColor(newValue)
        }
        .onChange(of: store.intensity) { _, newValue in
          directionalLight.light.intensity = Float(newValue.lux)
        }
        .onChange(of: store.isRealWorldProxy) { _, newValue in
          directionalLight.light.isRealWorldProxy = newValue
        }

      OrientationControl(store: store)
        .onChange(of: store.orientation) { _, newValue in
          directionalLight.orientation = newValue
        }

      ShadowComponentControl(store: store)
        .onChange(of: store.shadowDepthBias) { _, newValue in
          if let newValue {
            directionalLight.shadow?.depthBias = newValue
          }
        }
        .onChange(of: store.shadowMaximumDistance) { _, newValue in
          if let newValue {
            directionalLight.shadow?.maximumDistance = newValue
          }
        }
    }
    .toolbar {
      ToolbarItem {
        Toggle(
          "Enabled",
          systemImage: "power.circle",
          isOn: $store.isEnabled
        )
      }
    }
    .onChange(of: store.isEnabled) { _, newValue in
      directionalLight.isEnabled = newValue
    }
  }
}

#Preview {
  DirectionalLightControl(light: .init())
}

//MARK: - Light Component

extension DirectionalLightControl {
  struct LightComponentControl: View {
    @Bindable var store: StoreOf<DirectionalLight>

    var body: some View {
      Section("Light Component") {
        ColorPicker("Color", selection: $store.color)
          .accessibilityHint("Sets the LightComponent color attribute.")

        Picker(
          "Lux Preset",
          selection: $store.intensity
        ) {
          ForEach(Illuminance.allCases, id: \.self) { preset in
            Group {
              Text("\(preset.lux, format: .number)")
                + Text(" (\(preset.description))")
            }
            .tag(preset as Illuminance?)
          }
        }
        .pickerStyle(MenuPickerStyle())
        .accessibilityHint("Sets the intensity of light from a list of common lux settings.")

        Toggle("Real World Proxy", isOn: $store.isRealWorldProxy)
          .accessibilityHint("Set it to true to cast shadows without illuminating the scene.")
      }
    }
  }
}

//MARK: - Orientation

extension DirectionalLightControl {
  struct OrientationControl: View {
    @Bindable var store: StoreOf<DirectionalLight>

    var body: some View {
      Section("Orientation") {
        Stepper(
          "Rotation X: \(store.rotationX.degrees.formatted())",
          value: $store.rotationX.degrees
        )
        .accessibilityHidden(true)

        //FIXME: use propper formatters
        Slider(
          value: $store.rotationX.degrees,
          in: store.rotationRange,
          step: 1,
          label: { Text("Rotation X") },
          minimumValueLabel: {
            Text("\(Int(store.rotationRange.lowerBound))º")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          },
          maximumValueLabel: {
            Text("\(Int(store.rotationRange.upperBound))º")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          }
        )

        Stepper(
          "Rotation Y: \(store.rotationY.degrees.formatted())",
          value: $store.rotationY.degrees
        )
        .accessibilityHidden(true)

        Slider(
          value: $store.rotationY.degrees,
          in: store.rotationRange,
          step: 1,
          label: { Text("Rotation Y") },
          minimumValueLabel: {
            Text("\(Int(store.rotationRange.lowerBound))º")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
              .accessibilityHidden(true)
          },
          maximumValueLabel: {
            Text("\(Int(store.rotationRange.upperBound))º")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
              .accessibilityHidden(true)
          }
        )
      }
    }
  }
}

//MARK: - Shadow Component

extension DirectionalLightControl {
  struct ShadowComponentControl: View {
    @Bindable var store: StoreOf<DirectionalLight>

    var body: some View {
      Section("Shadow Component") {
        let depthBiasRange: ClosedRange<Float> = 0...10
        //TODO: limit stepper to range bounds
        Stepper(
          label: {
            Label(
              "Depth Bias: \((store.shadowDepthBias ?? 0.0), format: .number)",
              systemImage: "square.3.stack.3d.top.filled"
            )
          },
          onIncrement: {
            store.shadowDepthBias = (store.shadowDepthBias ?? 0.0) + 0.1
          },
          onDecrement: {
            store.shadowDepthBias = (store.shadowDepthBias ?? 0.0) - 0.1
          }
        )
        .accessibilityHidden(true)

        Slider(
          value: Binding(
            get: { store.shadowDepthBias ?? 0.0 },
            set: { store.shadowDepthBias = $0 }
          ),
          in: depthBiasRange,
          step: 0.1,
          label: { Text("Depth Bias") },
          minimumValueLabel: {
            Text("\(Int(depthBiasRange.lowerBound))")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          },
          maximumValueLabel: {
            Text("\(Int(depthBiasRange.upperBound))")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          }
        )
        .accessibilityHint(
          "Adjusts it to avoid shadow acne and self-shadowing. It ensures the shadow is properly rendered and does not intersect with the surface."
        )

        let maximumDistanceRange: ClosedRange<Float> = 0...20
        //TODO: limit stepper to range bounds
        Stepper(
          label: {
            Label(
              "Distance: \((store.shadowMaximumDistance ?? 0.0), format: .number)",
              systemImage: "shadow"
            )
          },
          onIncrement: {
            store.shadowDepthBias = (store.shadowMaximumDistance ?? 0.0) + 0.1
          },
          onDecrement: {
            store.shadowDepthBias = (store.shadowMaximumDistance ?? 0.0) - 0.1
          }
        )
        .accessibilityHidden(true)

        Slider(
          value: Binding(
            get: { store.shadowMaximumDistance ?? 0.0 },
            set: { store.shadowMaximumDistance = $0 }
          ),
          in: maximumDistanceRange,
          step: 0.1,
          label: { Text("Maximum Distance") },
          minimumValueLabel: {
            Text("\(Int(maximumDistanceRange.lowerBound))")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          },
          maximumValueLabel: {
            Text("\(Int(maximumDistanceRange.upperBound))")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          }
        )
        .accessibilityHint(
          "Sets shadow split distance. It lets customize shadow display to only show at particular distances. This can enhance performance and improve visual appearance."
        )
      }
    }
  }
}
