import 'package:jaspr/jaspr.dart';
import 'package:stream_video_jaspr/stream_video_jaspr.dart';

class CallScreen extends StatelessComponent {
  const CallScreen({required this.call, required this.onLeave, super.key});

  final Call call;
  final void Function() onLeave;

  @override
  Component build(BuildContext context) {
    return StreamCallContent(call: call, onLeave: onLeave);
  }
}
