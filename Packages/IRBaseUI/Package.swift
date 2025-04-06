// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRBaseUI",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRBaseUI",
            targets: ["IRBaseUI"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "IRBaseUI",
            dependencies: [
                
            ],
            path: "IRBaseUI"
        ),
    ]
)
