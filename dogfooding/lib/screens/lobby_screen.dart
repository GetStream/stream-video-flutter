// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/user_auth_controller.dart';
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:flutter_dogfooding/utils/assets.dart';
import 'package:flutter_dogfooding/widgets/stream_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    super.key,
    required this.onJoinCallPressed,
    required this.call,
  });

  final ValueChanged<CallConnectOptions> onJoinCallPressed;
  final Call call;

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;

  final _userAuthController = locator.get<UserAuthController>();

  void joinCallPressed() {
    var options = const CallConnectOptions();

    final cameraTrack = _cameraTrack;
    if (cameraTrack != null) {
      options = options.copyWith(
        camera: TrackOption.enabled(),
      );
    }

    final microphoneTrack = _microphoneTrack;
    if (microphoneTrack != null) {
      options = options.copyWith(
        microphone: TrackOption.enabled(),
      );
    }

    widget.onJoinCallPressed(options);
  }

  @override
  void dispose() {
    _cameraTrack?.stop();
    _microphoneTrack?.stop();

    _cameraTrack = null;
    _microphoneTrack = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;
    final currentUser = _userAuthController.currentUser;

    final theme = StreamLobbyViewTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamUserAvatar(user: currentUser!),
        ),
        titleSpacing: 4,
        centerTitle: false,
        title: Text(
          currentUser.name,
          style: textTheme.body,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SvgPicture.asset(
                  globalNetworkAssest,
                  width: 35,
                ),
                const SizedBox(height: 8),
                Text(
                  'Set up your call\nbefore joining',
                  textAlign: TextAlign.center,
                  style: textTheme.title1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorTheme.textHighEmphasis,
                  ),
                ),
                const SizedBox(height: 16),
                StreamLobbyVideo(
                  call: widget.call,
                  onMicrophoneTrackSet: (track) => _microphoneTrack = track,
                  onCameraTrackSet: (track) => _cameraTrack = track,
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.cardBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.lock_person),
                                ),
                                Expanded(
                                  child: Text(
                                    'Start a private test call. This demo is built on Stream’s SDKs and runs on our global edge network.',
                                    style: textTheme.footnote.copyWith(
                                      color: colorTheme.textLowEmphasis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            StreamButton.active(
                                label: 'Start a test call',
                                onPressed: joinCallPressed)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
