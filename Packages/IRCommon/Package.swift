// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRCommon",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRCommon",
            targets: ["IRCommon"]),
    ],
    dependencies: [
        .package(name: "IRAssets", path: "../IRAssets"),
        .package(name: "IRCore", path: "../IRCore"),
        .package(name: "IRStyleKit", path: "../IRStyleKit"),
        .package(name: "IRNetworking", path: "../IRNetworking"),
    ],
    targets: [
        .target(
            name: "IRCommon",
            dependencies: [
                "IRAssets",
                "IRCore",
                "IRStyleKit",
                "IRNetworking",
            ],
            path: "IRCommon"
        ),
    ]
)
