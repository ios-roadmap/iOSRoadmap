// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboardInterface",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRDashboardInterface",
            targets: ["IRDashboardInterface"]),
    ],
    dependencies: [
        .package(name: "IRCore", path: "../../IRCore")
    ],
    targets: [
        .target(
            name: "IRDashboardInterface",
            dependencies: [
                "IRCore"
            ]
        ),
    ]
)
