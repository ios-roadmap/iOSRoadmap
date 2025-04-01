// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRAssets",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRAssets",
            targets: ["IRAssets"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "IRAssets",
            dependencies: [
                
            ],
            path: "IRAssets",
            resources: [
                .process("Resources/IRMedia.xcassets")
            ]
        ),
    ]
)
