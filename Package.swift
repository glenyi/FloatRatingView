// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FloatRatingView",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11), .tvOS(.v11),
    ],
    products: [
        .library(
            name: "FloatRatingView",
            targets: ["FloatRatingView"])
    ],
    targets: [
        .target(
            name: "FloatRatingView",
            path: ".",
            sources: ["FloatRatingView.swift"]
        )
    ]
)
