// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "light-controls",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "LightControls",
      targets: ["LightControls"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      branch: "observation-beta"
    )
  ],
  targets: [
    .target(
      name: "LightControls",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Models",
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(name: "Models"),
  ]
)
