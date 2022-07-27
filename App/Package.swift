// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.macOS(.v12), .iOS("16.0")],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Stores", targets: ["Stores"]),
        .library(name: "Services", targets: ["Services"]),
        .library(name: "Utils", targets: ["Utils"]),
        .library(name: "EpisodesListComponent", targets: ["EpisodesListComponent"])
    ],
    dependencies: [
        .package(url: "https://github.com/mergesort/Boutique.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Boutique", package: "Boutique"),
                .target(name: "Models"),
                .target(name: "Services"),
                .target(name: "Stores"),
                .target(name: "EpisodesListComponent"),
                .target(name: "Utils"),
            ]),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "App"
            ]),
        .target(name: "Models"),
        .target(name: "Services", dependencies: ["Models"]),
        .target(name: "Stores", dependencies: ["Models", "Boutique"]),
        .target(name: "Utils"),
        .target(name: "EpisodesListComponent", dependencies: [
            "Models",
            "Stores",
            "Services",
            "Utils",
        ]),
    ]
)
