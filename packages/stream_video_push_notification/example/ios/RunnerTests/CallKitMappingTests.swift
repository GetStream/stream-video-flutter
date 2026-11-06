import AVFoundation
import CallKit
import XCTest

@testable import stream_video_push_notification

/// Pins the small mappings in the CallKit manager between the strings on the channel and the
/// CallKit and AVFoundation values: the handle type, the audio session mode, and the error codes
/// `ActionCallIncomingFailed` carries, which the Dart `IncomingCallFailureReason` parses by name.
final class CallKitMappingTests: XCTestCase {

    private let manager = StreamVideoCallkitManager.shared

    func testHandleTypes() {
        XCTAssertEqual(manager.getHandleType("number"), .phoneNumber)
        XCTAssertEqual(manager.getHandleType("email"), .emailAddress)
        XCTAssertEqual(manager.getHandleType("generic"), .generic)
        XCTAssertEqual(manager.getHandleType(""), .generic)
        XCTAssertEqual(manager.getHandleType(nil), .generic)
    }

    func testAudioSessionModes() {
        XCTAssertEqual(manager.getAudioSessionMode("gameChat"), .gameChat)
        XCTAssertEqual(manager.getAudioSessionMode("measurement"), .measurement)
        XCTAssertEqual(manager.getAudioSessionMode("moviePlayback"), .moviePlayback)
        XCTAssertEqual(manager.getAudioSessionMode("spokenAudio"), .spokenAudio)
        XCTAssertEqual(manager.getAudioSessionMode("videoChat"), .videoChat)
        XCTAssertEqual(manager.getAudioSessionMode("videoRecording"), .videoRecording)
        XCTAssertEqual(manager.getAudioSessionMode("voiceChat"), .voiceChat)
        XCTAssertEqual(manager.getAudioSessionMode("voicePrompt"), .voicePrompt)
        XCTAssertEqual(manager.getAudioSessionMode(""), .default)
        XCTAssertEqual(manager.getAudioSessionMode("somethingElse"), .default)
        XCTAssertEqual(manager.getAudioSessionMode(nil), .default)
    }

    func testIncomingCallErrorCodesMatchTheDartReasonNames() {
        func error(_ code: CXErrorCodeIncomingCallError.Code) -> Error {
            NSError(domain: CXErrorDomainIncomingCall, code: code.rawValue)
        }

        XCTAssertEqual(manager.incomingCallErrorCode(error(.unentitled)), "unentitled")
        XCTAssertEqual(manager.incomingCallErrorCode(error(.callUUIDAlreadyExists)), "callUuidAlreadyExists")
        XCTAssertEqual(manager.incomingCallErrorCode(error(.filteredByDoNotDisturb)), "filteredByDoNotDisturb")
        XCTAssertEqual(manager.incomingCallErrorCode(error(.filteredByBlockList)), "filteredByBlockList")
        XCTAssertEqual(manager.incomingCallErrorCode(error(.unknown)), "unknown")
        XCTAssertEqual(
            manager.incomingCallErrorCode(NSError(domain: "other", code: 12345)),
            "unknown")
    }
}
