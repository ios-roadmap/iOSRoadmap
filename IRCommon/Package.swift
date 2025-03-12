// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRCommon",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "IRCommon",
            targets: ["IRCommon"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "IRCommon",
            dependencies: [
                
            ],
            path: "IRCommon"
        ),
    ]
)
