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
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", .upToNextMajor(from: "0.9.5")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.6.2"))
    ],
    targets: [
        .target(
            name: "ContributorUI",
            dependencies: ["Kingfisher"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ContributorUITests",
            dependencies: ["ContributorUI", "ViewInspector"],
            resources: [
                .process("Resources")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
