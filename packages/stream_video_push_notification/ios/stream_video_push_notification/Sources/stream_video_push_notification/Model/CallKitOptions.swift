import Foundation

/// The CallKit and audio session options `CallData` and `StreamVideoPushConfiguration` both
/// carry, read from the `ios` sub-map Dart sends or, when there is none, from the top level.
///
/// A missing key takes the same default as Dart's `IOSPushConfiguration`, so a call reported
/// before Dart sent its configuration, or from native code with only some keys, offers what a
/// call reported from Dart does.
struct CallKitOptions {
    var iconName: String
    var handleType: String
    var useComplexHandle: Bool
    var supportsVideo: Bool
    var maximumCallGroups: Int
    var supportsDTMF: Bool
    var supportsHolding: Bool
    var includesCallsInRecents: Bool
    var ringtonePath: String
    var configureAudioSession: Bool
    var audioSessionMode: String
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
        self.maximumCallGroups = source["maximumCallGroups"] as? Int ?? 1
        self.supportsDTMF = source["supportsDTMF"] as? Bool ?? false
        self.supportsHolding = source["supportsHolding"] as? Bool ?? false
        self.includesCallsInRecents = source["includesCallsInRecents"] as? Bool ?? true
        self.ringtonePath = source["ringtonePath"] as? String ?? ""
        self.configureAudioSession = source["configureAudioSession"] as? Bool ?? true
        self.audioSessionMode = source["audioSessionMode"] as? String ?? ""
        self.audioSessionPreferredSampleRate =
            source["audioSessionPreferredSampleRate"] as? Double ?? 44100.0
        self.audioSessionPreferredIOBufferDuration =
            source["audioSessionPreferredIOBufferDuration"] as? Double ?? 0.005
    }
}
