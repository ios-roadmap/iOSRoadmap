// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboardLibrary",
    defaultLocalization: "en",
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
        .package(name: "IRDashboardInterface", path: "../IRDashboardInterface"),
        .package(name: "IRJPHInterface", path: "../../../Apps/IRJPH/IRJPHInterface"),
        
        //TODO: MUST DELETE
        .package(name: "IRJPH", path: "../../../Apps/IRJPH"),
    ],
    targets: [
        .target(
            name: "IRDashboardLibrary",
            dependencies: [
                "IRCommon",
                "IRDashboardInterface",
                "IRJPHInterface",
                "IRJPH",
            ]
        )
    ]
)

