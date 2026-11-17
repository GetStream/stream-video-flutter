import XCTest

@testable import stream_video_push_notification

/// Pins how the CallKit configuration sent with `initData` is parsed and how it is persisted for
/// the cold-start VoIP path, where a push arrives before any Dart code has run.
final class StreamVideoPushConfigurationTests: XCTestCase {

    private let persistedKey = "io.getstream.callKit_configuration"

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: persistedKey)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: persistedKey)
        super.tearDown()
    }

    func testDefaults() {
        let configuration = StreamVideoPushConfiguration(args: [String: Any]())

        XCTAssertEqual(configuration.iconName, "CallKitLogo")
        XCTAssertTrue(configuration.supportsVideo)
        XCTAssertEqual(configuration.maximumCallGroups, 1)
        XCTAssertFalse(configuration.supportsHolding)
        XCTAssertFalse(configuration.supportsDTMF)
        XCTAssertTrue(configuration.includesCallsInRecents)
        XCTAssertEqual(configuration.ringtonePath, "")
        XCTAssertTrue(configuration.configureAudioSession)
        XCTAssertEqual(configuration.headers.count, 0)
    }

    func testReadsTheIOSSubMapAndTheHeaders() {
        let configuration = StreamVideoPushConfiguration(args: [
            "headers": ["Authorization": "token"],
            "ios": [
                "iconName": "CallIcon", "supportsHolding": true, "supportsDTMF": true,
                "maximumCallGroups": 2, "ringtonePath": "ring.caf",
            ],
        ])

        XCTAssertEqual(configuration.iconName, "CallIcon")
        XCTAssertTrue(configuration.supportsHolding)
        XCTAssertTrue(configuration.supportsDTMF)
        XCTAssertEqual(configuration.maximumCallGroups, 2)
        XCTAssertEqual(configuration.ringtonePath, "ring.caf")
        XCTAssertEqual(configuration.headers["Authorization"] as? String, "token")
    }

    func testReadsTopLevelKeysWithoutASubMap() {
        let configuration = StreamVideoPushConfiguration(args: ["iconName": "FlatIcon", "supportsDTMF": true])

        XCTAssertEqual(configuration.iconName, "FlatIcon")
        XCTAssertTrue(configuration.supportsDTMF)
    }

    func testLoadPersistedIsNilWhenNothingWasStored() {
        XCTAssertNil(StreamVideoPushConfiguration.loadPersisted())
    }

    func testPersistAndLoadRoundTripTheIOSOptionsAndDropTheHeaders() {
        StreamVideoPushConfiguration(args: [
            "headers": ["Authorization": "token"],
            "ios": [
                "iconName": "CallIcon", "supportsHolding": true, "supportsDTMF": true,
                "maximumCallGroups": 2, "includesCallsInRecents": false,
            ],
        ]).persist()

        let loaded = StreamVideoPushConfiguration.loadPersisted()

        XCTAssertEqual(loaded?.iconName, "CallIcon")
        XCTAssertEqual(loaded?.supportsHolding, true)
        XCTAssertEqual(loaded?.supportsDTMF, true)
        XCTAssertEqual(loaded?.maximumCallGroups, 2)
        XCTAssertEqual(loaded?.includesCallsInRecents, false)
        // Headers are not persisted: nothing on iOS reads them and they may hold values
        // UserDefaults refuses.
        XCTAssertEqual(loaded?.headers.count, 0)
        XCTAssertNil((UserDefaults.standard.dictionary(forKey: persistedKey) ?? [:])["headers"])
    }

    func testCallKitOptionsOtherThanTheDefaultsReachACallAVoIPPushReports() throws {
        // A VoIP push that wakes a killed app builds its call from the persisted configuration.
        StreamVideoPushConfiguration(args: [
            "ios": ["supportsHolding": true, "supportsDTMF": true, "maximumCallGroups": 2]
        ]).persist()
        let loaded = try XCTUnwrap(StreamVideoPushConfiguration.loadPersisted())

        let data = VoIPPushRegistryHandler.callData(
            fromVoIPPayload: ["call_cid": "default:call"], configuration: loaded,
            persistedIconName: nil, uuid: "call-uuid")

        XCTAssertTrue(data.supportsHolding)
        XCTAssertTrue(data.supportsDTMF)
        XCTAssertEqual(data.maximumCallGroups, 2)
    }

    func testAConfigurationStoredWithAKeyNoLongerReadStillLoads() {
        // Stored by an earlier version, which also wrote `audioSessionActive`.
        UserDefaults.standard.set(
            ["ios": ["iconName": "CallIcon", "audioSessionActive": false]],
            forKey: persistedKey)

        let loaded = StreamVideoPushConfiguration.loadPersisted()

        XCTAssertEqual(loaded?.iconName, "CallIcon")
        let ios = loaded?.toJSON()["ios"] as? [String: Any]
        XCTAssertNotNil(ios)
        XCTAssertNil(ios?["audioSessionActive"])
    }

    func testPersistSurvivesANullHeaderValue() {
        // A Dart `null` in the headers arrives as NSNull, which UserDefaults cannot store.
        let configuration = StreamVideoPushConfiguration(args: [
            "headers": ["X-Empty": NSNull()],
            "ios": ["iconName": "CallIcon"],
        ])

        configuration.persist()

        XCTAssertEqual(StreamVideoPushConfiguration.loadPersisted()?.iconName, "CallIcon")
    }

    func testToJSONNestsTheIOSOptions() {
        let json = StreamVideoPushConfiguration(args: ["ios": ["iconName": "CallIcon"]]).toJSON()

        let ios = json["ios"] as? [String: Any]
        XCTAssertEqual(ios?["iconName"] as? String, "CallIcon")
        XCTAssertNotNil(json["headers"])
        // CallData reads the same shape, which is how the VoIP path builds its call.
        XCTAssertEqual(CallData(args: json).iconName, "CallIcon")
    }
}
