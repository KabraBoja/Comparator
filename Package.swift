// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Comparator",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Comparator", targets: ["Comparator"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Comparator",
            path: "src"
        ),
        .testTarget(
            name: "ComparatorTests",
            dependencies: [
                "Comparator",
            ],
            path: "tests"
        )
    ]
)
