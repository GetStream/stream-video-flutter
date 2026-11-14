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

    /// The id events report the call by: the app id when it names the CallKit uuid the call was
    /// first known by, otherwise that uuid, lowercased.
    var reportedId: String {
        let firstUUID = (previousCallKitUUIDs.first ?? callKitUUID).uuidString.lowercased()
        return appId.lowercased() == firstUUID ? appId : firstUUID
    }

    /// Whether CallKit knows or knew the call as `uuid`.
    func isKnown(as uuid: UUID) -> Bool {
        callKitUUID == uuid || previousCallKitUUIDs.contains(uuid)
    }
}

/// Why a call is on hold.
enum CallKitHoldOrigin: Equatable {
    /// CallKit held the call while another app's call was there, such as a cellular call
    /// answered with Hold & Accept.
    case otherCall
    /// The app or the user held the call.
    case requested
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
    /// On hold.
    case held(CallKitHoldOrigin)
    /// Off hold again, or registered again; `activated` once CallKit activated the audio session
    /// since.
    case resumed(activated: Bool)
    /// Reported to CallKit as ended and being started again as `uuid`, so CallKit gives it a new
    /// audio session. `attempt` counts the start requests CallKit refused.
    case reRegistering(as: UUID, attempt: Int)
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
    /// Times the call was registered with CallKit again since it was last put on hold.
    var reRegistrationsSinceHold = 0
    /// When the call started connecting: set on the first audio session activation.
    var startedConnectingAt: Date?
    var connectedAt: Date?
    /// Whether CallKit is told the call connected: true once CallKit started or answered it.
    var reportsConnection = false
    /// Whether CallKit activated the audio session since the call was started or answered.
    var hasActivatedAudioSession = false

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

extension CallKitCall {
    var isOnHold: Bool {
        if case .held = phase { return true }
        return false
    }
}

extension CallKitCallPhase {
    var isEnded: Bool {
        if case .ended = self { return true }
        return false
    }

    var isResumed: Bool {
        if case .resumed = self { return true }
        return false
    }
}
