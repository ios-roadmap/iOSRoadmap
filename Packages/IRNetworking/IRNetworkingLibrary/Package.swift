// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRNetworkingLibrary",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "IRNetworkingLibrary",
            targets: ["IRNetworkingLibrary"]
        ),
    ],
    dependencies: [
        .package(name: "IRCore", path: "../../IRCore"),
    ],
    targets: [
        .target(
            name: "IRNetworkingLibrary",
            dependencies: [
                "IRCore",
            ]
        ),
    ]
)
