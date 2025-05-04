// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRFoundation",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRFoundation",
            targets: ["IRFoundation"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "IRFoundation",
            dependencies: [
                
            ],
            path: "IRFoundation"
        ),
    ]
)
