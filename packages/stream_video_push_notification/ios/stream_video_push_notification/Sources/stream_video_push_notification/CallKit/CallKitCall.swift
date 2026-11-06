import CallKit
import Foundation

/// The two ids a call is known by.
struct CallKitCallIdentity {
    /// The id the call was shown or started with, which is the id Dart knows it by.
    let appId: String
    /// The uuid CallKit knows the call by.
    private(set) var callKitUUID: UUID
    /// The uuids CallKit knew the call by before, oldest first.
    private(set) var previousCallKitUUIDs: [UUID] = []

    init(appId: String, callKitUUID: UUID) {
        self.appId = appId
        self.callKitUUID = callKitUUID
    }

    /// Records that CallKit now knows the call by `uuid`.
    mutating func rebind(to uuid: UUID) {
        previousCallKitUUIDs.append(callKitUUID)
        callKitUUID = uuid
    }

    /// The id events report the call by: the app id when it names the CallKit uuid, otherwise
    /// the lowercased uuid.
    var reportedId: String {
        let lowercasedUUID = callKitUUID.uuidString.lowercased()
        return appId.lowercased() == lowercasedUUID ? appId : lowercasedUUID
    }
}

/// Where a call is in its CallKit lifecycle.
enum CallKitCallPhase: Equatable {
    /// Reported to CallKit as incoming and not answered.
    case ringing
    /// Outgoing, and CallKit performed its start action.
    case starting
    /// CallKit performed the answer action; no audio session was activated since.
    case answering
    /// An audio session was activated since the call was started or answered.
    case active
    /// Ended, with the reason reported to CallKit, or nil when CallKit performed the end action.
    case ended(CXCallEndedReason?)
}

/// One call the plugin reported to CallKit or CallKit started.
final class CallKitCall {

    enum Direction {
        case incoming
        case outgoing
    }

    enum Source {
        case pushKit
        case app
    }

    private(set) var identity: CallKitCallIdentity
    let direction: Direction
    let source: Source
    let options: CallData

    private(set) var phase: CallKitCallPhase
    var isMuted = false
    var isOnHold = false
    /// When the call last started connecting: set each time an audio session is activated.
    var startedConnectingAt: Date?
    var connectedAt: Date?
    /// Whether CallKit is told the call connected: true once CallKit started or answered it.
    var reportsConnection = false

    init(
        identity: CallKitCallIdentity, direction: Direction, source: Source, options: CallData,
        phase: CallKitCallPhase
    ) {
        self.identity = identity
        self.direction = direction
        self.source = source
        self.options = options
        self.phase = phase
    }

    func rebind(to uuid: UUID) {
        identity.rebind(to: uuid)
    }

    /// Moves the call to `phase`. An ended call only moves to another ended phase.
    func move(to phase: CallKitCallPhase) {
        if case .ended = self.phase, !phase.isEnded {
            return
        }
        self.phase = phase
    }
}

extension CallKitCallPhase {
    var isEnded: Bool {
        if case .ended = self { return true }
        return false
    }
}
