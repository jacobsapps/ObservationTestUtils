// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObservationTestUtils",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ObservationTestUtils",
            targets: ["ObservationTestUtils"]),
    ],
    targets: [
        .target(
            name: "ObservationTestUtils"),
        .testTarget(
            name: "ObservationTestUtilsTests",
            dependencies: ["ObservationTestUtils"]),
    ]
)
