// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRLibraries",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRLibraries",
            targets: ["IRLibraries"]),
    ],
    dependencies: [
        .package(
            name: "IRCommon",
            path: "../../IRCommon"
        ),
        .package(
            name: "IRDashboard",
            path: "../../IRDashboard"
        )
    ],
    targets: [
        .target(
            name: "IRLibraries",
            dependencies: [
                "IRCommon",
                "IRDashboard",
            ]
        ),
    ]
)
