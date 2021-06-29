// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Persistence",
            targets: ["Persistence"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Persistence",
            dependencies: []),
        .testTarget(
            name: "PersistenceTests",
            dependencies: ["Persistence"]),
    ]
)
