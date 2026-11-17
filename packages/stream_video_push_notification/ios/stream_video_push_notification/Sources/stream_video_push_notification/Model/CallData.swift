import Foundation

@objc public class CallData: NSObject {
    @objc public var uuid: String
    @objc public var callerName: String
    @objc public var handle: String
    @objc public var type: Int
    @objc public var duration: Int
    @objc public var isAccepted: Bool
    @objc public var extra: NSDictionary

    //iOS
    @objc public var iconName: String
    @objc public var handleType: String
    @objc public var useComplexHandle: Bool
    @objc public var supportsVideo: Bool
    @objc public var maximumCallGroups: Int
    @objc public var supportsDTMF: Bool
    @objc public var supportsHolding: Bool
    @objc public var includesCallsInRecents: Bool
    @objc public var ringtonePath: String
    @objc public var configureAudioSession: Bool
    @objc public var audioSessionMode: String
    @objc public var audioSessionPreferredSampleRate: Double
    @objc public var audioSessionPreferredIOBufferDuration: Double

    /// Always true: CallKit activates the audio session when it needs it.
    @available(*, deprecated, message: "Has no effect. CallKit activates the audio session.")
    @objc public var audioSessionActive: Bool {
        get { true }
        set {}
    }

    /// Always 1: CallKit is never offered a merge of calls.
    @available(*, deprecated, message: "Has no effect. Calls cannot be merged in CallKit.")
    @objc public var maximumCallsPerCallGroup: Int {
        get { 1 }
        set {}
    }

    /// Always false: CallKit is never offered a merge of calls.
    @available(*, deprecated, message: "Has no effect. Calls cannot be merged in CallKit.")
    @objc public var supportsGrouping: Bool {
        get { false }
        set {}
    }

    /// Always false: CallKit is never offered a merge of calls.
    @available(*, deprecated, message: "Has no effect. Calls cannot be merged in CallKit.")
    @objc public var supportsUngrouping: Bool {
        get { false }
        set {}
    }

    /// A call with the default CallKit options: no holding, no keypad and one call group, as the
    /// SDK sends from Dart.
    @objc public convenience init(id: String, callerName: String, handle: String, type: Int) {
        let args: [String: Any?] = [
            "id": id, "callerName": callerName, "handle": handle, "type": type,
        ]
        self.init(args: args)
    }

    @objc public convenience init(args: NSDictionary) {
        var argsConvert = [String: Any?]()
        for (k, v) in args {
            guard let key = k as? String else { continue }
            argsConvert[key] = v
        }
        self.init(args: argsConvert)
    }

    public init(args: [String: Any?]) {
        self.uuid = args["id"] as? String ?? ""
        self.callerName = args["callerName"] as? String ?? ""
        self.handle = args["handle"] as? String ?? ""
        self.type = args["type"] as? Int ?? 0
        self.duration = args["duration"] as? Int ?? 30000
        self.isAccepted = args["isAccepted"] as? Bool ?? false
        self.extra = args["extra"] as? NSDictionary ?? [:]

        let options = CallKitOptions(args: args, defaultIconName: "AppLogo")
        self.iconName = options.iconName
        self.handleType = options.handleType
        self.useComplexHandle = options.useComplexHandle
        self.supportsVideo = options.supportsVideo
        self.maximumCallGroups = options.maximumCallGroups
        self.supportsDTMF = options.supportsDTMF
        self.supportsHolding = options.supportsHolding
        self.includesCallsInRecents = options.includesCallsInRecents
        self.ringtonePath = options.ringtonePath
        self.configureAudioSession = options.configureAudioSession
        self.audioSessionMode = options.audioSessionMode
        self.audioSessionPreferredSampleRate = options.audioSessionPreferredSampleRate
        self.audioSessionPreferredIOBufferDuration = options.audioSessionPreferredIOBufferDuration
    }

    open func toJSON() -> [String: Any] {
        let ios: [String: Any] = [
            "iconName": iconName,
            "handleType": handleType,
            "useComplexHandle": useComplexHandle,
            "supportsVideo": supportsVideo,
            "maximumCallGroups": maximumCallGroups,
            "supportsDTMF": supportsDTMF,
            "supportsHolding": supportsHolding,
            "includesCallsInRecents": includesCallsInRecents,
            "ringtonePath": ringtonePath,
            "configureAudioSession": configureAudioSession,
            "audioSessionMode": audioSessionMode,
            "audioSessionPreferredSampleRate": audioSessionPreferredSampleRate,
            "audioSessionPreferredIOBufferDuration": audioSessionPreferredIOBufferDuration,
        ]
        let map: [String: Any] = [
            "uuid": uuid,
            "id": uuid,
            "callerName": callerName,
            "handle": handle,
            "type": type,
            "duration": duration,
            "isAccepted": isAccepted,
            "extra": extra,
            "ios": ios,
        ]
        return map
    }

    func getEncryptHandle() -> String {
        if !useComplexHandle {
            return handle
        }
        do {
            var map: [String: Any] = [:]

            map["callerName"] = callerName
            map["handle"] = handle

            if let mapExtras = extra as? [String: Any] {
                for (key, value) in mapExtras {
                    map[key] = value
                }
            } else {
                return String(
                    format: "{\"callerName\":\"%@\", \"handle\":\"%@\"}", callerName, handle
                ).encryptHandle()
            }

            let mapData = try JSONSerialization.data(withJSONObject: map, options: .prettyPrinted)
            let mapString: String = String(data: mapData, encoding: .utf8) ?? ""

            return mapString.encryptHandle()
        } catch {
            return String(format: "{\"callerName\":\"%@\", \"handle\":\"%@\"}", callerName, handle)
                .encryptHandle()
        }

    }

}
