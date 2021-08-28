// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FittingGeometry",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "FittingGeometry",
            targets: ["FittingGeometry"]
        ),
    ],
    targets: [
        .target(name: "FittingGeometry")
    ]
)
