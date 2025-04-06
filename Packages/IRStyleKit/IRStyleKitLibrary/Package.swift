// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRStyleKitLibrary",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRStyleKitLibrary",
            targets: ["IRStyleKitLibrary"]),
    ],
    dependencies: [
        .package(name: "IRBaseUI", path: "../../IRBaseUI"),
        .package(name: "IRCore", path: "../../IRCore"),
    ],
    targets: [
        .target(
            name: "IRStyleKitLibrary",
            dependencies: [
                "IRBaseUI",
                "IRCore",
            ]
        ),

    ]
)
