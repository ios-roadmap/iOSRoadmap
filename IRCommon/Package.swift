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
        .package(
            name: "IRNetworking",
            path: "../IRNetworking"
        ),
        .package(
            name: "IRCore",
            path: "../IRCore"
        ),
    ],
    targets: [
        .target(
            name: "IRCommon",
            dependencies: [
                "IRNetworking",
                "IRCore",
            ],
            path: "IRCommon"
        ),
    ]
)
