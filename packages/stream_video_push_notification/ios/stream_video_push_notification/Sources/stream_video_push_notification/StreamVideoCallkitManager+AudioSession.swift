import AVFoundation
import CallKit

extension StreamVideoCallkitManager {

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        apply(audio.didActivate(store))
        holdRecovery.audioActivated()
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        apply(audio.didDeactivate(store))
        restoreRecentsIfNoCallLeft()
    }
}
