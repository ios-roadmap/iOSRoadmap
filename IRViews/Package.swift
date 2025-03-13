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
            targets: ["IRViews"]
        ),
    ],
    dependencies: [
        .package(path: "../IRCommon"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0")
    ],
    targets: [
        .target(
            name: "IRViews",
            dependencies: [
                "IRCommon",
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "IRViews"
        ),
    ]
)
