// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "stream_video_filters",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(
            name: "stream-video-filters",
            targets: ["stream_video_filters"])
    ],
    dependencies: [
        // When built via Flutter's SPM integration, this package lives as a sibling under
        // ios/Flutter/ephemeral/Packages/.packages/
        .package(name: "stream_webrtc_flutter", path: "../stream_webrtc_flutter")
    ],
    targets: [
        .target(
            name: "stream_video_filters",
            dependencies: [
                .product(name: "stream-webrtc-flutter", package: "stream_webrtc_flutter")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=minimal"]),
            ]
        )
    ],
    swiftLanguageVersions: [.version("5.9")]
)
