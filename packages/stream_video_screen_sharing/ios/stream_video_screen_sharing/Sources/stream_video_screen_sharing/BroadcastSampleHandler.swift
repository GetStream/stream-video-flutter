import ReplayKit
import OSLog

let broadcastLogger = OSLog(subsystem: "io.getstream.video.screen_sharing.broadcast", category: "Broadcast")

private enum Constants {
    static let appGroupIdentifier = "RTCAppGroupIdentifier"
    static let broadcastSharePath = "rtc_SSFD"
    // Darwin notifications shared with the stream_webrtc_flutter plugin in the app.
    // The extension cannot link that plugin, so each side keeps its own copy of the names.
    static let broadcastStartedNotification = "io.getstream.video.screen_sharing.broadcastStarted"
    static let broadcastStoppedNotification = "io.getstream.video.screen_sharing.broadcastStopped"
    static let broadcastStopRequestedNotification = "io.getstream.video.screen_sharing.broadcastStopRequested"
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

        observeStopRequest()
        postNotification(Constants.broadcastStartedNotification)
        openConnection()
    }

    deinit {
        removeStopRequestObserver()
    }
    
    override public func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override public func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override public func broadcastFinished() {
        // User has requested to finish the broadcast.
        removeStopRequestObserver()
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

    /// Finishes the broadcast with an error when the app asks for it, after
    /// the app could not share the broadcast.
    func observeStopRequest() {
        CFNotificationCenterAddObserver(
            notificationCenter,
            Unmanaged.passUnretained(self).toOpaque(),
            { _, observer, _, _, _ in
                guard let observer else { return }
                let handler = Unmanaged<BroadcastSampleHandler>.fromOpaque(observer).takeUnretainedValue()
                let JMScreenSharingFailed = 10002
                let error = NSError(domain: RPRecordingErrorDomain, code: JMScreenSharingFailed, userInfo: [NSLocalizedDescriptionKey: "The app could not share the screen"])
                handler.finishBroadcastWithError(error)
            },
            Constants.broadcastStopRequestedNotification as CFString,
            nil,
            .deliverImmediately
        )
    }

    func removeStopRequestObserver() {
        CFNotificationCenterRemoveObserver(
            notificationCenter,
            Unmanaged.passUnretained(self).toOpaque(),
            CFNotificationName(rawValue: Constants.broadcastStopRequestedNotification as CFString),
            nil
        )
    }

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
