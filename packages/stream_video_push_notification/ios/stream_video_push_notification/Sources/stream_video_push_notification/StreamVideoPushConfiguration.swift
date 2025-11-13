import Foundation

@objc public class StreamVideoPushConfiguration: NSObject {
    @objc public var headers: NSDictionary

    // flattened iOS params
    @objc public var iconName: String
    @objc public var handleType: String
    @objc public var useComplexHandle: Bool
    @objc public var supportsVideo: Bool
    @objc public var maximumCallGroups: Int
    @objc public var maximumCallsPerCallGroup: Int
    @objc public var audioSessionMode: String
    @objc public var audioSessionActive: Bool
    @objc public var audioSessionPreferredSampleRate: Double
    @objc public var audioSessionPreferredIOBufferDuration: Double
    @objc public var configureAudioSession: Bool
    @objc public var supportsDTMF: Bool
    @objc public var supportsHolding: Bool
    @objc public var supportsGrouping: Bool
    @objc public var supportsUngrouping: Bool
    @objc public var ringtonePath: String

    @objc public init(headers: NSDictionary) {
        self.headers = headers

        // Default iOS values
        self.iconName = "CallKitLogo"
        self.handleType = ""
        self.useComplexHandle = false
        self.supportsVideo = true
        self.maximumCallGroups = 2
        self.maximumCallsPerCallGroup = 1
        self.audioSessionMode = ""
        self.audioSessionActive = true
        self.audioSessionPreferredSampleRate = 44100.0
        self.audioSessionPreferredIOBufferDuration = 0.005
        self.configureAudioSession = true
        self.supportsDTMF = true
        self.supportsHolding = true
        self.supportsGrouping = true
        self.supportsUngrouping = true
        self.ringtonePath = ""
    }

    @objc public convenience init(args: NSDictionary) {

        var argsConvert = [String: Any?]()
        for (key, value) in args {
            if let keyString = key as? String {
                argsConvert[keyString] = value
            }
        }
        self.init(args: argsConvert)
    }

    public init(args: [String: Any?]) {
        self.headers = args["headers"] as? NSDictionary ?? [:]

        if let ios = args["ios"] as? [String: Any] {
            self.iconName = ios["iconName"] as? String ?? "CallKitLogo"
            self.handleType = ios["handleType"] as? String ?? ""
            self.useComplexHandle = ios["useComplexHandle"] as? Bool ?? false
            self.supportsVideo = ios["supportsVideo"] as? Bool ?? true
            self.maximumCallGroups = ios["maximumCallGroups"] as? Int ?? 2
            self.maximumCallsPerCallGroup = ios["maximumCallsPerCallGroup"] as? Int ?? 1
            self.audioSessionMode = ios["audioSessionMode"] as? String ?? ""
            self.audioSessionActive = ios["audioSessionActive"] as? Bool ?? true
            self.audioSessionPreferredSampleRate =
                ios["audioSessionPreferredSampleRate"] as? Double ?? 44100.0
            self.audioSessionPreferredIOBufferDuration =
                ios["audioSessionPreferredIOBufferDuration"] as? Double ?? 0.005
            self.configureAudioSession = ios["configureAudioSession"] as? Bool ?? true
            self.supportsDTMF = ios["supportsDTMF"] as? Bool ?? true
            self.supportsHolding = ios["supportsHolding"] as? Bool ?? true
            self.supportsGrouping = ios["supportsGrouping"] as? Bool ?? true
            self.supportsUngrouping = ios["supportsUngrouping"] as? Bool ?? true
            self.ringtonePath = ios["ringtonePath"] as? String ?? ""
        } else {
            // Fallback to top-level properties if ios object doesn't exist
            self.iconName = args["iconName"] as? String ?? "CallKitLogo"
            self.handleType = args["handleType"] as? String ?? ""
            self.useComplexHandle = args["useComplexHandle"] as? Bool ?? false
            self.supportsVideo = args["supportsVideo"] as? Bool ?? true
            self.maximumCallGroups = args["maximumCallGroups"] as? Int ?? 2
            self.maximumCallsPerCallGroup = args["maximumCallsPerCallGroup"] as? Int ?? 1
            self.audioSessionMode = args["audioSessionMode"] as? String ?? ""
            self.audioSessionActive = args["audioSessionActive"] as? Bool ?? true
            self.audioSessionPreferredSampleRate =
                args["audioSessionPreferredSampleRate"] as? Double ?? 44100.0
            self.audioSessionPreferredIOBufferDuration =
                args["audioSessionPreferredIOBufferDuration"] as? Double ?? 0.005
            self.configureAudioSession = args["configureAudioSession"] as? Bool ?? true
            self.supportsDTMF = args["supportsDTMF"] as? Bool ?? true
            self.supportsHolding = args["supportsHolding"] as? Bool ?? true
            self.supportsGrouping = args["supportsGrouping"] as? Bool ?? true
            self.supportsUngrouping = args["supportsUngrouping"] as? Bool ?? true
            self.ringtonePath = args["ringtonePath"] as? String ?? ""
        }
    }

    open func toJSON() -> [String: Any] {
        let ios: [String: Any] = [
            "iconName": iconName,
            "handleType": handleType,
            "useComplexHandle": useComplexHandle,
            "supportsVideo": supportsVideo,
            "maximumCallGroups": maximumCallGroups,
            "maximumCallsPerCallGroup": maximumCallsPerCallGroup,
            "audioSessionMode": audioSessionMode,
            "audioSessionActive": audioSessionActive,
            "audioSessionPreferredSampleRate": audioSessionPreferredSampleRate,
            "audioSessionPreferredIOBufferDuration": audioSessionPreferredIOBufferDuration,
            "configureAudioSession": configureAudioSession,
            "supportsDTMF": supportsDTMF,
            "supportsHolding": supportsHolding,
            "supportsGrouping": supportsGrouping,
            "supportsUngrouping": supportsUngrouping,
            "ringtonePath": ringtonePath,
        ]

        let result: [String: Any] = [
            "headers": headers,
            "ios": ios,
        ]

        return result
    }
}
