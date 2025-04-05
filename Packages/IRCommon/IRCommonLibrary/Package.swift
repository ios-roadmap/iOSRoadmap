// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRCommonLibrary",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRCommonLibrary",
            targets: ["IRCommonLibrary"]),
    ],
    dependencies: [
        .package(name: "IRAssets", path: "../IRAssets"),
        .package(name: "IRCore", path: "../IRCore"),
        .package(name: "IRStyleKit", path: "../IRStyleKit"),
        .package(name: "IRBaseUI", path: "../IRBaseUI"),
    ],
    targets: [
        .target(
            name: "IRCommonLibrary",
            dependencies: [
                "IRAssets",
                "IRCore",
                "IRStyleKit",
                "IRBaseUI",
            ]
        ),
    ]
)
