// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRStyleKit",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRStyleKit",
            targets: ["IRStyleKit"]),
    ],
    dependencies: [
        .package(name: "IRBase", path: "../IRBase"),
        .package(name: "IRCore", path: "../IRCore"),
    ],
    targets: [
        .target(
            name: "IRStyleKit",
            dependencies: [
                "IRBase",
                "IRCore",
            ],
            path: "IRStyleKit"
        ),
    ]
)
