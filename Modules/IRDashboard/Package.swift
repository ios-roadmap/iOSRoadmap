// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboard",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRDashboard",
            targets: ["IRDashboard"]),
    ],
    dependencies: [
        .package(name: "IRCommon", path: "../../Packages/IRCommon"),
        .package(name: "IRDashboardInterface", path: "IRDashboardInterface"),
        .package(name: "IRJPHInterface", path: "../../Apps/IRJPH/IRJPHInterface"),
    ],
    targets: [
        .target(
            name: "IRDashboard",
            dependencies: [
                "IRCommon",
                "IRDashboardInterface",
                "IRJPHInterface",
            ],
            path: "IRDashboard"
        ),
    ]
)
