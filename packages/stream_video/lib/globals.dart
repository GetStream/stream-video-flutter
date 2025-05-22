import 'package:meta/meta.dart';

const String streamSdkName = 'stream-flutter';
const String streamVideoVersion = '0.9.4';
const String openapiModelsVersion = '167.9.1';
const String protocolModelsVersion = '1.35.0';
const String androidWebRTCVersion = '1.3.8';
const String iosWebRTCVersion = '125.6422.65';

const String streamDefaultUserAgent =
    'stream-video-flutter-v$streamVideoVersion';
final xStreamClientHeader = '$streamDefaultUserAgent|$clientVersionDetails';

/// Details regarding app name, version, os and device. Is set during initialization of StreamVideo instance.
@internal
String? clientVersionDetails;
