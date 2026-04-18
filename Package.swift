// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "CocoatainerSwift",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
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
