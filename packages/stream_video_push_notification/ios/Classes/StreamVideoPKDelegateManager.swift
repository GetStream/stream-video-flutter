import Foundation
import PushKit
import Flutter
import flutter_callkit_incoming

public class StreamVideoPKDelegateManager: NSObject, PKPushRegistryDelegate, UNUserNotificationCenterDelegate {
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
        
        let defaults = UserDefaults.standard
        let callbackHandle = defaults.object(forKey: "callback_handle") as? Int64
        
        var streamDict = payload.dictionaryPayload["stream"] as? [String: Any]
        
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            if state == .inactive, callbackHandle != nil {
                DispatchQueue.main.async {
                    let engine = FlutterEngine(name: "StreamVideoIsolate", project: nil, allowHeadlessExecution: true)
                    let callbackInfo = FlutterCallbackCache.lookupCallbackInformation(callbackHandle!)
                    let entrypoint = callbackInfo?.callbackName
                    let uri = callbackInfo?.callbackLibraryPath
                    
                    let isRunning = engine.run(withEntrypoint: entrypoint, libraryURI: uri)
                }
             }
          
            
            handleIncomingCall(streamDict: streamDict, state: state, completion: completion)
        } else if state == .active {
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
        let defaultCallText = "Unknown Caller"
        
        let callCid = streamDict?["call_cid"] as? String ?? ""
        let createdByName = streamDict?["created_by_display_name"] as? String
        let createdById = streamDict?["created_by_id"] as? String
        let videoIncluded = streamDict?["video"] as? String
        let videoData = videoIncluded == "false" ? 0 : 1

        var callUUID = UUID().uuidString;

        let data: StreamVideoPushParams
        if let jsonData = self.defaultData {
            data = StreamVideoPushParams(args: jsonData)
        } else {
            data = StreamVideoPushParams(args: [String: Any]())
        }
        
        data.callKitData.uuid = callUUID
        data.callKitData.nameCaller = createdByName ?? defaultCallText
        data.callKitData.handle = createdById ?? defaultCallText
        data.callKitData.type = videoData
        data.callKitData.extra = ["callCid": callCid]
        
        // Show call incoming notification.
        StreamVideoPushNotificationPlugin.showIncomingCall(
            data: data.callKitData,
            fromPushKit: true
        )
        
        completion()
    }
    
}
