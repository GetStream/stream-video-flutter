import ReplayKit
import OSLog

let broadcastLogger = OSLog(subsystem: "io.getstream.video.screen_sharing.broadcast", category: "Broadcast")

private enum Constants {
    static let appGroupIdentifier = "RTCAppGroupIdentifier"
    static let broadcastSharePath = "rtc_SSFD"
    static let broadcastStartedNotification = "io.getstream.video.screen_sharing.broadcastStarted"
    static let broadcastStoppedNotification = "io.getstream.video.screen_sharing.broadcastStopped"
}

open class BroadcastSampleHandler: RPBroadcastSampleHandler {
    
    private var clientConnection: SocketConnection?
    private var uploader: BroadcastSampleUploader?
    private let notificationCenter: CFNotificationCenter    

    private var frameCount: Int = 0
    
    private var socketFilePath: String {
        guard let appGroupIdentifier = infoPlistValue(for: Constants.appGroupIdentifier),
              let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
        else {
            return ""
        }
        
        return sharedContainer.appendingPathComponent(
            Constants.broadcastSharePath
        )
        .path
    }
    
    override init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()

      super.init()
        if let connection = SocketConnection(filePath: socketFilePath) {
          clientConnection = connection
          setupConnection()
          
          uploader = BroadcastSampleUploader(connection: connection)
        }
    }

    override public func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        frameCount = 0
        
        postNotification(Constants.broadcastStartedNotification)
        openConnection()
    }
    
    override public func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override public func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override public func broadcastFinished() {
        // User has requested to finish the broadcast.
        postNotification(Constants.broadcastStoppedNotification)
        clientConnection?.close()
    }
    
    override public func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            uploader?.send(sample: sampleBuffer)
        default:
            break
        }
    }

    private func postNotification(_ name: String) {
        CFNotificationCenterPostNotification(
            notificationCenter,
            CFNotificationName(rawValue: name as CFString),
            nil,
            nil,
            true
        )
    }
}

private extension BroadcastSampleHandler {
  
    func setupConnection() {
        clientConnection?.didClose = { [weak self] error in
            if let error = error {
                self?.finishBroadcastWithError(error)
            } else {
                // the displayed failure message is more user friendly when using NSError instead of Error
                let JMScreenSharingStopped = 10001
                let customError = NSError(domain: RPRecordingErrorDomain, code: JMScreenSharingStopped, userInfo: [NSLocalizedDescriptionKey: "Screen sharing stopped"])
                self?.finishBroadcastWithError(customError)
            }
        }
    }
    
    func openConnection() {
        let queue = DispatchQueue(label: "broadcast.connectTimer")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in
            guard self?.clientConnection?.open() == true else {
                return
            }
            
            timer.cancel()
        }
        
        timer.resume()
    }
}

func infoPlistValue(for key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
}
