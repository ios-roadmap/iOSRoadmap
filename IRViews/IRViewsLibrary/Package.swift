// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRViewsLibrary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IRViewsLibrary",
            targets: ["IRViewsLibrary"]),
    ],
    dependencies: [
        .package(
            name: "IRCommon",
            path: "../../IRCommon"
        )
    ],
    targets: [
        .target(
            name: "IRViewsLibrary",
            dependencies: [
                "IRCommon"
            ]
        ),
    ]
)
