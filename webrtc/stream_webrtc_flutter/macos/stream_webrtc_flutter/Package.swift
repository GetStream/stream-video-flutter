// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "stream_webrtc_flutter",
    platforms: [
        .macOS("11.0")
    ],
    products: [
        .library(name: "stream-webrtc-flutter", targets: ["stream_webrtc_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/GetStream/stream-video-swift-webrtc.git", exact: "145.17.0"
        )
    ],
    targets: [
        .target(
            name: "stream_webrtc_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "StreamWebRTC", package: "stream-video-swift-webrtc")
            ],
            resources: [],
            linkerSettings: [
                .unsafeFlags(["-weak_framework", "ScreenCaptureKit"], .when(platforms: [.macOS]))
            ]
        )
    ]
)
