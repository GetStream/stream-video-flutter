//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import AVFoundation
import Foundation
import stream_webrtc_flutter

/// A view that renders an instance of `RTCVideoTrack` in the picture-in-picture
/// window.
///
/// The frames are drawn by WebRTC's `RTCPictureInPictureVideoRenderer`, which
/// converts them into sample buffers off the main thread, scales them to its
/// bounds, and flushes its display layer when it needs flushing to resume, such
/// as after the app was in the background. This view adds what it lacks: it
/// turns the renderer by the frames' rotation, and gives the window the shape of
/// the video.
final class StreamPictureInPictureVideoRenderer: UIView, RTCVideoRenderer {

    /// The rendering track.
    ///
    /// This view renders it as soon as it is set, so the window learns the
    /// video's size before picture-in-picture starts. The frames are only
    /// converted while the view is in a window.
    ///
    /// - Important: The track holds on to this view until it is set to nil.
    var track: RTCVideoTrack? {
        didSet {
            guard oldValue != track else { return }
            oldValue?.remove(self)
            // Disabling flushes the previous track's last frame, which would
            // otherwise stay up, in its own shape, until the new one draws.
            if window != nil {
                videoRenderer.isEnabled = false
                videoRenderer.isEnabled = true
            }
            track?.add(self)
        }
    }

    /// A policy defining how the Picture in Picture window should be resized in order to better fit
    /// the rendering frame size.
    var pictureInPictureWindowSizePolicy: PictureInPictureWindowSizePolicy

    /// The view that draws the frames.
    private lazy var videoRenderer: RTCPictureInPictureVideoRenderer = {
        let videoRenderer = RTCPictureInPictureVideoRenderer(frame: .zero)
        // Laid out by hand, as it is rotated by the frames' rotation.
        videoRenderer.translatesAutoresizingMaskIntoConstraints = true
        videoRenderer.videoGravity = .resizeAspectFill
        // Picture-in-picture doesn't like rendering frames bigger than its
        // window, so they are scaled to the renderer's bounds.
        videoRenderer.resizesFramesToRendererSize = true
        videoRenderer.isEnabled = false
        (videoRenderer.layer as? AVSampleBufferDisplayLayer)?
            .preventsDisplaySleepDuringVideoPlayback = true
        return videoRenderer
    }()

    /// The rotation the frames need to be shown upright. The renderer draws
    /// them as their buffers hold them, so it is turned by this instead.
    /// Only read and written on WebRTC's thread, from ``renderFrame(_:)``.
    private var frameRotation: RTCVideoRotation = ._0

    /// The rotation the renderer is turned by. Main thread only.
    private var displayRotation: RTCVideoRotation = ._0

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(windowSizePolicy: PictureInPictureWindowSizePolicy) {
        pictureInPictureWindowSizePolicy = windowSizePolicy
        super.init(frame: .zero)
        addSubview(videoRenderer)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        // Converting frames is only worth it while the picture-in-picture
        // window shows them. Disabling flushes the frames already queued.
        videoRenderer.isEnabled = window != nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutVideoRenderer()
    }

    // MARK: - RTCVideoRenderer

    /// Called by WebRTC before a frame of a new size, with that size as the
    /// frame is shown: its rotation applied.
    func setSize(_ size: CGSize) {
        videoRenderer.setSize(size)

        guard size != .zero else { return }
        // The policy sets the controller's preferredContentSize, which is only
        // safe on the main thread, while WebRTC calls this on its own.
        DispatchQueue.main.async { [weak self] in
            self?.pictureInPictureWindowSizePolicy.trackSize = size
        }
    }

    func renderFrame(_ frame: RTCVideoFrame?) {
        if let rotation = frame?.rotation, rotation != frameRotation {
            frameRotation = rotation
            DispatchQueue.main.async { [weak self] in
                self?.applyDisplayRotation(rotation)
            }
        }
        videoRenderer.renderFrame(frame)
    }

    // MARK: - Private helpers

    /// Turns the renderer to show the frames upright.
    private func applyDisplayRotation(_ rotation: RTCVideoRotation) {
        guard rotation != displayRotation else { return }
        displayRotation = rotation
        setNeedsLayout()
    }

    /// Fills the view with the renderer, turned by ``displayRotation``. A
    /// quarter-turned one is laid out with its sides swapped, so it covers the
    /// view once turned, and the renderer scales the frames to its bounds in the
    /// frames' own orientation.
    private func layoutVideoRenderer() {
        let angle: CGFloat
        switch displayRotation {
        case ._90: angle = .pi / 2
        case ._180: angle = .pi
        case ._270: angle = -.pi / 2
        default: angle = 0
        }
        let isQuarterTurned = displayRotation == ._90 || displayRotation == ._270

        // The bounds and centre are set untransformed; the frame is undefined
        // while a transform is applied.
        videoRenderer.transform = .identity
        videoRenderer.bounds = CGRect(
            origin: .zero,
            size: isQuarterTurned
                ? CGSize(width: bounds.height, height: bounds.width)
                : bounds.size
        )
        videoRenderer.center = CGPoint(x: bounds.midX, y: bounds.midY)
        videoRenderer.transform = CGAffineTransform(rotationAngle: angle)
    }
}
