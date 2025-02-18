// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IRDashboardLibrary",
    defaultLocalization: "en",
    products: [
        .library(
            name: "IRDashboardLibrary",
            targets: [
                "IRDashboardLibrary"
            ]
        )
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "IRDashboardLibrary",
            dependencies: [
                
            ]
        )
    ]
)
