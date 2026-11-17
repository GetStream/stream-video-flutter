import XCTest

@testable import stream_video_push_notification

/// Pins the one parser `CallData` and `StreamVideoPushConfiguration` share for their CallKit and
/// audio session options.
final class CallKitOptionsTests: XCTestCase {

    private let ios: [String: Any] = [
        "iconName": "CallIcon",
        "handleType": "number",
        "useComplexHandle": true,
        "supportsVideo": false,
        "maximumCallGroups": 3,
        "supportsDTMF": true,
        "supportsHolding": true,
        "includesCallsInRecents": false,
        "ringtonePath": "ring.caf",
        "configureAudioSession": false,
        "audioSessionMode": "voiceChat",
        "audioSessionPreferredSampleRate": 48000.0,
        "audioSessionPreferredIOBufferDuration": 0.01,
    ]

    private func assertMatchesIOS(_ options: CallKitOptions, line: UInt = #line) {
        XCTAssertEqual(options.iconName, "CallIcon", line: line)
        XCTAssertEqual(options.handleType, "number", line: line)
        XCTAssertTrue(options.useComplexHandle, line: line)
        XCTAssertFalse(options.supportsVideo, line: line)
        XCTAssertEqual(options.maximumCallGroups, 3, line: line)
        XCTAssertTrue(options.supportsDTMF, line: line)
        XCTAssertTrue(options.supportsHolding, line: line)
        XCTAssertFalse(options.includesCallsInRecents, line: line)
        XCTAssertEqual(options.ringtonePath, "ring.caf", line: line)
        XCTAssertFalse(options.configureAudioSession, line: line)
        XCTAssertEqual(options.audioSessionMode, "voiceChat", line: line)
        XCTAssertEqual(options.audioSessionPreferredSampleRate, 48000.0, line: line)
        XCTAssertEqual(options.audioSessionPreferredIOBufferDuration, 0.01, line: line)
    }

    func testReadsEveryOptionFromTheIOSSubMap() {
        let args: [String: Any?] = ["ios": ios]
        assertMatchesIOS(CallKitOptions(args: args, defaultIconName: "AppLogo"))
    }

    func testReadsEveryOptionFromTheTopLevelWithoutASubMap() {
        let args: [String: Any?] = ios
        assertMatchesIOS(CallKitOptions(args: args, defaultIconName: "AppLogo"))
    }

    func testTheSubMapWinsAndTopLevelKeysAreIgnoredWhenItIsThere() {
        var args: [String: Any?] = ["ios": ["iconName": "FromSubMap"]]
        args["ringtonePath"] = "top-level.caf"

        let options = CallKitOptions(args: args, defaultIconName: "AppLogo")

        XCTAssertEqual(options.iconName, "FromSubMap")
        XCTAssertEqual(options.ringtonePath, "")
    }

    func testDefaultsTakeTheCallersIconName() {
        let options = CallKitOptions(args: [:], defaultIconName: "CallKitLogo")

        XCTAssertEqual(options.iconName, "CallKitLogo")
    }

    /// The defaults of Dart's `IOSPushConfiguration`, which a call reported before Dart sent its
    /// configuration, or from native code with only some keys, must not exceed.
    func testDefaultsOfferNoHoldNoKeypadAndOneCallGroupAsDartDoes() {
        let options = CallKitOptions(args: [:], defaultIconName: "AppLogo")

        XCTAssertEqual(options.maximumCallGroups, 1)
        XCTAssertFalse(options.supportsHolding)
        XCTAssertFalse(options.supportsDTMF)
        XCTAssertTrue(options.supportsVideo)
        XCTAssertTrue(options.includesCallsInRecents)
    }

    func testCallDataAndTheConfigurationReadTheSameOptions() {
        let args: [String: Any?] = ["ios": ios]
        let data = CallData(args: args)
        let configuration = StreamVideoPushConfiguration(args: args)

        XCTAssertEqual(
            NSDictionary(dictionary: data.toJSON()["ios"] as! [String: Any]),
            NSDictionary(dictionary: configuration.toJSON()["ios"] as! [String: Any]))
    }

    func testOnlyTheDefaultIconDiffersBetweenTheTwo() {
        let empty: [String: Any?] = [:]
        XCTAssertEqual(CallData(args: empty).iconName, "AppLogo")
        XCTAssertEqual(StreamVideoPushConfiguration(args: empty).iconName, "CallKitLogo")
    }
}
