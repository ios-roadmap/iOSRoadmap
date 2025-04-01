// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboardDemoLibrary",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IRDashboardDemoLibrary",
            targets: ["IRDashboardDemoLibrary"]),
    ],
    dependencies: [
        .package(name: "IRJPH", path: "../../../../Apps/IRJPH")
    ],
    targets: [
        .target(
            name: "IRDashboardDemoLibrary",
            dependencies: [
                "IRJPH"
            ]
        ),

    ]
)
