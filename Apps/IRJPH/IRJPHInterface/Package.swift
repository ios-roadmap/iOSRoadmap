// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRJPHInterface",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRJPHInterface",
            targets: ["IRJPHInterface"]),
    ],
    dependencies: [
        .package(name: "IRCore", path: "../IRCore")
    ],
    targets: [
        .target(
            name: "IRJPHInterface",
            dependencies: [
                "IRCore"
            ]
        ),
    ]
)
