// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRLibraries",
    defaultLocalization: "en",
    products: [
        .library(
            name: "IRLibraries",
            targets: ["IRLibraries"]),
    ],
    dependencies: [
        .package(
            name: "IRDashboardInterface",
            path: "../IRDashboardInterface"
        )
    ],
    targets: [
        .target(
            name: "IRLibraries",
            dependencies: [
                "IRDashboardInterface"
            ],
            path: "IRDashboard"
        ),
    ]
)
