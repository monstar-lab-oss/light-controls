import ComposableArchitecture
import Models
import RealityKit
import SwiftUI

public struct PointLightControl: View {
  @State private var store: StoreOf<PointLight>
  let pointLight: RealityKit.PointLight

  public init(
    light pointLight: RealityKit.PointLight
  ) {
    self.pointLight = pointLight
    self.store = Store(
      initialState: PointLight.State(
        attenuationRadius: pointLight.light.attenuationRadius,
        color: Color(pointLight.light.color),
        intensity: Illuminance(lux: pointLight.light.intensity),
        isEnabled: pointLight.isEnabled,
        orientation: pointLight.orientation
      )
    ) {
      PointLight()
    }
  }

  public var body: some View {
    Form {
      LightComponent(store: store)
        .onChange(of: store.attenuationRadius) { _, newValue in
          pointLight.light.attenuationRadius = newValue
        }
        .onChange(of: store.color) { _, newValue in
          pointLight.light.color = UIColor(newValue)
        }
        .onChange(of: store.intensity) { _, newValue in
          pointLight.light.intensity = Float(newValue.lux)
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
      pointLight.isEnabled = newValue
    }
  }
}

#Preview {
  PointLightControl(light: .init())
}

//MARK: - Light Component

extension PointLightControl {
  struct LightComponent: View {
    @Bindable var store: StoreOf<PointLight>

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
              .accessibilityHidden(true)
          },
          maximumValueLabel: {
            Text("10 m")
              .font(.caption)
              .foregroundColor(.secondary)
              .accessibilityHidden(true)
          }
        )
        .accessibilityHint(
          "Defines light reach and calculates its falloff. Can greatly affect performance, so it should be used sparingly."
        )
      }
    }
  }
}
