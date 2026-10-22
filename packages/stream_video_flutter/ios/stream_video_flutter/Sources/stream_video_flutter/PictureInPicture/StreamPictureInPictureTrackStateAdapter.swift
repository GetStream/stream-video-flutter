//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import stream_webrtc_flutter

/// StreamPictureInPictureTrackStateAdapter serves as an adapter for managing the state of a video track
/// used for picture-in-picture functionality. It can enable or disable observers based on its isEnabled property
/// and ensures that the active track is always enabled when necessary.
final class StreamPictureInPictureTrackStateAdapter {

    /// This property represents whether the adapter is enabled or not.
    var isEnabled: Bool = false {
        didSet {
            /// When the 'isEnabled' property changes, this didSet observer is called.
            /// It checks if the new value is different from the old value, and if so,
            /// it calls the 'enableObserver' function.
            guard isEnabled != oldValue else { return }
            enableObserver(isEnabled)
            if !isEnabled { restoreDisabledTracks() }
        }
    }

    /// This property represents the active RTCVideoTrack.
    var activeTrack: RTCVideoTrack? {
        didSet {
            /// When the 'activeTrack' property changes, this didSet observer is called.
            /// If the adapter is enabled and the new 'activeTrack' is different from the old one,
            /// it disables the old track (if it exists), and remembers it so it is enabled again
            /// once picture-in-picture ends.
            if isEnabled, let oldValue, oldValue.trackId != activeTrack?.trackId,
                oldValue.isEnabled
            {
                oldValue.isEnabled = false
                disabledTracks.append(oldValue)
            }
        }
    }

    // MARK: - Private helpers

    /// This property holds a reference to the observer cancellable.
    private var observerCancellable: AnyCancellable?

    /// The tracks this adapter disabled when picture-in-picture moved away from them. The app
    /// shows them again once picture-in-picture ends, and only this adapter knows to enable them.
    private var disabledTracks: [RTCVideoTrack] = []

    /// Enables the tracks this adapter disabled.
    private func restoreDisabledTracks() {
        for track in disabledTracks where !track.isEnabled {
            track.isEnabled = true
        }
        disabledTracks.removeAll()
    }

    /// This private function enables or disables an observer based on the 'isActive' parameter.
    ///
    /// - Parameter isActive: A Boolean value indicating whether the observer should be active.
    private func enableObserver(_ isActive: Bool) {
        if isActive {
            /// If 'isActive' is true, it sets up an observer that checks tracks state periodically.
            observerCancellable =
                Timer
                .publish(every: 0.1, on: .main, in: .default)
                .autoconnect()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.checkTracksState()
                }
        } else {
            /// If 'isActive' is false, it cancels the observer.
            observerCancellable?.cancel()
            observerCancellable = nil
        }
    }

    /// This private function checks the state of the active track and enables it if it's not already enabled.
    private func checkTracksState() {
        if let activeTrack, !activeTrack.isEnabled {
            //            log.info("⚙️Active track:\(activeTrack.trackId) for picture-in-picture will be enabled now.")
            self.activeTrack?.isEnabled = true
        }
    }
}
