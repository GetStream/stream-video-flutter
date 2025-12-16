import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_participants/screen_share_call_participants_content.dart';
import '../call_screen/call_diagnostics_content/call_diagnostics_content.dart';
import '../l10n/localization_extension.dart';

typedef LivestreamHostsUnavailableBuilder =
    Widget Function(
      BuildContext context,
      LivestreamHostsUnavailableProperties properties,
    );

class LivestreamHostsUnavailableProperties {
  LivestreamHostsUnavailableProperties(this.call);

  final Call call;
}

class LivestreamFastReconnectingProperties {
  LivestreamFastReconnectingProperties(this.call);

  final Call call;
}

class LivestreamHostsParticipantProperties {
  LivestreamHostsParticipantProperties({
    required this.call,
    required this.hosts,
  });

  final Call call;
  final List<CallParticipantState> hosts;
}

typedef LivestreamNotConnectedBuilder =
    Widget Function(
      BuildContext context,
      LivestreamNotConnectedProperties properties,
    );

typedef LivestreamFastReconnectingOverlayBuilder =
    Widget Function(
      BuildContext context,
      LivestreamFastReconnectingProperties properties,
    );

typedef LivestreamHostsParticipantBuilder =
    Widget Function(
      BuildContext context,
      LivestreamHostsParticipantProperties properties,
    );

typedef LivestreamHostsParticipantsFilter =
    List<CallParticipantState> Function(
      List<CallParticipantState> allCallParticipants,
    );

class LivestreamNotConnectedProperties {
  LivestreamNotConnectedProperties(
    this.call, {
    required this.isMigrating,
    required this.isReconnecting,
  });

  final Call call;
  final bool isMigrating;
  final bool isReconnecting;
}

/// The video renderer widget associated with [LivestreamPlayer].
///
/// This widget also contains a diagnostic widget that can be used by
/// double-tapping the whole widget.
///
/// Additionally, there is an action button meant for a back/close action
/// implemented in this widget.
class LivestreamContent extends StatefulWidget {
  /// Creates a [LivestreamContent] widget.
  ///
  /// * [call] is the livestream call intended to be viewed.
  ///
  /// * [callState] is the livestream call state.
  ///
  /// * [backButtonBuilder] allows you to build a back/close button for closing
  /// the livestream.
  ///
  /// * [videoPlaceholderBuilder] allows you to build a video placeholder for the
  /// video renderer. This is useful when the video is not available or
  /// disconnected. By default, it uses the [StreamUserAvatar] widget
  ///
  /// * [videoRendererBuilder] allows you to build a custom video renderer
  ///
  /// * [livestreamHostsUnavailableBuilder] allows you to build a custom widget when
  /// a livestream is connected but no hosts have video enabled.
  ///
  /// * [livestreamNotConnectedBuilder] allows you to build a custom widget when
  /// the livestream is not connected. Provides connection state information.
  ///
  /// * [displayDiagnostics] displays call diagnostics when the widget is
  /// double-tapped.
  ///
  /// * [videoFit] denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  const LivestreamContent({
    super.key,
    required this.call,
    @Deprecated(PartialStateDeprecationMessage.callState) this.callState,
    this.backButtonBuilder,
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.livestreamHostsUnavailableBuilder,
    this.livestreamNotConnectedBuilder,
    this.livestreamFastReconnectingOverlayBuilder,
    this.livestreamHostsParticipantBuilder,
    this.livestreamHostsParticipantsFilter,
    this.displayDiagnostics = false,
    this.videoFit = VideoFit.contain,
    this.showMultipleHosts = false,
    this.layoutMode = ParticipantLayoutMode.grid,
    this.screenShareMode = LivestreamScreenShareMode.spotlight,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
  });

  /// Represents a call.
  final Call call;

  /// Holds information about the call.
  @Deprecated(PartialStateDeprecationMessage.callState)
  final CallState? callState;

  /// [WidgetBuilder] used to build an action button on the top left side of
  /// the screen.
  final WidgetBuilder? backButtonBuilder;

  /// The builder used to create a custom widget for the video placeholder.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  final VideoRendererBuilder? videoRendererBuilder;

  /// Builder function used to create a custom widget when a livestream is connected
  /// but no hosts have video enabled.
  final LivestreamHostsUnavailableBuilder? livestreamHostsUnavailableBuilder;

  /// Builder function used to create a custom widget when the livestream is not connected.
  /// Provides connection state information (isMigrating, isReconnecting) that can be
  /// used to show appropriate status messages.
  final LivestreamNotConnectedBuilder? livestreamNotConnectedBuilder;

  /// Builder function used to create a custom widget when the livestream is fast reconnecting.
  final LivestreamFastReconnectingOverlayBuilder?
  livestreamFastReconnectingOverlayBuilder;

  /// Builder function used to create a custom widget displaying the hosts video.
  final LivestreamHostsParticipantBuilder? livestreamHostsParticipantBuilder;

  /// Function used to select the hosts from all the call participants.
  /// If null, participants that have video enabled will be treated as hosts.
  /// If [showMultipleHosts] is false, only the first streaming participant will be shown.
  final LivestreamHostsParticipantsFilter? livestreamHostsParticipantsFilter;

  /// Boolean to allow a user to double-tap a call to see diagnostic data.
  ///
  /// Defaults to false.
  final bool displayDiagnostics;

  /// Denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  final VideoFit videoFit;

  /// Configuration for picture-in-picture mode.
  final PictureInPictureConfiguration pictureInPictureConfiguration;

  /// Denotes if multiple hosts are allowed to be displayed.
  /// Used with default [livestreamHostsParticipantBuilder] to display the hosts video.
  ///
  /// If yes, use [layoutMode] to set the participants layout.
  /// If no, only the first streaming participant will be shown.
  ///
  /// Defaults to false.
  final bool showMultipleHosts;

  /// The layout mode used to display the hosts when [showMultipleHosts] is true.
  final ParticipantLayoutMode layoutMode;

  /// The screen share mode used to display the screen share host.
  final LivestreamScreenShareMode screenShareMode;

  @override
  State<LivestreamContent> createState() => _LivestreamContentState();
}

class _LivestreamContentState extends State<LivestreamContent> {
  /// Represents a call.
  Call get call => widget.call;

  /// Denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  VideoFit get videoFit => widget.videoFit;

  LivestreamHostsParticipantsFilter get _defaultStreamingParticipantsFilter =>
      (allCallParticipants) =>
          allCallParticipants.where((e) => e.isVideoEnabled).toList();

  CallParticipantBuilder get _defaultParticipantBuilder =>
      (context, call, participant) => StreamCallParticipant(
        call: call,
        participant: participant,
        backgroundColor: StreamVideoTheme.of(
          context,
        ).colorTheme.livestreamBackground,
        key: ValueKey(participant.uniqueParticipantKey),
        showConnectionQualityIndicator: false,
        showParticipantLabel: false,
        showSpeakerBorder: false,
        videoFit: videoFit,
        videoRendererBuilder: widget.videoRendererBuilder,
        videoPlaceholderBuilder: widget.videoPlaceholderBuilder,
      );

  LivestreamHostsParticipantBuilder get _defaultHostsParticipantBuilder =>
      (context, properties) => StreamLivestreamHosts(
        call: properties.call,
        layoutMode: widget.showMultipleHosts
            ? widget.layoutMode
            : ParticipantLayoutMode.spotlight,
        screenShareMode: widget.screenShareMode,
        hosts: widget.showMultipleHosts
            ? properties.hosts
            : [properties.hosts.first],
        callParticipantBuilder: _defaultParticipantBuilder,
        screenShareContentBuilder: (context, call, participant) =>
            ScreenShareContent(
              call: call,
              participant: participant,
              backgroundColor: StreamVideoTheme.of(
                context,
              ).colorTheme.livestreamBackground,
            ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final translations = context.translations;

    final pipEnabled =
        widget.pictureInPictureConfiguration.enablePictureInPicture;

    return PartialCallStateBuilder(
      call: call,
      selector: (state) =>
          (callParticipants: state.callParticipants, status: state.status),
      builder: (context, callData) {
        final participants = callData.callParticipants;
        final status = callData.status;

        late Widget bodyWidget;
        if (status.isConnected ||
            status.isFastReconnecting ||
            status.isMigrating) {
          final streamingParticipants =
              widget.livestreamHostsParticipantsFilter?.call(participants) ??
              _defaultStreamingParticipantsFilter(participants);

          if (streamingParticipants.isEmpty) {
            bodyWidget =
                widget.livestreamHostsUnavailableBuilder?.call(
                  context,
                  LivestreamHostsUnavailableProperties(call),
                ) ??
                Center(
                  child: Text(
                    translations.livestreamHostNotAvailable,
                    style: theme.livestreamTheme.callStateButtonTextStyle,
                  ),
                );
          } else {
            bodyWidget = Stack(
              children: [
                if (CurrentPlatform.isIos && pipEnabled)
                  SizedBox(
                    height: 600,
                    width: 300,
                    child: StreamPictureInPictureUiKitView(
                      call: call,
                      pictureInPictureConfiguration:
                          widget.pictureInPictureConfiguration,
                    ),
                  ),
                if (CurrentPlatform.isAndroid && pipEnabled)
                  StreamPictureInPictureAndroidView(
                    call: call,
                    configuration: widget.pictureInPictureConfiguration,
                  ),
                widget.livestreamHostsParticipantBuilder?.call(
                      context,
                      LivestreamHostsParticipantProperties(
                        call: call,
                        hosts: streamingParticipants,
                      ),
                    ) ??
                    _defaultHostsParticipantBuilder(
                      context,
                      LivestreamHostsParticipantProperties(
                        call: call,
                        hosts: streamingParticipants,
                      ),
                    ),
                if (status.isFastReconnecting)
                  widget.livestreamFastReconnectingOverlayBuilder?.call(
                        context,
                        LivestreamFastReconnectingProperties(call),
                      ) ??
                      const Positioned(
                        top: 25,
                        left: 25,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
              ],
            );
          }
        } else {
          final isMigrating = status.isMigrating;
          final isReconnecting = status.isReconnecting;
          final statusText = isReconnecting ? 'Reconnecting' : 'Connecting';

          bodyWidget =
              widget.livestreamNotConnectedBuilder?.call(
                context,
                LivestreamNotConnectedProperties(
                  call,
                  isMigrating: isMigrating,
                  isReconnecting: isReconnecting,
                ),
              ) ??
              Center(
                child: Text(
                  statusText,
                  style: theme.livestreamTheme.callStateButtonTextStyle,
                ),
              );
        }

        return Scaffold(
          backgroundColor: theme.colorTheme.livestreamBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: widget.backButtonBuilder?.call(context),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              bodyWidget,
              if (widget.displayDiagnostics) CallDiagnosticsContent(call: call),
            ],
          ),
        );
      },
    );
  }
}
