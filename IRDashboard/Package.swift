// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboard",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRDashboard",
            targets: ["IRDashboard"]),
    ],
    dependencies: [
        .package(name: "IRDashboardInterface", path: "IRDashboardInterface"),
        .package(name: "IRViews", path: "../IRViews"),
        .package(name: "IRJPHInterface", path: "../IRApps/IRJPH/IRJPHInterface")
    ],
    targets: [
        .target(
            name: "IRDashboard",
            dependencies: [
                "IRDashboardInterface",
                "IRViews",
                "IRJPHInterface"
            ],
            path: "IRDashboard"
        ),
    ]
)
