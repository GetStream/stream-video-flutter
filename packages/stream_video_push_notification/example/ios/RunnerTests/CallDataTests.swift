import XCTest

@testable import stream_video_push_notification

/// Pins how `CallData` is built from the method-channel map: the `ios` sub-map form Dart sends,
/// the flat form the native API accepts, and the defaults.
final class CallDataTests: XCTestCase {

    private let base: [String: Any] = [
        "id": "call-uuid",
        "callerName": "Ada",
        "handle": "ada",
        "type": 1,
        "duration": 15000,
        "isAccepted": true,
        "extra": ["callCid": "default:ada"],
    ]

    func testReadsTheCallFields() {
        let data = CallData(args: base)

        XCTAssertEqual(data.uuid, "call-uuid")
        XCTAssertEqual(data.callerName, "Ada")
        XCTAssertEqual(data.handle, "ada")
        XCTAssertEqual(data.type, 1)
        XCTAssertEqual(data.duration, 15000)
        XCTAssertTrue(data.isAccepted)
        XCTAssertEqual(data.extra["callCid"] as? String, "default:ada")
    }

    func testTheNativeInitializerTakesTheSameDefaultsAsAnEmptyMap() {
        let data = CallData(id: "call-uuid", callerName: "Ada", handle: "ada", type: 1)

        XCTAssertEqual(data.uuid, "call-uuid")
        XCTAssertEqual(data.callerName, "Ada")
        XCTAssertEqual(data.handle, "ada")
        XCTAssertEqual(data.type, 1)
        XCTAssertEqual(data.duration, 30000)
        XCTAssertEqual(data.iconName, "AppLogo")
        XCTAssertEqual(data.maximumCallGroups, 1)
        XCTAssertFalse(data.supportsDTMF)
        XCTAssertFalse(data.supportsHolding)
    }

    func testDefaultsWhenTheMapIsEmpty() {
        let data = CallData(args: [String: Any]())

        XCTAssertEqual(data.uuid, "")
        XCTAssertEqual(data.type, 0)
        XCTAssertEqual(data.duration, 30000)
        XCTAssertFalse(data.isAccepted)
        XCTAssertEqual(data.iconName, "AppLogo")
        XCTAssertEqual(data.handleType, "")
        XCTAssertFalse(data.useComplexHandle)
        XCTAssertTrue(data.supportsVideo)
        XCTAssertEqual(data.maximumCallGroups, 1)
        XCTAssertFalse(data.supportsDTMF)
        XCTAssertFalse(data.supportsHolding)
        XCTAssertTrue(data.includesCallsInRecents)
        XCTAssertEqual(data.ringtonePath, "")
        XCTAssertTrue(data.configureAudioSession)
        XCTAssertEqual(data.audioSessionMode, "")
        XCTAssertEqual(data.audioSessionPreferredSampleRate, 44100.0)
        XCTAssertEqual(data.audioSessionPreferredIOBufferDuration, 0.005)
    }

    func testReadsTheIOSOptionsFromTheIOSSubMap() {
        var args = base
        args["ios"] = [
            "iconName": "CallIcon",
            "handleType": "email",
            "supportsVideo": false,
            "maximumCallGroups": 2,
            "supportsHolding": true,
            "includesCallsInRecents": false,
            "ringtonePath": "ring.caf",
            "configureAudioSession": false,
            "audioSessionMode": "voiceChat",
            "audioSessionPreferredSampleRate": 48000.0,
        ]

        let data = CallData(args: args)

        XCTAssertEqual(data.iconName, "CallIcon")
        XCTAssertEqual(data.handleType, "email")
        XCTAssertFalse(data.supportsVideo)
        XCTAssertEqual(data.maximumCallGroups, 2)
        XCTAssertTrue(data.supportsHolding)
        XCTAssertFalse(data.includesCallsInRecents)
        XCTAssertEqual(data.ringtonePath, "ring.caf")
        XCTAssertFalse(data.configureAudioSession)
        XCTAssertEqual(data.audioSessionMode, "voiceChat")
        XCTAssertEqual(data.audioSessionPreferredSampleRate, 48000.0)
        // Not in the sub-map: the defaults, not the top level.
        XCTAssertFalse(data.supportsDTMF)
    }

    func testReadsTheIOSOptionsFromTheTopLevelWithoutASubMap() {
        var args = base
        args["iconName"] = "FlatIcon"
        args["supportsHolding"] = true
        args["audioSessionMode"] = "videoChat"

        let data = CallData(args: args)

        XCTAssertEqual(data.iconName, "FlatIcon")
        XCTAssertTrue(data.supportsHolding)
        XCTAssertEqual(data.audioSessionMode, "videoChat")
    }

    func testTheIOSSubMapWinsOverTopLevelKeys() {
        var args = base
        args["iconName"] = "FlatIcon"
        args["supportsHolding"] = false
        args["ios"] = ["supportsHolding": true]

        let data = CallData(args: args)

        // With a sub-map present the top level is not read at all.
        XCTAssertEqual(data.iconName, "AppLogo")
        XCTAssertTrue(data.supportsHolding)
    }

    func testToJSONCarriesTheIdTwiceAndTheIOSSection() {
        let data = CallData(args: base)

        let json = data.toJSON()

        XCTAssertEqual(json["id"] as? String, "call-uuid")
        XCTAssertEqual(json["uuid"] as? String, "call-uuid")
        XCTAssertEqual(json["callerName"] as? String, "Ada")
        XCTAssertEqual(json["type"] as? Int, 1)
        XCTAssertEqual(json["isAccepted"] as? Bool, true)
        let ios = json["ios"] as? [String: Any]
        XCTAssertEqual(ios?["iconName"] as? String, "AppLogo")
        XCTAssertEqual(ios?["supportsHolding"] as? Bool, false)
        XCTAssertNil(ios?["supportsGrouping"])
    }

    func testToJSONRoundTripsThroughInit() {
        var args = base
        args["ios"] = [
            "iconName": "CallIcon", "supportsHolding": true, "supportsDTMF": true,
            "maximumCallGroups": 2, "ringtonePath": "ring.caf",
        ]
        let original = CallData(args: args)

        let restored = CallData(args: original.toJSON())

        XCTAssertEqual(restored.uuid, original.uuid)
        XCTAssertEqual(restored.callerName, original.callerName)
        XCTAssertEqual(restored.iconName, "CallIcon")
        XCTAssertTrue(restored.supportsHolding)
        XCTAssertTrue(restored.supportsDTMF)
        XCTAssertEqual(restored.maximumCallGroups, 2)
        XCTAssertEqual(restored.ringtonePath, "ring.caf")
        XCTAssertEqual(restored.extra["callCid"] as? String, "default:ada")
    }

    /// The body iOS sends with every call event must match the fixture the Dart tests decode, so
    /// a renamed or dropped key fails here as well as there.
    func testToJSONMatchesTheSharedDartFixture() throws {
        let fixtureURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("../../../test/fixtures/ringing_events/ios_call_event.json")
        let fixture = try XCTUnwrap(
            JSONSerialization.jsonObject(with: Data(contentsOf: fixtureURL)) as? NSDictionary)
        var args = base
        args["isAccepted"] = false
        args["ios"] = ["iconName": "CallIcon", "supportsHolding": true, "ringtonePath": "ring.caf"]

        let json = CallData(args: args).toJSON() as NSDictionary

        XCTAssertEqual(json, fixture)
    }

    func testTheHandleIsPassedThroughUnlessComplexHandlesAreOn() {
        let plain = CallData(args: base)
        XCTAssertEqual(plain.getEncryptHandle(), "ada")

        var args = base
        args["ios"] = ["useComplexHandle": true]
        let complex = CallData(args: args)
        XCTAssertNotEqual(complex.getEncryptHandle(), "ada")
        XCTAssertFalse(complex.getEncryptHandle().isEmpty)
    }
}
