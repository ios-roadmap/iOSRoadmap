// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSRoadmapLibrary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iOSRoadmapLibrary",
            targets: ["iOSRoadmapLibrary"]),
    ],
    dependencies: [
        .package(
            name: "IRDashboard",
            path: "../../IRDashboard"
        ),
        .package(
            name: "IRJPH",
            path: "../../IRApps/IRJPH"
        ),
        .package(
            name: "IRCore",
            path: "../../IRCore"
        )
    ],
    targets: [
        .target(
            name: "iOSRoadmapLibrary",
            dependencies: [
                "IRDashboard",
                "IRJPH",
                "IRCore"
            ]
        ),
    ]
)
