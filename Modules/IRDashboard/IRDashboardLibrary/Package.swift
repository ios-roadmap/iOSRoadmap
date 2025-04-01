// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboardLibrary",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRDashboardLibrary",
            targets: [
                "IRDashboardLibrary"
            ]
        )
    ],
    dependencies: [
        .package(name: "IRCommon", path: "../../../Packages/IRCommon"),
        .package(name: "IRStyleKit", path: "../../../Packages/IRStyleKit"),
        .package(name: "IRDashboardInterface",path: "../IRDashboardInterface"),
        .package(name: "IRJPHInterface", path: "../../../Apps/IRJPH/IRJPHInterface"),
    ],
    targets: [
        .target(
            name: "IRDashboardLibrary",
            dependencies: [
                "IRCommon",
                "IRStyleKit",
                "IRDashboardInterface",
                "IRJPHInterface",
            ]
        )
    ]
)

