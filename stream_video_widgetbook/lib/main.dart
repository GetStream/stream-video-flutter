import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/stream_video_widgetbook.dart';

void main() {
  runApp(
    const ProviderScope(
      child: StreamVideoWidgetbook(),
    ),
  );
}
