import ComposableArchitecture
import Models
import RealityKit
import SwiftUI

public struct SpotLightControl: View {
  @State private var store: StoreOf<SpotLight>
  let spotLight: RealityKit.SpotLight

  public init(
    light spotLight: RealityKit.SpotLight
  ) {
    self.spotLight = spotLight
    self.store = Store(
      initialState: SpotLight.State(
        attenuationRadius: spotLight.light.attenuationRadius,
        color: Color(spotLight.light.color),
        intensity: Illuminance(lux: spotLight.light.intensity),
        innerAngleInDegrees: spotLight.light.innerAngleInDegrees,
        isEnabled: spotLight.isEnabled,
        orientation: spotLight.orientation,
        outerAngleInDegrees: spotLight.light.outerAngleInDegrees
      )
    ) {
      SpotLight()
    }
  }

  public var body: some View {
    Form {
      LightComponentControl(store: store)
        .onChange(of: store.attenuationRadius) { _, newValue in
          spotLight.light.attenuationRadius = newValue
        }
        .onChange(of: store.color) { _, newValue in
          spotLight.light.color = UIColor(newValue)
        }
        .onChange(of: store.intensity) { _, newValue in
          spotLight.light.intensity = Float(newValue.lux)
        }
        .onChange(of: store.innerAngleInDegrees) { _, newValue in
          spotLight.light.innerAngleInDegrees = newValue
        }

      OrientationControl(store: store)
        .onChange(of: store.orientation) { _, newValue in
          spotLight.orientation = newValue
        }
        .onChange(of: store.outerAngleInDegrees) { _, newValue in
          spotLight.light.outerAngleInDegrees = newValue
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
      spotLight.isEnabled = newValue
    }
  }
}

#Preview {
  SpotLightControl(light: .init())
}

//MARK: - Light Component

extension SpotLightControl {
  struct LightComponentControl: View {
    @Bindable var store: StoreOf<SpotLight>

    var body: some View {
      Section("Light Component") {
        ColorPicker("Color", selection: $store.color)
          .accessibilityHint(String(localized: "LightComponentColorHint", bundle: .module))

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

        Text("Attenuation Radius: \(store.attenuationRadius, format: .number)")
          .accessibilityHidden(true)

        Slider(
          value: $store.attenuationRadius,
          in: 0...10,
          step: 0.01,
          label: { Text("Attenuation Radius") },
          minimumValueLabel: {
            Text("0 m")
              .font(.caption)
              .foregroundColor(.secondary)
          },
          maximumValueLabel: {
            Text("10 m")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        )
        .accessibilityHint(
          "Defines light reach and calculates its falloff. Can greatly affect performance, so it should be used sparingly."
        )

        Text("Inner Angle: \(store.innerAngleInDegrees, format: .number)")
          .accessibilityHidden(true)

        Slider(
          value: $store.innerAngleInDegrees,
          in: 0...360,
          step: 1,
          label: { Text("Inner Angle") },
          minimumValueLabel: {
            Text("0º")
              .font(.caption)
              .foregroundColor(.secondary)
          },
          maximumValueLabel: {
            Text("360º")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        )
        .accessibilityHint(
          "Defines the angle of the cone that emits light at full intensity, in degrees"
        )

        Text("Outer Angle: \(store.outerAngleInDegrees, format: .number)")
          .accessibilityHidden(true)

        Slider(
          value: $store.outerAngleInDegrees,
          in: 0...360,
          step: 1,
          label: { Text("Outer Angle") },
          minimumValueLabel: {
            Text("0º")
              .font(.caption)
              .foregroundColor(.secondary)
          },
          maximumValueLabel: {
            Text("360º")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        )
        .accessibilityHint(
          "Defines the angle of the cone beyond which the light's intensity is zero, in degrees"
        )
      }
    }
  }
}

//MARK: - Orientation

extension SpotLightControl {
  struct OrientationControl: View {
    @Bindable var store: StoreOf<SpotLight>

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
          },
          maximumValueLabel: {
            Text("\(Int(store.rotationRange.upperBound))º")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          }
        )
      }
    }
  }
}
