// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "stream_video_push_notification",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(
            name: "stream-video-push-notification", targets: ["stream_video_push_notification"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.2"),
        .package(name: "stream_webrtc_flutter", path: "../stream_webrtc_flutter"),
    ],
    targets: [
        .target(
            name: "stream_video_push_notification",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "stream-webrtc-flutter", package: "stream_webrtc_flutter"),
            ],
            resources: [
                // If you have PrivacyInfo.xcprivacy or other resources:
                // .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
