import 'package:meta/meta.dart';

import 'src/platform_detector/platform_detector.dart';
import 'version.g.dart';

@internal
// Details regarding app name, version, os and device. Is set during initialization of StreamVideo instance.
String? clientVersionDetails;

const String defaultUserAgent = 'stream-video-dart-v$packageVersion';

/// Current package version
const packageVersion = streamVideoVersion;

/// Composed client version
final streamClientVersion = '$defaultUserAgent|$clientVersionDetails';
