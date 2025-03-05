import 'package:flutter/services.dart' show appFlavor;
import 'package:stream_video_flutter/stream_video_flutter.dart';

final StreamCallType kCallType = StreamCallType.defaultType();
const String kMessageChannelType = 'videocall';
const String kAppName = 'Stream Dogfooding';
const double kMaxWidthRegularScreen = 500;
bool get kIsProd => switch (appFlavor) {
      'dev' => false,
      'beta' => false,
      'prod' => true,
      _ => true,
    };
