// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRNetworking",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRNetworking",
            targets: ["IRNetworking"]),
    ],
    dependencies: [
        .package(name: "IRCore", path: "../IRCore"),
    ],
    targets: [
        .target(
            name: "IRNetworking",
            dependencies: [
                "IRCore"
            ],
            path: "IRNetworking"
        ),
    ]
)
