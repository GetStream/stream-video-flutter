import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/model/environment.dart';
import '../core/repos/custom_environment_loader.dart';

final StreamCallType kCallType = StreamCallType.defaultType();

/// Chat channel type used on Stream's own environments.
const String kMessageChannelType = 'videocall';

const String kAppName = 'Stream Dogfooding';
const double kMaxWidthRegularScreen = 500;

/// Whether the app runs as the production build.
bool get kIsProd => !kIsWeb && appFlavor == 'prod';

/// Returns the chat channel type to use for [environment].
///
/// Custom environments use the type configured on [CustomEnvironmentLoader]
/// (`messaging` by default).
String messageChannelTypeFor(Environment environment) {
  if (environment != Environment.custom) return kMessageChannelType;

  return customEnvironmentLoader?.messageChannelType ??
      kDefaultMessageChannelType;
}
