// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboardLibrary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRDashboardLibrary",
            targets: [
                "IRDashboardLibrary"
            ]
        )
    ],
    dependencies: [
        .package(
            name: "IRDashboardInterface",
            path: "../IRDashboardInterface"
        ),
        .package(name: "IRJPH", path: "../../IRApps/IRJPH"),
        .package(name: "IRViews", path: "../../IRViews")
    ],
    targets: [
        .target(
            name: "IRDashboardLibrary",
            dependencies: [
                "IRDashboardInterface",
                "IRJPH",
                "IRViews"
            ]
        )
    ]
)
