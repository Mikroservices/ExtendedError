// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExtendedError",
    products: [
        .library(name: "ExtendedError", targets: ["ExtendedError"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "ExtendedError", dependencies: ["Vapor"]),
        .testTarget(name: "ExtendedErrorTests", dependencies: ["ExtendedError"]),
    ]
)
