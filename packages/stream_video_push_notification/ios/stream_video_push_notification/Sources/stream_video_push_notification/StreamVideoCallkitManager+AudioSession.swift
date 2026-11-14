import AVFoundation
import CallKit

extension StreamVideoCallkitManager {

    func sendDefaultAudioInterruptionNofificationToStartAudioResource() {
        var userInfo: [AnyHashable: Any] = [:]
        let intrepEndeRaw = AVAudioSession.InterruptionType.ended.rawValue
        userInfo[AVAudioSessionInterruptionTypeKey] = intrepEndeRaw
        userInfo[AVAudioSessionInterruptionOptionKey] =
            AVAudioSession.InterruptionOptions.shouldResume.rawValue
        NotificationCenter.default.post(
            name: AVAudioSession.interruptionNotification, object: self, userInfo: userInfo)
    }

    /// Applies `data`'s audio session options, or the stored call's when `data` is nil.
    func configureAudioSession(_ data: CallData? = nil) {
        let data = data ?? self.data
        if data?.configureAudioSession != false {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(
                    AVAudioSession.Category.playAndRecord,
                    options: [
                        .allowBluetoothA2DP,
                        .duckOthers,
                        .allowBluetooth,
                    ])

                try session.setMode(self.getAudioSessionMode(data?.audioSessionMode))
                try session.setActive(data?.audioSessionActive ?? true)
                try session.setPreferredSampleRate(data?.audioSessionPreferredSampleRate ?? 44100.0)
                try session.setPreferredIOBufferDuration(
                    data?.audioSessionPreferredIOBufferDuration ?? 0.005)
            } catch {
                print(error)
            }
        }
    }

    func getAudioSessionMode(_ audioSessionMode: String?) -> AVAudioSession.Mode {
        var mode = AVAudioSession.Mode.default
        switch audioSessionMode {
        case "gameChat":
            mode = AVAudioSession.Mode.gameChat
            break
        case "measurement":
            mode = AVAudioSession.Mode.measurement
            break
        case "moviePlayback":
            mode = AVAudioSession.Mode.moviePlayback
            break
        case "spokenAudio":
            mode = AVAudioSession.Mode.spokenAudio
            break
        case "videoChat":
            mode = AVAudioSession.Mode.videoChat
            break
        case "videoRecording":
            mode = AVAudioSession.Mode.videoRecording
            break
        case "voiceChat":
            mode = AVAudioSession.Mode.voiceChat
            break
        case "voicePrompt":
            if #available(iOS 12.0, *) {
                mode = AVAudioSession.Mode.voicePrompt
            } else {
                // Fallback on earlier versions
            }
            break
        default:
            mode = AVAudioSession.Mode.default
        }
        return mode
    }

    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        if self.answerCall?.hasConnected ?? false {
            sendDefaultAudioInterruptionNofificationToStartAudioResource()
            return
        }
        if self.outgoingCall?.hasConnected ?? false {
            sendDefaultAudioInterruptionNofificationToStartAudioResource()
            return
        }
        self.outgoingCall?.startCall(withAudioSession: audioSession) { success in
            if success {
                self.callController.addCall(self.outgoingCall!)
                self.outgoingCall?.startAudio()
            }
        }
        self.answerCall?.answerCall(withAudioSession: audioSession) { success in
            if success {
                self.answerCall?.startAudio()
            }
        }
        sendDefaultAudioInterruptionNofificationToStartAudioResource()
        configureAudioSession()

        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION, ["isActive": true]
        )
    }

    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        if self.outgoingCall?.isOnHold ?? false || self.answerCall?.isOnHold ?? false {
            print("Call is on hold")
            return
        }

        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
            ["isActive": false])
    }
}
