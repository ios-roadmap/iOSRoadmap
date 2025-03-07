// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRViews",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRViews",
            targets: ["IRViews"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "IRViews",
            dependencies: [
                
            ],
            path: "IRViews"
        ),
    ]
)
