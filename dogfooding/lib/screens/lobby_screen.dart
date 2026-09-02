// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../utils/app_features.dart';

/// The dogfooding lobby: the SDK's [StreamLobbyView] under this app's own
/// chrome, with a background-blur toggle spliced into the control row.
class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    super.key,
    required this.onJoinCallPressed,
    required this.call,
  });

  final void Function(CallConnectOptions, StreamVideoEffectsManager)
  onJoinCallPressed;
  final Call call;

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final _userAuthController = locator.get<UserAuthController>();
  late final StreamVideoEffectsManager _videoEffectsManager;

  @override
  void initState() {
    super.initState();
    _videoEffectsManager = StreamVideoEffectsManager(widget.call);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final currentUser = _userAuthController.currentUser!;

    // Picking a preset is a demo of what a host can do, not something the SDK
    // does: StreamLobbyView defaults to LobbyActions.simple() everywhere.
    //
    // The choice is by platform, not by window width. A phone has no room for
    // a settings row at any size, so the device choice goes on the toggles'
    // carets; anything with a pointer gets the fields, however narrow the
    // window is. Width still decides the *layout* — whether the control row
    // sits on the preview or below it — but that is StreamLobbyView's business
    // and it needs nothing from here.
    final extras = [
      const StreamLobbyParticipantsControl(),
      if (AppFeature.backgroundBlur.isSupported)
        _BlurToggle(effects: _videoEffectsManager),
    ];
    final actions = isMobileDevice
        ? LobbyActions.regular(extraControls: extras)
        : LobbyActions.full(extraControls: extras);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamUserAvatar(user: currentUser),
        ),
        titleSpacing: 4,
        centerTitle: false,
        title: Text(currentUser.name, style: textTheme.headingXs),
        actions: [
          StreamButton.icon(
            style: .secondary,
            type: .ghost,
            icon: Icon(context.streamIcons.leave),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.xxl,
          ),
          child: StreamLobbyView(
            call: widget.call,
            actions: actions,
            title: Text('Set up your call', style: textTheme.headingLg),
            joinButtonLabel: const Text('Start a test call'),
            onJoinCallPressed: (options) =>
                widget.onJoinCallPressed(options, _videoEffectsManager),
          ),
        ),
      ),
    );
  }
}

/// Blurs whatever is behind the user in the preview.
///
/// A feature button rather than a control: it is off by default and should
/// read as switched on, not as something taken away.
class _BlurToggle extends StatefulWidget {
  const _BlurToggle({required this.effects});

  final StreamVideoEffectsManager effects;

  @override
  State<_BlurToggle> createState() => _BlurToggleState();
}

class _BlurToggleState extends State<_BlurToggle> {
  bool _enabled = false;
  RtcLocalCameraTrack? _appliedTo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Reading the controller here subscribes this button to it, so switching
    // camera device brings us back and the filter is reapplied to the new
    // track. This used to sit in build(), which meant firing a platform call
    // and recording it as applied from inside a build that might never be
    // committed — and swallowing whatever it threw.
    final track = StreamLobbyScope.of(context).cameraTrack;
    if (!_enabled || track == null || track == _appliedTo) return;

    unawaited(_apply(track));
  }

  Future<void> _apply(RtcLocalCameraTrack? track) async {
    final previous = _appliedTo;
    _appliedTo = track;
    try {
      await widget.effects.applyBackgroundBlurFilter(
        BlurIntensity.medium,
        track: track,
      );
    } catch (e) {
      // Otherwise the button goes on claiming blur over an unblurred preview,
      // and never retries because the track is already recorded as applied.
      debugPrint('Could not apply the background blur: $e');
      _appliedTo = previous;
      if (mounted) setState(() => _enabled = false);
    }
  }

  Future<void> _remove(RtcLocalCameraTrack? track) async {
    _appliedTo = null;
    try {
      await widget.effects.disableAllFilters(track: track);
    } catch (e) {
      debugPrint('Could not remove the background blur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final track = StreamLobbyScope.of(context).cameraTrack;

    return Tooltip(
      message: _enabled ? 'Disable background blur' : 'Enable background blur',
      child: CallFeatureButton(
        icon: Icon(context.streamIcons.blurFill),
        selected: _enabled,
        onPressed: () {
          final enabling = !_enabled;
          setState(() => _enabled = enabling);
          unawaited(enabling ? _apply(track) : _remove(track));
        },
      ),
    );
  }
}
