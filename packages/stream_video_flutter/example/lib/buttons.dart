import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UnmuteAudioButton extends StatelessWidget {
  const UnmuteAudioButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.mic,
      label: 'Unmute audio',
      color: Colors.black,
    );
  }
}

class MuteAudioButton extends StatelessWidget {
  const MuteAudioButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.mic_off,
      label: 'Mute audio',
      color: Colors.black,
    );
  }
}

class StopScreenButton extends StatelessWidget {
  const StopScreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.stop_screen_share,
      label: 'Stop screen sharing',
      color: Colors.black,
    );
  }
}

class StartScreenShare extends StatelessWidget {
  const StartScreenShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.screen_share,
      label: 'Start screen sharing',
      color: Colors.black,
    );
  }
}

class EnableVideoButton extends StatelessWidget {
  const EnableVideoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.videocam,
      label: 'Enable Video',
      color: Colors.black,
    );
  }
}

class DisableVideoButton extends StatelessWidget {
  const DisableVideoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.videocam,
      label: 'Disable Video',
      color: Colors.black,
    );
  }
}

class EndCallButton extends StatelessWidget {
  const EndCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.call_end,
      label: 'End',
      color: Colors.red,
    );
  }
}

class JoinCallButton extends StatelessWidget {
  const JoinCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.video_call,
      label: 'Call',
      color: Colors.blue,
    );
  }
}

class CallAcceptButton extends StatelessWidget {
  const CallAcceptButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.call,
      label: 'Accept',
      color: Colors.green,
    );
  }
}

class CallRejectButton extends StatelessWidget {
  const CallRejectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NormalButton(
      iconButton: Icons.call_end,
      label: 'Reject',
      color: Colors.red,
    );
  }
}

class _GradientButton extends StatelessWidget {
  final IconData iconButton;
  final String label;
  const _GradientButton({
    Key? key,
    required this.iconButton,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  iconButton,
                  color: Colors.white,
                ),
                Text(label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NormalButton extends StatelessWidget {
  final IconData iconButton;
  final String label;
  final Color color;
  const _NormalButton({
    Key? key,
    required this.iconButton,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: color),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  iconButton,
                  color: Colors.white,
                ),
                Text(label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchVideo extends StatelessWidget {
  const SwitchVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchVideo();
  }
}
