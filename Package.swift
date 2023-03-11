// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ContributorUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ContributorUI",
            targets: ["ContributorUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ContributorUI",
            dependencies: []
        ),
        .testTarget(
            name: "ContributorUITests",
            dependencies: ["ContributorUI"],
            resources: [
                .process("Resources"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
