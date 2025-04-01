// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRBase",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRBase",
            targets: ["IRBase"]
        ),
    ],
    dependencies: [
//        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1")
    ],
    targets: [
        .target(
            name: "IRBase",
            dependencies: [
//                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "IRBase"
        ),
    ]
)
