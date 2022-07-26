import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
      color: Colors.red,
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
