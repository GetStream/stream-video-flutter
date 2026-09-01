import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// The waiting room shown before a call is joined: a preview of the local
/// camera, the controls that set the microphone and camera up, and a button
/// that joins.
///
/// Everything the lobby knows lives in a [StreamLobbyController], installed
/// above the tree as a [StreamLobbyScope]. The widgets in [actions] read it
/// from there, so a lobby is configured by saying which actions to show rather
/// than by wiring callbacks:
///
/// {@tool snippet}
///
/// ```dart
/// StreamLobbyView(
///   call: call,
///   onJoinCallPressed: (options) => call.join(connectOptions: options),
///   actions: LobbyActions.full(),
/// )
/// ```
/// {@end-tool}
///
/// The layout follows the window's [StreamScreenSize]: under 768px the
/// controls sit below the preview, above it they are overlaid on the preview
/// itself. Which actions are shown does *not* follow the screen — [actions]
/// defaults to `LobbyActions.simple()` at every width, and choosing a richer
/// preset for a roomier window is the host's call.
///
/// This builds no [Scaffold] of its own, so it can be embedded in a screen
/// that already has one. Wrap it in whatever chrome the app needs.
class StreamLobbyView extends StatefulWidget {
  /// Creates a new instance of [StreamLobbyView].
  const StreamLobbyView({
    super.key,
    required this.call,
    required this.onJoinCallPressed,
    this.actions,
    this.title,
    this.subtitle,
    this.joinButtonLabel,
    this.controller,
    this.streamVideo,
  });

  /// Represents a call.
  final Call call;

  /// Called with the options the call should be joined with.
  ///
  /// The tracks in them are handed over: the lobby stops managing them, so
  /// whatever joins the call is responsible for their lifetime.
  final ValueSetter<CallConnectOptions> onJoinCallPressed;

  /// Which controls to show.
  ///
  /// Defaults to `LobbyActions.simple()`.
  final LobbyActions? actions;

  /// The heading above the preview. Defaults to a localized string.
  final Widget? title;

  /// The line below [title]. Defaults to a localized string.
  final Widget? subtitle;

  /// The label of the join button. Defaults to a localized string.
  final Widget? joinButtonLabel;

  /// The controller driving this lobby.
  ///
  /// One is created and disposed here when this is null. Supply one to keep
  /// the lobby's state outside the widget, or to read it from the host screen.
  final StreamLobbyController? controller;

  /// An instance of [StreamVideo].
  ///
  /// If not provided, it will be obtained via StreamVideo.instance.
  final StreamVideo? streamVideo;

  @override
  State<StreamLobbyView> createState() => _StreamLobbyViewState();
}

class _StreamLobbyViewState extends State<StreamLobbyView> {
  StreamLobbyController? _ownedController;

  StreamLobbyController get _controller =>
      widget.controller ?? (_ownedController ??= _createController());

  StreamLobbyController _createController() => StreamLobbyController(
    call: widget.call,
    streamVideo: widget.streamVideo,
  );

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  void _onJoinCallPressed() {
    final options = _controller.connectOptions;
    // The tracks are now the call's; disposing the lobby must not stop them.
    _controller.handOverTracks();
    widget.onJoinCallPressed(options);
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actions ?? LobbyActions.simple();

    return StreamLobbyScope(
      controller: _controller,
      child: _LobbyBody(
        actions: actions,
        title: widget.title,
        subtitle: widget.subtitle,
        joinButtonLabel: widget.joinButtonLabel,
        onJoinCallPressed: _onJoinCallPressed,
      ),
    );
  }
}

/// The lobby's layout, below the scope so it can read the controller.
class _LobbyBody extends StatelessWidget {
  const _LobbyBody({
    required this.actions,
    required this.title,
    required this.subtitle,
    required this.joinButtonLabel,
    required this.onJoinCallPressed,
  });

  final LobbyActions actions;
  final Widget? title;
  final Widget? subtitle;
  final Widget? joinButtonLabel;
  final VoidCallback onJoinCallPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final translations = context.translations;
    final isSmall = context.streamScreenSize.isSmall;

    final controlRow = actions.controls.isEmpty
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: spacing.xs,
            children: actions.controls,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing.xxl,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing.sm,
          children: [
            title ?? Text(translations.lobbyTitle, style: textTheme.headingMd),
            subtitle ??
                Text(translations.lobbySubtitle, style: textTheme.bodyDefault),
          ],
        ),
        // The whole preview block is capped at the tile's width, so the
        // settings fields line up under it rather than running the width of
        // the window.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmall ? double.infinity : _LobbyPreview.largeWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: isSmall ? spacing.sm : spacing.md,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  const _LobbyPreview(),
                  // Above 768px the controls float over the preview, clear of
                  // the participant label's toolbar band along the bottom.
                  if (!isSmall && controlRow != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: spacing.md),
                      child: controlRow,
                    ),
                ],
              ),
              if (isSmall && controlRow != null) controlRow,
              if (actions.settings.isNotEmpty)
                Row(
                  spacing: spacing.xs,
                  children: [
                    for (final setting in actions.settings)
                      Expanded(child: setting),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          // Full width on a phone, a fixed 400 where there is room for it.
          width: isSmall ? double.infinity : 400,
          child: StreamButton(
            onPressed: onJoinCallPressed,
            child: joinButtonLabel ?? Text(translations.lobbyJoinCall),
          ),
        ),
      ],
    );
  }
}

/// The camera preview, with the local participant's label along its bottom.
class _LobbyPreview extends StatelessWidget {
  const _LobbyPreview();

  /// The aspect the design gives the preview under 768px.
  static const _smallAspectRatio = 370 / 264;

  /// The size the design gives the preview at 768px and above.
  static const _largeSize = Size(640, 360);

  /// The width the preview block is capped at above 768px.
  static double get largeWidth => _largeSize.width;

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final colorScheme = context.streamColorScheme;
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final isSmall = context.streamScreenSize.isSmall;

    final borderRadius = BorderRadius.all(radius.xxl);
    final cameraTrack = controller.cameraTrack;

    Widget placeholder(BuildContext context) =>
        Center(child: StreamUserAvatar(user: controller.currentUser));

    final preview = DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.backgroundSurface,
        borderRadius: borderRadius,
        border: Border.all(color: colorScheme.accentPrimary, width: 2),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: cameraTrack == null
                  ? placeholder(context)
                  : VideoTrackRenderer(
                      videoTrack: cameraTrack,
                      mirror:
                          cameraTrack.mediaConstraints.facingMode ==
                          FacingMode.user,
                      placeholderBuilder: placeholder,
                    ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                padding: EdgeInsets.all(spacing.sm),
                child: StreamParticipantLabel(
                  name: controller.currentUser.name,
                  isAudioEnabled: controller.microphoneEnabled,
                  isSpeaking: false,
                  isVideoEnabled: controller.cameraEnabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isSmall) {
      return AspectRatio(aspectRatio: _smallAspectRatio, child: preview);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: _largeSize.width),
      child: AspectRatio(
        aspectRatio: _largeSize.aspectRatio,
        child: preview,
      ),
    );
  }
}
