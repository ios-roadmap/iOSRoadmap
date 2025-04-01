// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRCore",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRCore",
            targets: ["IRCore"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "IRCore",
            dependencies: [
                
            ],
            path: "IRCore"
        ),
    ]
)
