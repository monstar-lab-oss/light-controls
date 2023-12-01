import ComposableArchitecture
import Models
import RealityKit
import SwiftUI

public struct PointLightControlView: View {
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
    ) { PointLight() }
  }

  public var body: some View {
    Form {
      //MARK: - Light Component

      Section("Light Component") {
        ColorPicker("Color", selection: $store.color)

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

        Text("Attenuation Radius: \(store.attenuationRadius, format: .number)")
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
      }
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
  PointLightControlView(light: .init())
}
