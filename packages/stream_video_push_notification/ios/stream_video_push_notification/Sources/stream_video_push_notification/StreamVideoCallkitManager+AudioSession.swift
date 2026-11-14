import AVFoundation
import CallKit

extension StreamVideoCallkitManager {

    /// Applies `data`'s audio session options, or the last options' when `data` is nil.
    func configureAudioSession(_ data: CallData? = nil) {
        audio.configure(data ?? store.lastOptions)
    }

    func getAudioSessionMode(_ audioSessionMode: String?) -> AVAudioSession.Mode {
        CallKitAudioSessionCoordinator.mode(for: audioSessionMode)
    }

    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        apply(audio.didActivate(store))
    }

    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        apply(audio.didDeactivate(store))
    }
}
