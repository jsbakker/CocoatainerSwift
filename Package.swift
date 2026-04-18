// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CocoatainerSwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CocoatainerSwift",
            targets: ["CocoatainerSwift"]),
    ],
    targets: [
        .target(
            name: "CocoatainerSwift",
            dependencies: [],
            path: "CocoatainerSwift/CocoatainerSwift"),
        .testTarget(
            name: "CocoatainerSwiftTests",
            dependencies: ["CocoatainerSwift"],
            path: "CocoatainerSwift/CocoatainerSwiftTests"),
    ]
)
