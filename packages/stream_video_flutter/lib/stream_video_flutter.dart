library stream_video_flutter;
import 'package:stream_video/stream_video.dart';
import 'package:flutter/material.dart';

class StreamVideoProvider extends InheritedWidget {
  const StreamVideoProvider({
    Key? key,
    required this.color,
    required Widget child,
  }) : super(key: key, child: child);

  final StreamVideoClient color;

  static StreamVideoProvider of(BuildContext context) {
    final StreamVideoProvider? result = context.dependOnInheritedWidgetOfExactType<StreamVideoProvider>();
    assert(result != null, 'No StreamVideoProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(StreamVideoProvider old) => color != old.color;
}