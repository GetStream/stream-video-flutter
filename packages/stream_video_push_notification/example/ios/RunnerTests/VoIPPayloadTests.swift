import XCTest

@testable import stream_video_push_notification

/// Pins how the `stream` section of a VoIP push becomes the call reported to CallKit.
final class VoIPPayloadTests: XCTestCase {

    private let payload: [String: Any] = [
        "call_cid": "default:ada",
        "call_display_name": "Team call",
        "created_by_display_name": "Ada",
        "created_by_id": "ada",
        "video": "true",
    ]

    private func callData(
        _ payload: [String: Any]?,
        configuration: StreamVideoPushConfiguration? = nil,
        persistedIconName: String? = nil
    ) -> CallData {
        VoIPPushRegistryHandler.callData(
            fromVoIPPayload: payload,
            configuration: configuration,
            persistedIconName: persistedIconName,
            uuid: "fixed-uuid")
    }

    func testTheCallDisplayNameWinsOverTheCreatorName() {
        let data = callData(payload)

        XCTAssertEqual(data.callerName, "Team call")
        XCTAssertEqual(data.handle, "ada")
        XCTAssertEqual(data.uuid, "fixed-uuid")
        XCTAssertEqual(data.extra["callCid"] as? String, "default:ada")
    }

    func testAnEmptyCallDisplayNameFallsBackToTheCreatorName() {
        var payload = self.payload
        payload["call_display_name"] = ""

        XCTAssertEqual(callData(payload).callerName, "Ada")
    }

    func testNoNamesAtAllFallBackToUnknownCaller() {
        var payload = self.payload
        payload["call_display_name"] = ""
        payload.removeValue(forKey: "created_by_display_name")
        payload.removeValue(forKey: "created_by_id")

        let data = callData(payload)

        XCTAssertEqual(data.callerName, "Unknown Caller")
        XCTAssertEqual(data.handle, "Unknown Caller")
    }

    func testVideoIsOnUnlessThePayloadSaysFalse() {
        XCTAssertEqual(callData(payload).type, 1)

        var audioOnly = payload
        audioOnly["video"] = "false"
        XCTAssertEqual(callData(audioOnly).type, 0)

        var unspecified = payload
        unspecified.removeValue(forKey: "video")
        XCTAssertEqual(callData(unspecified).type, 1)
    }

    func testANilPayloadStillProducesACall() {
        let data = callData(nil)

        XCTAssertEqual(data.callerName, "Unknown Caller")
        XCTAssertEqual(data.extra["callCid"] as? String, "")
        XCTAssertEqual(data.type, 1)
    }

    func testTheConfigurationSuppliesTheCallKitOptions() {
        let configuration = StreamVideoPushConfiguration(args: [
            "ios": ["iconName": "CallIcon", "supportsHolding": false, "ringtonePath": "ring.caf"],
        ])

        let data = callData(payload, configuration: configuration)

        XCTAssertEqual(data.iconName, "CallIcon")
        XCTAssertFalse(data.supportsHolding)
        XCTAssertEqual(data.ringtonePath, "ring.caf")
    }

    func testWithoutAConfigurationTheCallDataDefaultsApply() {
        let data = callData(payload)

        XCTAssertEqual(data.iconName, "AppLogo")
        XCTAssertTrue(data.supportsHolding)
    }

    func testThePersistedIconNameWinsOverTheConfiguration() {
        let configuration = StreamVideoPushConfiguration(args: ["ios": ["iconName": "CallIcon"]])

        XCTAssertEqual(
            callData(payload, configuration: configuration, persistedIconName: "SavedIcon").iconName,
            "SavedIcon")
        XCTAssertEqual(callData(payload, persistedIconName: "SavedIcon").iconName, "SavedIcon")
    }
}
