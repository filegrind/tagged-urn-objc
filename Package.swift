// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "tagged-urn-objc",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "TaggedUrn",
            targets: ["CapNs"]),
    ],
    targets: [
        .target(
            name: "CapNs",
            dependencies: [],
            path: "Sources/CapNs",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedFramework("Foundation")
            ]
        ),
        .testTarget(
            name: "CapNsTests",
            dependencies: ["CapNs"]),
    ]
)
