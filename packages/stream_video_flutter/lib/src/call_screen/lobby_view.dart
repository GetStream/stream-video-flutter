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
    final translations = context.translations;
    final isSmall = context.streamScreenSize.isSmall;
    // Typed as the defaults class, not as the style: declaring it as the base
    // type would throw away the non-null overrides.
    final style = _StreamLobbyViewStyleDefaults(
      context,
      StreamLobbyViewTheme.of(context).style,
    );

    final controlRow = actions.controls.isEmpty
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: style.controlSpacing,
            children: actions.controls,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: style.sectionSpacing,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: style.headingSpacing,
          children: [
            title ?? Text(translations.lobbyTitle, style: style.titleTextStyle),
            subtitle ??
                Text(
                  translations.lobbySubtitle,
                  style: style.subtitleTextStyle,
                ),
          ],
        ),
        // The whole preview block is capped at the tile's width, so the
        // settings fields line up under it rather than running the width of
        // the window.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmall ? double.infinity : style.largePreviewSize.width,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: isSmall ? style.smallLaneSpacing : style.largeLaneSpacing,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  const _LobbyPreview(),
                  // Above 768px the controls float over the preview, clear of
                  // the participant label's toolbar band along the bottom.
                  if (!isSmall && controlRow != null)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: style.overlayControlInset,
                      ),
                      child: controlRow,
                    ),
                ],
              ),
              if (isSmall && controlRow != null) controlRow,
              if (actions.settings.isNotEmpty)
                Row(
                  spacing: style.settingSpacing,
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

/// The camera preview, with the local participant's label along its bottom.
class _LobbyPreview extends StatelessWidget {
  const _LobbyPreview();

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final isSmall = context.streamScreenSize.isSmall;
    final style = _StreamLobbyViewStyleDefaults(
      context,
      StreamLobbyViewTheme.of(context).style,
    );

    final borderRadius = style.previewBorderRadius;
    final cameraTrack = controller.cameraTrack;

    Widget placeholder(BuildContext context) =>
        Center(child: StreamUserAvatar(user: controller.currentUser));

    final preview = DecoratedBox(
      decoration: BoxDecoration(
        color: style.previewBackgroundColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: style.previewBorderColor,
          width: style.previewBorderWidth,
        ),
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
                padding: EdgeInsets.all(style.participantLabelInset),
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
      return AspectRatio(
        aspectRatio: style.smallPreviewAspectRatio,
        child: preview,
      );
    }

    final size = style.largePreviewSize;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width),
      child: AspectRatio(aspectRatio: size.aspectRatio, child: preview),
    );
  }
}

/// The values a [StreamLobbyViewStyle] falls back to.
///
/// Every getter is non-null and derived from the ambient design tokens, so a
/// style that overrides one property inherits the rest. Never let an instance
/// of this reach a theme: the generated `merge` would force every field.
class _StreamLobbyViewStyleDefaults extends StreamLobbyViewStyle {
  _StreamLobbyViewStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamLobbyViewStyle? _style;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;
  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;

  @override
  BorderRadius get previewBorderRadius =>
      _style?.previewBorderRadius ?? BorderRadius.all(_radius.xxl);

  @override
  Color get previewBorderColor =>
      _style?.previewBorderColor ?? _colorScheme.accentPrimary;

  @override
  double get previewBorderWidth => _style?.previewBorderWidth ?? 2;

  @override
  Color get previewBackgroundColor =>
      _style?.previewBackgroundColor ?? _colorScheme.backgroundSurface;

  @override
  double get smallPreviewAspectRatio =>
      _style?.smallPreviewAspectRatio ?? 370 / 264;

  @override
  Size get largePreviewSize => _style?.largePreviewSize ?? const Size(640, 360);

  @override
  double get sectionSpacing => _style?.sectionSpacing ?? _spacing.xxl;

  @override
  double get headingSpacing => _style?.headingSpacing ?? _spacing.sm;

  @override
  double get smallLaneSpacing => _style?.smallLaneSpacing ?? _spacing.sm;

  @override
  double get largeLaneSpacing => _style?.largeLaneSpacing ?? _spacing.md;

  @override
  double get controlSpacing => _style?.controlSpacing ?? _spacing.xs;

  @override
  double get settingSpacing => _style?.settingSpacing ?? _spacing.xs;

  @override
  double get overlayControlInset => _style?.overlayControlInset ?? _spacing.md;

  @override
  double get participantLabelInset =>
      _style?.participantLabelInset ?? _spacing.sm;

  @override
  double get joinButtonWidth => _style?.joinButtonWidth ?? 400;

  @override
  TextStyle get titleTextStyle =>
      _style?.titleTextStyle ?? _textTheme.headingMd;

  @override
  TextStyle get subtitleTextStyle =>
      _style?.subtitleTextStyle ?? _textTheme.bodyDefault;
}
