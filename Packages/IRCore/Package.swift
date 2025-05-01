// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "IRCore", targets: ["IRCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/ios-roadmap/IRFoundation.git", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "IRCore",
            dependencies: [
                .product(name: "IRFoundation", package: "IRFoundation")
            ],
            path: "IRCore"
        )
    ]
)
