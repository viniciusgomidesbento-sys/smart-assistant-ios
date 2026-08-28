// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartAssistantCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .visionOS(.v2),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "SmartAssistantCore",
            targets: ["SmartAssistantCore"]
        ),
    ],
    targets: [
        .target(
            name: "SmartAssistantCore",
            dependencies: [],
            path: "Sources/SmartAssistantCore"
        ),
        .testTarget(
            name: "SmartAssistantCoreTests",
            dependencies: ["SmartAssistantCore"],
            path: "Tests/SmartAssistantCoreTests"
        ),
    ]
)
