import flutter_callkit_incoming

@objc public class StreamVideoPushParams: NSObject {
    @objc public var incomingCallerNameOverride: String?
    @objc public var incomingCallerHandlerOverride: String?

    public var callKitData: flutter_callkit_incoming.Data;

    public init(args: [String: Any?]) {
        self.callKitData = flutter_callkit_incoming.Data.init(args: args)
        self.incomingCallerNameOverride = args["incomingCallerNameOverride"] as? String ?? ""
        self.incomingCallerHandlerOverride = args["incomingCallerHandlerOverride"] as? String ?? ""
    }

    public func toJSON() -> [String: Any]  {
        var map = callKitData.toJSON()
        map["incomingCallerNameOverride"] = incomingCallerNameOverride
        map["incomingCallerHandlerOverride"] = incomingCallerHandlerOverride
        return map
    }
}
