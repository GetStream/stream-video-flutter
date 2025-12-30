import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as webrtc;

import 'protobuf/video/sfu/models/models.pb.dart';

const String streamSdkName = 'stream-flutter';
const String streamVideoVersion = '1.2.2';
const String openapiModelsVersion = '202.0.0';
const String protocolModelsVersion = '1.40.1';
const String androidWebRTCVersion = webrtc.androidWebRTCVersion;
const String iosWebRTCVersion = webrtc.iosWebRTCVersion;

const String streamDefaultUserAgent =
    'stream-video-flutter-v$streamVideoVersion';
final xStreamClientHeader = '$streamDefaultUserAgent|$clientVersionDetails';

/// Details regarding app name, version, os and device. Is set during initialization of StreamVideo instance.
@internal
String? clientVersionDetails;

@internal
ClientDetails? clientDetails;
