//
//  ContentView.swift
//  ControllingLight
//
//  Created by Cristian Díaz on 30.11.23.
//

import LightControls
import RealityKit
import SwiftUI

struct ContentView: View {
  @State private var isSheetPresented = true
  let arViewContainer = ARViewContainer()

  var body: some View {
    ZStack {
      arViewContainer.edgesIgnoringSafeArea(.all)
    }
    .sheet(isPresented: $isSheetPresented) {
      NavigationStack {
        List {
          NavigationLink {
            DirectionalLightControl(
              light: arViewContainer.directionalLight
            )
            .navigationTitle("DirectionalLight")
            .navigationBarTitleDisplayMode(.inline)
          } label: {
            Label("DirectionalLight", systemImage: "sun.max")
          }

          NavigationLink {
            PointLightControl(
              light: arViewContainer.pointLight
            )
            .navigationTitle("PointLight")
            .navigationBarTitleDisplayMode(.inline)
          } label: {
            Label("PointLight", systemImage: "lightbulb.min")
          }

          NavigationLink {
            SpotLightControl(
              light: arViewContainer.spotLight
            )
            .navigationTitle("SpotLight")
            .navigationBarTitleDisplayMode(.inline)
          } label: {
            Label("SpotLight", systemImage: "lamp.desk")
          }
        }
      }
      .interactiveDismissDisabled()
      .presentationDetents([.medium, .height(200)])
    }
  }
}

struct ARViewContainer: UIViewRepresentable {
  let arView = ARView(frame: .zero)
  let directionalLight = RealityKit.DirectionalLight()
  let pointLight = RealityKit.PointLight()
  let spotLight = RealityKit.SpotLight()

  func makeUIView(context: Context) -> ARView {

    // Create a cube model
    let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
    let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
    let model = ModelEntity(mesh: mesh, materials: [material])
    model.transform.translation.x = 0.25
    model.transform.translation.y = 0.05

    // Create horizontal plane anchor for the content
    let anchor = AnchorEntity(
      .plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2))
    )
    anchor.children.append(model)

    // Another model for reference
    let sphere = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [material])
    sphere.transform.translation.x = -0.25
    sphere.transform.translation.y = 0.05
    anchor.children.append(sphere)

    // Add a more complex model
    if let robot = try? Entity.load(named: "robot_walk_idle") {
      anchor.children.append(robot)
      for animation in robot.availableAnimations {
        robot.playAnimation(animation.repeat())
      }
    }

    // Add lights
    anchor.addChild(directionalLight)

    pointLight.transform.translation.x = -0.25
    pointLight.transform.translation.y = 0.25
    anchor.addChild(pointLight)

    spotLight.transform.translation.x = 0.25
    spotLight.transform.translation.y = 0.5
    anchor.addChild(spotLight)

    // Add the horizontal plane anchor to the scene
    arView.scene.anchors.append(anchor)

    return arView
  }

  func updateUIView(_ uiView: ARView, context: Context) {}

}

#Preview {
  ContentView()
}
