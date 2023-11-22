import flutter_callkit_incoming

@objc public class StreamVideoPushParams: NSObject {
    public var callKitData: flutter_callkit_incoming.Data;

    public init(args: [String: Any?]) {
        self.callKitData = flutter_callkit_incoming.Data.init(args: args)
    }

    public func toJSON() -> [String: Any]  {
        var map = callKitData.toJSON()
        return map
    }
}
