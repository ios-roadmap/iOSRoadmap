// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRJPHLibrary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRJPHLibrary",
            targets: ["IRJPHLibrary"]),
    ],
    dependencies: [
        .package(name: "IRJPHInterface", path: "../IRJPHInterface"),
        .package(name: "IRViews", path: "../../../IRViews")
    ],
    targets: [
        .target(
            name: "IRJPHLibrary",
            dependencies: [
                "IRJPHInterface",
                "IRViews"
            ]
        ),
    ]
)
