// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRCommon",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRCommon",
            targets: ["IRCommon"]),
    ],
    dependencies: [
        .package(name: "IRAssets", path: "../IRAssets")
    ],
    targets: [
        .target(
            name: "IRCommon",
            dependencies: [
                "IRAssets"
            ],
            path: "IRCommon"
        ),
    ]
)
