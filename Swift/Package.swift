// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "QuentiSwift",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "QuentiSwift", targets: ["QuentiSwift"])
    ],
    dependencies: [
        // Optional dependency for an optimized Levenshtein implementation
        .package(url: "https://github.com/SwiftDocOrg/SwiftLevenshtein.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "QuentiSwift",
            dependencies: ["SwiftLevenshtein"],
            path: "."
        )
    ]
)
