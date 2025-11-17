// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "stream_video_noise_cancellation",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(
            name: "stream-video-noise-cancellation",
            targets: ["stream_video_noise_cancellation"])
    ],
    dependencies: [
        // When built via Flutter's SPM integration, this package lives as a sibling under
        // ios/Flutter/ephemeral/Packages/.packages/
        .package(name: "stream_webrtc_flutter", path: "../stream_webrtc_flutter"),
        .package(
            url: "https://github.com/GetStream/stream-video-noise-cancellation-swift.git",
            exact: "1.0.3"
        ),
    ],
    targets: [
        .target(
            name: "stream_video_noise_cancellation",
            dependencies: [
                .product(name: "stream-webrtc-flutter", package: "stream_webrtc_flutter"),
                .product(
                    name: "StreamVideoNoiseCancellation",
                    package: "stream-video-noise-cancellation-swift"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
