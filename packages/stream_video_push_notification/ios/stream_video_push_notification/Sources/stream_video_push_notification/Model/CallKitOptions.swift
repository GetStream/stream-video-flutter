import Foundation

/// The CallKit and audio session options `CallData` and `StreamVideoPushConfiguration` both
/// carry, read from the `ios` sub-map Dart sends or, when there is none, from the top level.
struct CallKitOptions {
    var iconName: String
    var handleType: String
    var useComplexHandle: Bool
    var supportsVideo: Bool
    var maximumCallGroups: Int
    var maximumCallsPerCallGroup: Int
    var supportsDTMF: Bool
    var supportsHolding: Bool
    var supportsGrouping: Bool
    var supportsUngrouping: Bool
    var includesCallsInRecents: Bool
    var ringtonePath: String
    var configureAudioSession: Bool
    var audioSessionMode: String
    var audioSessionActive: Bool
    var audioSessionPreferredSampleRate: Double
    var audioSessionPreferredIOBufferDuration: Double

    /// `defaultIconName` is used when no `iconName` is given.
    init(args: [String: Any?], defaultIconName: String) {
        let source: [String: Any?]
        if let ios = args["ios"] as? [String: Any] {
            source = ios
        } else {
            source = args
        }

        self.iconName = source["iconName"] as? String ?? defaultIconName
        self.handleType = source["handleType"] as? String ?? ""
        self.useComplexHandle = source["useComplexHandle"] as? Bool ?? false
        self.supportsVideo = source["supportsVideo"] as? Bool ?? true
        self.maximumCallGroups = source["maximumCallGroups"] as? Int ?? 2
        self.maximumCallsPerCallGroup = source["maximumCallsPerCallGroup"] as? Int ?? 1
        self.supportsDTMF = source["supportsDTMF"] as? Bool ?? true
        self.supportsHolding = source["supportsHolding"] as? Bool ?? true
        self.supportsGrouping = source["supportsGrouping"] as? Bool ?? true
        self.supportsUngrouping = source["supportsUngrouping"] as? Bool ?? true
        self.includesCallsInRecents = source["includesCallsInRecents"] as? Bool ?? true
        self.ringtonePath = source["ringtonePath"] as? String ?? ""
        self.configureAudioSession = source["configureAudioSession"] as? Bool ?? true
        self.audioSessionMode = source["audioSessionMode"] as? String ?? ""
        self.audioSessionActive = source["audioSessionActive"] as? Bool ?? true
        self.audioSessionPreferredSampleRate =
            source["audioSessionPreferredSampleRate"] as? Double ?? 44100.0
        self.audioSessionPreferredIOBufferDuration =
            source["audioSessionPreferredIOBufferDuration"] as? Double ?? 0.005
    }
}
