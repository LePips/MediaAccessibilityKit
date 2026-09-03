// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "MediaAccessibilityKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
    ],
    products: [
        .library(
            name: "MediaAccessibilityKit",
            targets: ["MediaAccessibilityKit"]
        )
    ],
    targets: [
        .target(
            name: "MediaAccessibilityKit"
        ),
    ],
    swiftLanguageModes: [.v6]
)
