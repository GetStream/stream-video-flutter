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
///   actions: StreamLobbyActions.full(),
/// )
/// ```
/// {@end-tool}
///
/// The layout follows the window's [StreamScreenSize]: under 768px the
/// controls sit below the preview, above it they are overlaid on the preview
/// itself. Which actions are shown does *not* follow the screen — [actions]
/// defaults to `StreamLobbyActions.simple()` at every width, and choosing a richer
/// preset for a roomier window is the host's call.
///
/// A row of more than [StreamLobbyViewStyle.maxOverlaidControls] sits below
/// the preview at any width: the overlaid row is centred on a preview whose
/// bottom-start corner already carries the participant label, so a longer one
/// runs into it.
///
/// This builds no [Scaffold] of its own, so it can be embedded in a screen
/// that already has one. Wrap it in whatever chrome the app needs.
class StreamLobbyView extends StatefulWidget {
  /// Creates a lobby for [call], driven by a controller of its own.
  ///
  /// The controller is created and disposed here. Use
  /// [StreamLobbyView.withController] to keep the lobby's state outside the
  /// widget, or to read it from the host screen.
  const StreamLobbyView({
    super.key,
    required Call call,
    required this.onJoinCallPressed,
    this.actions,
    this.title,
    this.subtitle,
    this.joinButtonLabel,
    this.streamVideo,
  }) : _call = call,
       controller = null;

  /// Creates a lobby driven by [controller], which stays the caller's to
  /// dispose.
  ///
  /// The call comes from the controller, so there is no second one to
  /// disagree with it.
  const StreamLobbyView.withController({
    super.key,
    required StreamLobbyController this.controller,
    required this.onJoinCallPressed,
    this.actions,
    this.title,
    this.subtitle,
    this.joinButtonLabel,
  }) : _call = null,
       streamVideo = null;

  final Call? _call;

  /// The call this lobby is a waiting room for.
  Call get call => controller?.call ?? _call!;

  /// Called with the options the call should be joined with.
  ///
  /// The tracks in them are handed over: the lobby stops managing them, so
  /// whatever joins the call is responsible for their lifetime.
  final ValueSetter<CallConnectOptions> onJoinCallPressed;

  /// Which controls to show.
  ///
  /// Defaults to `StreamLobbyActions.simple()`.
  final StreamLobbyActions? actions;

  /// The heading above the preview. Defaults to a localized string.
  final Widget? title;

  /// An optional line below [title].
  ///
  /// Nothing is drawn when null: the design puts a single line under the icon,
  /// so a subtitle appears only where a call site asks for one.
  final Widget? subtitle;

  /// The label of the join button. Defaults to a localized string.
  final Widget? joinButtonLabel;

  /// The controller driving this lobby, or null when it owns one.
  ///
  /// Non-null only through [StreamLobbyView.withController], and then it is
  /// the caller's to dispose.
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
  void didUpdateWidget(StreamLobbyView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handed a different call, or handed a controller where it had been making
    // its own, the lobby has to let go of the one it owns — otherwise the
    // preview keeps running against the old call until this widget is
    // disposed. A controller whose tracks were handed over leaves them alone.
    final stale = widget.controller != null || widget._call != oldWidget._call;
    if (_ownedController case final owned? when stale) {
      owned.dispose();
      _ownedController = null;
    }
  }

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
    final actions = widget.actions ?? StreamLobbyActions.simple();

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

  final StreamLobbyActions actions;
  final Widget? title;
  final Widget? subtitle;
  final Widget? joinButtonLabel;
  final VoidCallback onJoinCallPressed;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final spacing = context.streamSpacing;
    final isSmall = context.streamScreenSize.isSmall;
    // Typed as the defaults class, not as the style: declaring it as the base
    // type would throw away the non-null overrides.
    final style = _StreamLobbyViewStyleDefaults(
      StreamLobbyViewTheme.of(context).style,
    );

    // The overlaid row is centred on a preview whose bottom-start corner is
    // taken by the participant label, so a long row runs into it. Past that
    // the row goes below the preview, however much width there is.
    final overlayControls =
        !isSmall && actions.controls.length <= style.maxOverlaidControls;

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
        StreamLobbyHeader(title: title, subtitle: subtitle),
        // The whole preview block is capped at the tile's width, so the
        // settings fields line up under it rather than running the width of
        // the window.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmall
                ? double.infinity
                : style.expandedPreviewSize.width,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: isSmall ? spacing.sm : spacing.md,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  const _LobbyPreview(),
                  // Above 768px a short row floats over the preview, clear
                  // of the participant label's toolbar band along the bottom.
                  if (overlayControls && controlRow != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: spacing.md),
                      child: controlRow,
                    ),
                ],
              ),
              if (!overlayControls && controlRow != null) controlRow,
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
          width: isSmall ? double.infinity : style.joinButtonWidth,
          child: StreamButton(
            onPressed: onJoinCallPressed,
            child: joinButtonLabel ?? Text(translations.lobbyJoinCall),
          ),
        ),
      ],
    );
  }
}

/// The camera preview: the participant tile the user is about to become.
///
/// Deliberately the same [StreamParticipantTile] the call draws, so the
/// surface, corner radius, name pill and placeholder avatar cannot drift from
/// the call's, and an app that themes its tiles themes this too. The tile is
/// handed its renderer directly because the lobby's track belongs to nobody
/// yet: it is warmed up locally and not registered with the call, so the
/// tile's usual lookup by session id would find nothing.
class _LobbyPreview extends StatelessWidget {
  const _LobbyPreview();

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final isSmall = context.streamScreenSize.isSmall;
    final style = _StreamLobbyViewStyleDefaults(
      StreamLobbyViewTheme.of(context).style,
    );

    final cameraTrack = controller.cameraTrack;

    final tile = StreamParticipantTile(
      call: controller.call,
      participant: controller.localParticipant,
      // Neither means anything before the call is joined: there is no
      // connection to rate and no reactions to receive. The speaking outline
      // is left on — it is simply never triggered, because the in-call
      // speaking state comes from the SFU and there is no local mic level yet
      // (FLU-714). When there is, the preview lights up with no change here.
      showConnectionQualityIndicator: false,
      showReaction: false,
      // Nobody has joined, so there is nothing to pin, mute or remove. An
      // app-wide `participantTile` builder that adds an overflow menu to every
      // tile would otherwise put one here too; suppressing it through the
      // style rather than the props means it survives that builder. Ordered so
      // previewTileStyle can put the button back if an app really wants it.
      style: const StreamParticipantTileStyle(
        showMoreButton: false,
        // Nothing reports a local audio level before joining, so the indicator
        // would sit there permanently idle. See FLU-714.
        labelStyle: StreamParticipantLabelStyle(showAudioIndicator: false),
      ).merge(style.previewTileStyle),
      videoRendererBuilder: (context, call, participant) {
        if (cameraTrack == null) {
          return StreamParticipantPlaceholder(
            call: call,
            participant: participant,
          );
        }

        return VideoTrackRenderer(
          videoTrack: cameraTrack,
          mirror: cameraTrack.mediaConstraints.facingMode == FacingMode.user,
          placeholderBuilder: (context) => StreamParticipantPlaceholder(
            call: call,
            participant: participant,
          ),
        );
      },
    );

    if (isSmall) {
      return AspectRatio(
        aspectRatio: style.compactPreviewAspectRatio,
        child: tile,
      );
    }

    final size = style.expandedPreviewSize;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width),
      child: AspectRatio(aspectRatio: size.aspectRatio, child: tile),
    );
  }
}

/// The values a [StreamLobbyViewStyle] falls back to.
///
/// Every getter is non-null and derived from the design, so a style that
/// overrides one property inherits the rest. Never let an instance of this
/// reach a theme: the generated `merge` would force every field.
class _StreamLobbyViewStyleDefaults extends StreamLobbyViewStyle {
  const _StreamLobbyViewStyleDefaults(this._style);

  final StreamLobbyViewStyle? _style;

  @override
  StreamParticipantTileStyle? get previewTileStyle => _style?.previewTileStyle;

  @override
  double get compactPreviewAspectRatio =>
      _style?.compactPreviewAspectRatio ?? 370 / 264;

  @override
  Size get expandedPreviewSize =>
      _style?.expandedPreviewSize ?? const Size(640, 360);

  @override
  int get maxOverlaidControls => _style?.maxOverlaidControls ?? 3;

  @override
  double get joinButtonWidth => _style?.joinButtonWidth ?? 400;
}
