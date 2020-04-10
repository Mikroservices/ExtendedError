// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "ExtendedError",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "ExtendedError", targets: ["ExtendedError"])
    ],
    dependencies: [
        // 💧 A server-side Swift web framework. 
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.0.1")),
    ],
    targets: [
        .target(name: "ExtendedError", dependencies: [
            .product(name: "Vapor", package: "vapor")
        ]),
        .testTarget(name: "ExtendedErrorTests", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .target(name: "ExtendedError")
        ])
    ]
)
