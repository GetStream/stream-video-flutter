// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "stream_video_flutter",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "stream-video-flutter", type: .static, targets: ["stream_video_flutter"])
    ],
    dependencies: [
        // When built via Flutter's SPM integration, these packages live as siblings under
        // ios/Flutter/ephemeral/Packages/.packages/
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(name: "stream_webrtc_flutter", path: "../stream_webrtc_flutter")
    ],
    targets: [
        .target(
            name: "stream_video_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "stream-webrtc-flutter", package: "stream_webrtc_flutter")
            ],
            resources: [
                // If you have PrivacyInfo.xcprivacy or other resources:
                // .process("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=minimal"]),
            ]
        )
    ],
    swiftLanguageVersions: [.version("5.9")]
)
