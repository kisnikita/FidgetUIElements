// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FidgetUIElements",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FidgetUIElements",
            targets: ["FidgetUIElements"]),
    ],
    targets: [
        .target(
            name: "FidgetUIElements",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "FidgetUIElementsTests",
            dependencies: ["FidgetUIElements"]),
    ]
)
