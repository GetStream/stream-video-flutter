import 'src/platform_detector/platform_detector.dart';
import 'version.g.dart';

/// Default user agent for all requests
final String defaultUserAgent = 'stream-video-dart-client-${CurrentPlatform
    .name}';

/// Current package version
const packageVersion = streamVideoVersion;

/// Composed client version
final streamClientVersion = '$defaultUserAgent-$packageVersion';
