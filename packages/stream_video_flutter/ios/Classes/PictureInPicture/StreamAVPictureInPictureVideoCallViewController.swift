//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import AVKit
import Foundation
import SwiftUI
import stream_webrtc_flutter

/// Describes an object that can be used to present picture-in-picture content.
protocol StreamAVPictureInPictureViewControlling: AnyObject {

    /// The closure to call whenever the picture-in-picture window size changes.
    var onSizeUpdate: ((CGSize) -> Void)? { get set }

    /// The track that will be rendered on picture-in-picture window.
    var track: RTCVideoTrack? { get set }

    /// The preferred size for the picture-in-picture window.
    /// - Important: This should **always** be greater to ``CGSize.zero``. If not, iOS throws
    /// a cryptic error with content `PGPegasus code:-1003`
    var preferredContentSize: CGSize { get set }

    /// The layer that renders the incoming frames from WebRTC.
    var displayLayer: CALayer { get }

    /// Removes the current overlay from the picture-in-picture view
    func removeOverlay()

    /// Updates overlay with participant information
    func updateParticipantOverlay(
        name: String?, imageUrl: String?, connectionQuality: String, isMuted: Bool, hasVideo: Bool)

    /// Updates overlay with participant information and configuration options
    func updateParticipantOverlay(
        name: String?, imageUrl: String?, connectionQuality: String, isMuted: Bool, hasVideo: Bool,
        showParticipantName: Bool, showMicrophoneIndicator: Bool,
        showConnectionQualityIndicator: Bool)
}

@available(iOS 15.0, *)
final class StreamAVPictureInPictureVideoCallViewController:
    AVPictureInPictureVideoCallViewController,
    StreamAVPictureInPictureViewControlling
{

    private let contentView: StreamPictureInPictureVideoRenderer =
        .init(windowSizePolicy: StreamPictureInPictureAdaptiveWindowSizePolicy())

    var onSizeUpdate: ((CGSize) -> Void)?

    // Overlay support
    private var overlayHostingController: UIHostingController<AnyView>?

    // Track state to avoid unnecessary updates
    private var currentName: String?
    private var currentImageUrl: String?
    private var currentHasVideo: Bool?

    var track: RTCVideoTrack? {
        get { contentView.track }
        set {
            contentView.track = newValue
            contentView.isHidden = (newValue == nil)

            // Bring video content to front when new track is set, then overlay on top
            view.bringSubviewToFront(contentView)
            if let overlayController = overlayHostingController {
                view.bringSubviewToFront(overlayController.view)
            }
        }
    }

    var displayLayer: CALayer { contentView.displayLayer }

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Initializes a new instance and sets the `preferredContentSize` to `Self.defaultPreferredContentSize`
    /// value.
    required init() {
        super.init(nibName: nil, bundle: nil)
        contentView.pictureInPictureWindowSizePolicy.controller = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.bounds = view.bounds
        onSizeUpdate?(contentView.bounds.size)

        // Update overlay layout if it exists
        if let overlayController = overlayHostingController {
            overlayController.view.frame = view.bounds
        }
    }

    // MARK: - Overlay Support

    func removeOverlay() {
        if let overlayController = overlayHostingController {
            overlayController.willMove(toParent: nil)
            overlayController.view.removeFromSuperview()
            overlayController.removeFromParent()
            overlayHostingController = nil
        }
        currentName = nil
        currentImageUrl = nil
        currentHasVideo = nil
    }

    private func addOverlay<Content: View>(@ViewBuilder content: () -> Content) {
        let swiftUIView = AnyView(content())
        let hostingController = UIHostingController(rootView: swiftUIView)
        overlayHostingController = hostingController

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        hostingController.view.isUserInteractionEnabled = false  // Allow touch events to pass through

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        hostingController.didMove(toParent: self)
    }

    func updateParticipantOverlay(
        name: String?, imageUrl: String?, connectionQuality: String, isMuted: Bool, hasVideo: Bool
    ) {
        updateParticipantOverlay(
            name: name, imageUrl: imageUrl, connectionQuality: connectionQuality,
            isMuted: isMuted, hasVideo: hasVideo,
            showParticipantName: true, showMicrophoneIndicator: true,
            showConnectionQualityIndicator: true
        )
    }

    func updateParticipantOverlay(
        name: String?, imageUrl: String?, connectionQuality: String, isMuted: Bool, hasVideo: Bool,
        showParticipantName: Bool, showMicrophoneIndicator: Bool,
        showConnectionQualityIndicator: Bool
    ) {
        let participantName = name ?? ""

        let needsUpdate =
            currentName != participantName || currentImageUrl != imageUrl
            || currentHasVideo != hasVideo

        if needsUpdate || overlayHostingController == nil {
            removeOverlay()
            addOverlay {
                PictureInPictureOverlayView(
                    name: participantName,
                    imageUrl: imageUrl,
                    connectionQuality: connectionQuality,
                    isMuted: isMuted,
                    hasVideo: hasVideo,
                    showParticipantName: showParticipantName,
                    showMicrophoneIndicator: showMicrophoneIndicator,
                    showConnectionQualityIndicator: showConnectionQualityIndicator
                )
            }
            currentName = participantName
            currentImageUrl = imageUrl
            currentHasVideo = hasVideo

            // Ensure proper layering after overlay update
            if hasVideo {
                view.bringSubviewToFront(contentView)
                if let overlayController = overlayHostingController {
                    view.bringSubviewToFront(overlayController.view)
                }
            }
        } else {
            // Just update the overlay's data without recreating the view
            if let controller = overlayHostingController {
                let updatedView = AnyView(
                    PictureInPictureOverlayView(
                        name: participantName,
                        imageUrl: imageUrl,
                        connectionQuality: connectionQuality,
                        isMuted: isMuted,
                        hasVideo: hasVideo,
                        showParticipantName: showParticipantName,
                        showMicrophoneIndicator: showMicrophoneIndicator,
                        showConnectionQualityIndicator: showConnectionQualityIndicator
                    )
                )
                controller.rootView = updatedView
            }
        }
    }

    // MARK: - Private helpers

    private func setUp() {
        view.subviews.forEach { $0.removeFromSuperview() }

        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        contentView.bounds = view.bounds
    }
}

// MARK: - SwiftUI Overlay Views

@available(iOS 15.0, *)
struct PictureInPictureOverlayView: View {
    let name: String
    let imageUrl: String?
    let connectionQuality: String
    let isMuted: Bool
    let hasVideo: Bool
    let showParticipantName: Bool
    let showMicrophoneIndicator: Bool
    let showConnectionQualityIndicator: Bool

    var body: some View {
        ZStack {
            if !hasVideo {
                Color.black
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if !hasVideo {
                if let urlString = imageUrl,
                    !urlString.isEmpty,
                    let url = URL(string: urlString)
                {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        avatarPlaceholder
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    avatarPlaceholder
                }
            }

            VStack {
                Spacer()
                HStack {
                    HStack(spacing: 4) {
                        if showParticipantName {
                            Text(name)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .font(Font.caption)
                                .minimumScaleFactor(0.7)
                        }

                        if showMicrophoneIndicator {
                            SoundIndicator(isMuted: isMuted)
                        }
                    }
                    .padding(.horizontal, 4)
                    .frame(height: 28)
                    .padding(4)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)

                    Spacer()

                    // Connection quality indicator on the right
                    if showConnectionQualityIndicator {
                        ConnectionQualityIndicator(connectionQuality: connectionQuality)
                    }
                }
            }
            // .padding(8)
        }
    }

    @ViewBuilder
    var avatarPlaceholder: some View {
        Circle()
            .fill(Color.blue.opacity(0.8))
            .frame(width: 80, height: 80)
            .overlay(
                Text(getInitials(from: name))
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.medium)
            )
    }

    private func getInitials(from name: String) -> String {
        let words = name.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        if words.isEmpty {
            return "N/A"
        } else if words.count == 1 {
            return String(words[0].prefix(2)).uppercased()
        } else {
            let firstInitial = String(words.first?.first ?? Character("?"))
            let lastInitial = String(words.last?.first ?? Character(""))
            return "\(firstInitial)\(lastInitial)".uppercased()
        }
    }
}

@available(iOS 15.0, *)
struct ConnectionQualityIndicator: View {

    private var size: CGFloat = 28
    private var width: CGFloat = 3

    var connectionQuality: String

    init(connectionQuality: String, size: CGFloat = 28, width: CGFloat = 3) {
        self.connectionQuality = connectionQuality
        self.size = size
        self.width = width
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(1..<4, id: \.self) { index in
                IndicatorPart(
                    width: width,
                    height: height(for: index),
                    color: color(for: index)
                )
            }
        }
        .frame(width: size, height: size)
        .padding(4)
        .background(
            connectionQuality == "unspecified" ? Color.clear : Color.black.opacity(0.6)
        )
        .cornerRadius(8)
        .accessibility(identifier: "connectionQualityIndicator")
    }

    private func color(for index: Int) -> Color {
        switch connectionQuality.lowercased() {
        case "excellent":
            return .green
        case "good":
            return index == 3 ? Color.white.opacity(0.3) : .green
        case "poor":
            return index == 1 ? .red : Color.white.opacity(0.3)
        default:  // "unspecified"
            return .gray.opacity(0.8)
        }
    }

    private func height(for part: Int) -> CGFloat {
        switch part {
        case 1:
            return width * 2
        case 2:
            return width * 3
        default:
            return width * 4
        }
    }
}

@available(iOS 15.0, *)
struct IndicatorPart: View {

    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        RoundedRectangle(cornerSize: .init(width: 2, height: 2))
            .fill(color)
            .frame(width: width, height: height)
    }
}

public struct SoundIndicator: View {

    let isMuted: Bool

    public init(isMuted: Bool) {
        self.isMuted = isMuted
    }

    public var body: some View {
        (!isMuted ? Image(systemName: "mic.fill") : Image(systemName: "mic.slash.fill"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 12, height: 12)
            .foregroundColor(!isMuted ? .white : Color(red: 1.0, green: 0.216, blue: 0.259))
            .accessibility(identifier: "participantMic")
            .accessibilityValue(!isMuted ? "1" : "0")
    }
}
