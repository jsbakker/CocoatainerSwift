// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "CocoatainerSwift",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
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
