import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'layout/call_participants_spotlight_view.dart';

/// A widget that represents the main area of the call when somebody is
/// sharing their screen.
class ScreenShareCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [ScreenShareCallParticipantsContent].
  const ScreenShareCallParticipantsContent({
    super.key,
    required this.call,
    required this.screenSharingParticipant,
    required this.participants,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder = _defaultParticipantBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant that is sharing their screen.
  final CallParticipantState screenSharingParticipant;

  /// The list of other participants to display.
  final Iterable<CallParticipantState> participants;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder screenShareParticipantBuilder;

  // The default participant builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState participant,
  ) {
    return StreamCallParticipant(
      key: ValueKey(participant.uniqueParticipantKey),
      call: call,
      participant: participant,
    );
  }

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 16 / 9;

    final windowSize = MediaQuery.sizeOf(context);
    final isWideWindow = windowSize.width / windowSize.height > aspectRatio;

    return CallParticipantsSpotlightView(
      call: call,
      spotlight: screenSharingParticipant,
      participants: participants,
      participantBuilder: screenShareParticipantBuilder,
      barAlignment: isWideWindow
          ? ParticipantsBarAlignment.right
          : ParticipantsBarAlignment.bottom,
      spotlightBuilder: (context, call, participant) {
        final screenShareContentBuilder = this.screenShareContentBuilder;
        if (screenShareContentBuilder != null) {
          return screenShareContentBuilder.call(context, call, participant);
        }

        final videoTheme = StreamVideoTheme.of(context);
        final colorTheme = videoTheme.colorTheme;

        final participantName = participant.name;

        return Stack(
          children: [
            ScreenShareContent(
              key: ValueKey(
                '${participant.uniqueParticipantKey} - screenShareContent',
              ),
              call: call,
              participant: participant,
            ),
            FittedBox(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: colorTheme.barsBg.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.screen_share_rounded,
                      color: colorTheme.textHighEmphasis,
                    ),
                    const SizedBox(width: 8),
                    // TODO localize hardcoded text
                    Text(
                      '$participantName is sharing their screen',
                      style: videoTheme.textTheme.footnote,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A widget that renders a screen sharing track in the screen.
class ScreenShareContent extends StatefulWidget {
  /// Creates a new instance of [ScreenShareContent].
  const ScreenShareContent({
    super.key,
    required this.call,
    required this.participant,
    this.backgroundColor = const Color(0xFF272A30),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  /// Represents a call.
  final Call call;

  /// The participant that shares their screen.
  final CallParticipantState participant;

  /// The background color for the video.
  final Color backgroundColor;

  /// The border radius to apply to the content.
  final BorderRadius borderRadius;

  @override
  State<ScreenShareContent> createState() => _ScreenShareContentState();
}

class _ScreenShareContentState extends State<ScreenShareContent> {
  bool _isZoomed = false;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final screenShareTrack = widget.participant.screenShareTrack;

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: ColoredBox(
        color: widget.backgroundColor,
        child: Builder(
          builder: (context) {
            if (screenShareTrack == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorTheme.accentPrimary,
                ),
              );
            }

            return InteractiveViewer(
              maxScale: 4,
              onInteractionUpdate: (details) {
                final isZoomed = details.scale > 1.0;
                if (_isZoomed != isZoomed) {
                  setState(() {
                    _isZoomed = isZoomed;
                  });
                }
              },
              child: StreamVideoRenderer(
                call: widget.call,
                participant: widget.participant,
                videoFit: VideoFit.contain,
                videoTrackType: SfuTrackType.screenShare,
                persistTrackIfNotVisible: _isZoomed,
              ),
            );
          },
        ),
      ),
    );
  }
}
