// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRJPH",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRJPH",
            targets: ["IRJPH"]),
    ],
    dependencies: [
        .package(
            name: "IRJPHInterface",
            path: "IRJPHInterface"
        )
    ],
    targets: [
        .target(
            name: "IRJPH",
            dependencies: [
                "IRJPHInterface"
            ],
            path: "IRJPH"
        ),
    ]
)
