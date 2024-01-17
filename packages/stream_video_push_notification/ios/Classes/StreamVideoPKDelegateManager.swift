import Foundation
import PushKit
import Flutter
import flutter_callkit_incoming

public class StreamVideoPKDelegateManager: NSObject, PKPushRegistryDelegate {
    public static let shared = StreamVideoPKDelegateManager()
    
    private var pushRegistry: PKPushRegistry?
    private var defaultData: [String: Any]?
    private var mainChannel: FlutterMethodChannel?
    
    private override init() {
        super.init()
    }
    
    @objc public func registerForPushNotifications() {
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = [.voIP]
    }
    
    public func initChannel(mainChannel: FlutterMethodChannel) {
        self.mainChannel = mainChannel
    }
    
    public func initData(data: [String: Any]) {
        defaultData = data
    }
    
    // MARK: - PKPushRegistryDelegate
    @objc public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: deviceToken)
    }
    
    @objc public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: "")
    }
    
    @objc public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        // Return if type is not voIP.
        guard type == .voIP else {
            return completion()
        }
        
        print("voip received")
        
        let defaults = UserDefaults.standard
        let callbackHandle = defaults.object(forKey: "callback_handle") as? Int64
        
        var streamDict = payload.dictionaryPayload["stream"] as? [String: Any]
        
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            print("in background")

            if state == .inactive, callbackHandle != nil {
                DispatchQueue.main.async {
                    let engine = FlutterEngine(name: "StreamVideoIsolate", project: nil, allowHeadlessExecution: true)
                    let callbackInfo = FlutterCallbackCache.lookupCallbackInformation(callbackHandle!)
                    let entrypoint = callbackInfo?.callbackName
                    let uri = callbackInfo?.callbackLibraryPath
                    
                    print("starting Engine")
                    let isRunning = engine.run(withEntrypoint: entrypoint, libraryURI: uri)
                }
             }
          
            
            handleIncomingCall(streamDict: streamDict, state: state, completion: completion)
        } else if state == .active {
            print("in foreground")
            
            mainChannel?.invokeMethod("customizeCaller", arguments: streamDict) { (response) in
                if let customData = response as? [String: Any] {
                    streamDict?["created_by_display_name"] = customData["name"] as? String
                    streamDict?["created_by_id"] = customData["handle"] as? String
                }
                
                self.handleIncomingCall(streamDict: streamDict, state: state, completion: completion)
            }
        }
    }
    
    func handleIncomingCall(streamDict: [String: Any]?, state: UIApplication.State, completion: @escaping () -> Void) {
        print("handling call")
        
        let defaultCallText = "Unknown Caller"
        
        let callCid = streamDict?["call_cid"] as? String ?? ""
        var createdByName = streamDict?["created_by_display_name"] as? String
        var createdById = streamDict?["created_by_id"] as? String

        let splitCid = callCid.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        var callId = UUID().uuidString;
        var callType = "";

        if splitCid.count == 2 {
            let callType = String(splitCid[0])
            let callId = String(splitCid[1])
        } 

        methodChannel?.invokeMethod("customizeCaller", arguments: streamDict) { (response) in
            if let customData = response as? [String: Any] {
                createdByName = customData["name"] as? String ?? createdByName
                createdById = customData["handle"] as? String ?? createdById
            }

            let data: StreamVideoPushParams
            if let jsonData = self.defaultData {
                data = StreamVideoPushParams(args: jsonData)
            } else {
                data = StreamVideoPushParams(args: [String: Any]())
            }

            data.callKitData.uuid = callId
            data.callKitData.nameCaller = createdByName ?? defaultCallText
            data.callKitData.handle = createdById ?? defaultCallText
            data.callKitData.type = 1 //video
            data.callKitData.extra = ["callCid": callCid]

            // Show call incoming notification.
            StreamVideoPushNotificationPlugin.showIncomingCall(
                data: data.callKitData,
                fromPushKit: true
            )
            
            // Complete after a delay to ensure that the incoming call notification
            // is displayed before completing the push notification handling.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                completion()
            }
        }
        
        data.callKitData.uuid = callId
        data.callKitData.nameCaller = createdByName ?? defaultCallText
        data.callKitData.handle = createdById ?? defaultCallText
        data.callKitData.type = 1 //video
        data.callKitData.extra = ["callCid": callCid]
        
        // Show call incoming notification.
        StreamVideoPushNotificationPlugin.showIncomingCall(
            data: data.callKitData,
            fromPushKit: true
        )
        
        // Complete after a delay to ensure that the incoming call notification
        // is displayed before completing the push notification handling.
       DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           completion()
       }
    }
    
}
