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
        XCTAssertEqual(configuration.maximumCallGroups, 2)
        XCTAssertEqual(configuration.maximumCallsPerCallGroup, 1)
        XCTAssertTrue(configuration.supportsHolding)
        XCTAssertTrue(configuration.includesCallsInRecents)
        XCTAssertEqual(configuration.ringtonePath, "")
        XCTAssertTrue(configuration.configureAudioSession)
        XCTAssertEqual(configuration.headers.count, 0)
    }

    func testReadsTheIOSSubMapAndTheHeaders() {
        let configuration = StreamVideoPushConfiguration(args: [
            "headers": ["Authorization": "token"],
            "ios": ["iconName": "CallIcon", "supportsHolding": false, "ringtonePath": "ring.caf"],
        ])

        XCTAssertEqual(configuration.iconName, "CallIcon")
        XCTAssertFalse(configuration.supportsHolding)
        XCTAssertEqual(configuration.ringtonePath, "ring.caf")
        XCTAssertEqual(configuration.headers["Authorization"] as? String, "token")
    }

    func testReadsTopLevelKeysWithoutASubMap() {
        let configuration = StreamVideoPushConfiguration(args: ["iconName": "FlatIcon", "supportsDTMF": false])

        XCTAssertEqual(configuration.iconName, "FlatIcon")
        XCTAssertFalse(configuration.supportsDTMF)
    }

    func testLoadPersistedIsNilWhenNothingWasStored() {
        XCTAssertNil(StreamVideoPushConfiguration.loadPersisted())
    }

    func testPersistAndLoadRoundTripTheIOSOptionsAndDropTheHeaders() {
        StreamVideoPushConfiguration(args: [
            "headers": ["Authorization": "token"],
            "ios": ["iconName": "CallIcon", "supportsHolding": false, "includesCallsInRecents": false],
        ]).persist()

        let loaded = StreamVideoPushConfiguration.loadPersisted()

        XCTAssertEqual(loaded?.iconName, "CallIcon")
        XCTAssertEqual(loaded?.supportsHolding, false)
        XCTAssertEqual(loaded?.includesCallsInRecents, false)
        // Headers are not persisted: nothing on iOS reads them and they may hold values
        // UserDefaults refuses.
        XCTAssertEqual(loaded?.headers.count, 0)
        XCTAssertNil((UserDefaults.standard.dictionary(forKey: persistedKey) ?? [:])["headers"])
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
