// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRJPHLibrary",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRJPHLibrary",
            targets: ["IRJPHLibrary"]),
    ],
    dependencies: [
        .package(name: "IRCommon", path: "../../../Packages/IRCommon"),
        .package(name: "IRJPHInterface", path: "../IRJPHInterface"),
    ],
    targets: [
        .target(
            name: "IRJPHLibrary",
            dependencies: [
                "IRCommon",
                "IRJPHInterface",
            ]
        ),
    ]
)
