import 'package:meta/meta.dart';

const String streamSdkName = 'stream-flutter';
const String streamVideoVersion = '0.8.0';
const String androidWebRTCVersion = 'libwebrtc-m125.6422.03';
const String iosWebRTCVersion = 'libwebrtc-m125.6422.06';

const String streamDefaultUserAgent = 'stream-video-dart-v$streamVideoVersion';
final xStreamClientHeader = '$streamDefaultUserAgent|$clientVersionDetails';

@internal

/// Details regarding app name, version, os and device. Is set during initialization of StreamVideo instance.
String? clientVersionDetails;
