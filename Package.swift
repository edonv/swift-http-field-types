// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-http-field-types",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HTTPFieldTypes",
            targets: ["HTTPFieldTypes"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HTTPFieldTypes",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
            ],
            resources: [.copy("../PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "HTTPFieldTypesTests",
            dependencies: [
                "HTTPFieldTypes",
                .product(name: "HTTPTypes", package: "swift-http-types"),
            ]
        ),
    ]
)
