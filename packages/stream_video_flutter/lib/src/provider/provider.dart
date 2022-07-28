import 'package:stream_video/stream_video.dart';
import 'package:flutter/material.dart';

class StreamVideoProvider extends InheritedWidget {
  const StreamVideoProvider({
    Key? key,
    required this.client,
    required Widget child,
  }) : super(key: key, child: child);

//Todo make this private and expose controllers
  final StreamVideoClient client;

  static StreamVideoProvider of(BuildContext context) {
    final StreamVideoProvider? result =
        context.dependOnInheritedWidgetOfExactType<StreamVideoProvider>();
    assert(result != null, 'No StreamVideoProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(StreamVideoProvider old) => client != old.client;
}
