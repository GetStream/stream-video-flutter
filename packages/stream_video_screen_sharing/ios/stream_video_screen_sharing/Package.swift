// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "stream_video_screen_sharing",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "stream-video-screen-sharing", targets: ["stream_video_screen_sharing"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "stream_video_screen_sharing",
            dependencies: [],
            resources: [
                // If you have PrivacyInfo.xcprivacy or other resources:
                // .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
