// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';

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

    // Picking a preset for the window is a demo of what a host can do, not
    // something the SDK does: StreamLobbyView defaults to LobbyActions.simple()
    // at every width. On Android and iOS the split buttons and the select
    // inputs open bottom sheets with nothing here saying so.
    final extras = [
      const StreamLobbyParticipantsControl(),
      _BlurToggle(effects: _videoEffectsManager),
    ];
    final actions = switch (context.streamScreenSize) {
      StreamScreenSize.small => LobbyActions.regular(extraControls: extras),
      _ => LobbyActions.full(extraControls: extras),
    };

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
  Widget build(BuildContext context) {
    // Reading the controller here subscribes this button to it, so switching
    // camera device rebuilds and the filter is reapplied to the new track.
    final controller = StreamLobbyScope.of(context);
    final track = controller.cameraTrack;

    if (_enabled && track != null && track != _appliedTo) {
      _appliedTo = track;
      widget.effects.applyBackgroundBlurFilter(
        BlurIntensity.medium,
        track: track,
      );
    }

    return Tooltip(
      message: _enabled ? 'Disable background blur' : 'Enable background blur',
      child: CallFeatureButton(
        icon: Icon(context.streamIcons.blurFill),
        selected: _enabled,
        onPressed: () async {
          setState(() => _enabled = !_enabled);

          if (_enabled) {
            _appliedTo = track;
            await widget.effects.applyBackgroundBlurFilter(
              BlurIntensity.medium,
              track: track,
            );
          } else {
            _appliedTo = null;
            await widget.effects.disableAllFilters(track: track);
          }
        },
      ),
    );
  }
}
