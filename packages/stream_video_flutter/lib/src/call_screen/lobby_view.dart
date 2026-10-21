import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// Joins the call the lobby is a waiting room for, with the options it
/// prepared.
///
/// Returns whether the join happened. See
/// [StreamLobbyView.onJoinCallPressed].
typedef StreamLobbyJoinCallback =
    FutureOr<bool> Function(CallConnectOptions options);

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
///   onJoinCallPressed: (options) async {
///     await call.join(connectOptions: options);
///     return true;
///   },
///   actions: StreamLobbyActions.full(),
/// )
/// ```
/// {@end-tool}
///
/// The layout follows the window's [StreamScreenSize]: at
/// [StreamScreenSize.small] the controls sit below the preview, above it they
/// are overlaid on the preview itself. A landscape window shorter than
/// [sideBySideMaxHeight] puts the preview beside the rest instead of above
/// it. The lobby keeps clear of the ambient safe-area
/// insets. Which actions are shown does *not* follow the screen — [actions]
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
    this.joinEnabled = true,
    this.footer,
  }) : _call = call,
       controller = null;

  /// Creates a lobby driven by [controller], which stays the caller's to
  /// dispose.
  ///
  /// [call] comes from the controller.
  const StreamLobbyView.withController({
    super.key,
    required StreamLobbyController this.controller,
    required this.onJoinCallPressed,
    this.actions,
    this.title,
    this.subtitle,
    this.joinButtonLabel,
    this.joinEnabled = true,
    this.footer,
  }) : _call = null;

  final Call? _call;

  /// Landscape windows shorter than this put the preview beside the rest of
  /// the lobby: stacked, the join button would fall below the window.
  static const sideBySideMaxHeight = 800.0;

  /// The call this lobby is a waiting room for.
  Call get call => controller?.call ?? _call!;

  /// Called with the options the call should be joined with.
  ///
  /// The tracks in them are handed over before this runs: the lobby stops
  /// managing them, so whatever joins the call is responsible for their
  /// lifetime.
  ///
  /// Return true once the call has been joined, or once whoever joins it has
  /// been handed the options. Return false to say the join did not happen —
  /// the lobby takes its tracks back and carries on previewing, so a call
  /// that could not be created, or a key that turned out to be wrong, leaves
  /// the user where they were.
  final StreamLobbyJoinCallback onJoinCallPressed;

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

  /// Whether the join button can be pressed. Defaults to true.
  ///
  /// Set it from whatever the lobby is still waiting for — a shared
  /// encryption key, a name, a call that is being created.
  final bool joinEnabled;

  /// Drawn between the controls and the join button, through
  /// [StreamLobbyFooter].
  ///
  /// Nothing is drawn when null and no `lobbyFooter` builder is registered.
  /// Use it for whatever a call has to be set up with that the lobby knows
  /// nothing about.
  final Widget? footer;

  /// The controller driving this lobby, or null when it owns one.
  ///
  /// Non-null only through [StreamLobbyView.withController], and then it is
  /// the caller's to dispose.
  final StreamLobbyController? controller;

  @override
  State<StreamLobbyView> createState() => _StreamLobbyViewState();
}

class _StreamLobbyViewState extends State<StreamLobbyView> {
  late final _logger = taggedLogger(tag: 'SV:LobbyView');

  StreamLobbyController? _ownedController;

  StreamLobbyController get _controller =>
      widget.controller ?? (_ownedController ??= _createController());

  StreamLobbyController _createController() =>
      StreamLobbyController(call: widget.call);

  @override
  void didUpdateWidget(StreamLobbyView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A controller this lobby made is only good for the call it was made
    // for, and is redundant once one is supplied. Disposing it stops the
    // preview; a controller whose tracks were handed over keeps them.
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

  /// Whether a join is already running. A second tap would hand the tracks
  /// over twice and run the host's callback again.
  bool _joining = false;

  Future<void> _onJoinCallPressed() async {
    if (_joining) return;
    _joining = true;

    final controller = _controller;
    final options = controller.connectOptions;

    // Handed over before the callback rather than after it: a host usually
    // navigates from inside it, and the lobby is disposed on the way out —
    // with the tracks still its own, that would stop the microphone and
    // camera the call is about to publish.
    controller.handOverTracks();

    var joined = false;
    try {
      joined = await widget.onJoinCallPressed(options);
    } catch (e, stk) {
      _logger.e(() => 'Error joining the call: $e\n$stk');
    } finally {
      _joining = false;
      // Read off the controller, not off `mounted`: the lobby can be gone
      // already — a host navigating away while its join is in flight — and
      // the tracks handed over to a join that never happened would then be
      // left running with nothing to stop them.
      if (!joined) controller.reclaimTracks();
    }
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
        joinEnabled: widget.joinEnabled,
        footer: widget.footer,
        // Explicitly unawaited: the button wants a VoidCallback, and letting
        // the future be dropped implicitly would drop its errors with it.
        onJoinCallPressed: () => unawaited(_onJoinCallPressed()),
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
    required this.joinEnabled,
    required this.footer,
    required this.onJoinCallPressed,
  });

  final StreamLobbyActions actions;
  final Widget? title;
  final Widget? subtitle;
  final Widget? joinButtonLabel;
  final bool joinEnabled;
  final Widget? footer;
  final VoidCallback onJoinCallPressed;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);
    final isSmall = StreamScreenSize.fromSize(windowSize).isSmall;
    // Typed as the defaults class, not as the style: declaring it as the base
    // type would throw away the non-null overrides.
    final style = _StreamLobbyViewStyleDefaults(
      StreamLobbyViewTheme.of(context).style,
    );

    // A short window in landscape has no height for the preview and the rest
    // stacked under it, so the two go side by side.
    final sideBySide =
        windowSize.height < StreamLobbyView.sideBySideMaxHeight &&
        windowSize.width > windowSize.height;

    // The overlaid row is centred on a preview whose bottom-start corner is
    // taken by the participant label, so a long row runs into it. Past that
    // the row goes below the preview, however much width there is.
    final overlayControls =
        !isSmall && actions.controls.length <= style.maxOverlaidControls;

    // A small window gives the preview at most this much of its height, so
    // a tall preview cannot push the join button off the screen.
    final compactPreviewMaxHeight =
        windowSize.height * (sideBySide ? 0.6 : 0.4);

    final controlRow = _controlRow();
    final parts = (
      preview: _preview(
        context,
        overlaidControls: overlayControls ? controlRow : null,
        compactMaxHeight: compactPreviewMaxHeight,
      ),
      controlsBelow: overlayControls ? null : controlRow,
      settingsRow: _settingsRow(context),
      footer: _footer(context),
      joinButton: _joinButton(context),
    );

    return SafeArea(
      child: sideBySide
          ? _sideBySide(context, parts)
          : _stacked(
              context,
              parts,
              isSmall: isSmall,
              previewMaxWidth: isSmall
                  ? compactPreviewMaxHeight * style.compactPreviewAspectRatio
                  : style.expandedPreviewSize.width,
              joinButtonWidth: isSmall
                  ? double.infinity
                  : style.joinButtonWidth,
            ),
    );
  }

  /// The controls in a row, or null when there are none.
  Widget? _controlRow() {
    if (actions.controls.isEmpty) return null;

    // No spacing: each control's tap target already pads it on either side,
    // which together make the gap the design draws.
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: actions.controls,
    );
  }

  /// The settings side by side, or null when there are none.
  Widget? _settingsRow(BuildContext context) {
    if (actions.settings.isEmpty) return null;

    return Row(
      spacing: context.streamSpacing.xs,
      children: [
        for (final setting in actions.settings) Expanded(child: setting),
      ],
    );
  }

  /// The preview, with [overlaidControls] floating over its bottom edge.
  Widget _preview(
    BuildContext context, {
    required Widget? overlaidControls,
    required double compactMaxHeight,
  }) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        _LobbyPreview(compactMaxHeight: compactMaxHeight),
        // Past small, a short row floats over the preview, clear of the
        // participant label's toolbar band along the bottom.
        if (overlaidControls != null)
          Padding(
            padding: EdgeInsets.only(bottom: context.streamSpacing.md),
            child: overlaidControls,
          ),
      ],
    );
  }

  /// The footer, or null when there is nothing to draw: no footer from the
  /// call site, and no app-wide builder that supplies its own. Otherwise the
  /// Column's spacing would leave a gap for an empty slot.
  Widget? _footer(BuildContext context) {
    final footerBuilder = context
        .videoComponentBuilder<StreamLobbyFooterProps>();
    if (footer == null && footerBuilder == null) return null;
    return StreamLobbyFooter(child: footer);
  }

  Widget _joinButton(BuildContext context) => StreamButton(
    onPressed: joinEnabled ? onJoinCallPressed : null,
    child: joinButtonLabel ?? Text(context.translations.lobbyJoinCall),
  );

  /// The preview and its controls on one side, the rest on the other.
  Widget _sideBySide(BuildContext context, _LobbyParts parts) {
    final spacing = context.streamSpacing;

    return Row(
      spacing: spacing.xl,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.sm,
            children: [parts.preview, ?parts.controlsBelow],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacing.lg,
            children: [
              StreamLobbyHeader(title: title, subtitle: subtitle),
              ?parts.settingsRow,
              ?parts.footer,
              parts.joinButton,
            ],
          ),
        ),
      ],
    );
  }

  /// Everything in one column, the preview block capped at [previewMaxWidth].
  Widget _stacked(
    BuildContext context,
    _LobbyParts parts, {
    required bool isSmall,
    required double previewMaxWidth,
    required double joinButtonWidth,
  }) {
    final spacing = context.streamSpacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing.xxl,
      children: [
        StreamLobbyHeader(title: title, subtitle: subtitle),
        // The whole preview block is capped at the preview's width, so the
        // settings fields line up under it rather than running the width of
        // the window.
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: previewMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: isSmall ? spacing.sm : spacing.md,
            children: [
              parts.preview,
              ?parts.controlsBelow,
              ?parts.settingsRow,
            ],
          ),
        ),
        ?parts.footer,
        // Full width on a phone, a fixed width where there is room for it.
        SizedBox(width: joinButtonWidth, child: parts.joinButton),
      ],
    );
  }
}

/// The pieces of the lobby, before they are arranged.
typedef _LobbyParts = ({
  Widget preview,
  Widget? controlsBelow,
  Widget? settingsRow,
  Widget? footer,
  Widget joinButton,
});

/// The camera preview: the participant tile the user is about to become.
///
/// Deliberately the same [StreamParticipantTile] the call draws, so the
/// surface, corner radius, name pill and placeholder avatar cannot drift from
/// the call's, and an app that themes its tiles themes this too. The tile is
/// handed its renderer directly because the lobby's track belongs to nobody
/// yet: it is warmed up locally and not registered with the call, so the
/// tile's usual lookup by session id would find nothing.
class _LobbyPreview extends StatelessWidget {
  const _LobbyPreview({required this.compactMaxHeight});

  /// The tallest the preview is drawn at [StreamScreenSize.small].
  final double compactMaxHeight;

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
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: compactMaxHeight),
        child: AspectRatio(
          aspectRatio: style.compactPreviewAspectRatio,
          child: tile,
        ),
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
