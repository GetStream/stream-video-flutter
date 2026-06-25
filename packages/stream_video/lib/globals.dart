import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as webrtc;

import 'protobuf/video/sfu/models/models.pb.dart';
import 'src/video_environment_manager.dart';

const String streamSdkName = 'stream-flutter';
const String streamVideoVersion = '1.4.1';
const String openapiModelsVersion = '225.14.0';
const String protocolModelsVersion = '1.48.0';
const String androidWebRTCVersion = webrtc.androidWebRTCVersion;
const String iosWebRTCVersion = webrtc.iosWebRTCVersion;

const String streamDefaultUserAgent =
    'stream-video-flutter-v$streamVideoVersion';

/// Manages the current video environment (OS, device, app info).
@internal
final videoEnvironmentManager = VideoEnvironmentManager();

/// The `X-Stream-Client` header value.
String get xStreamClientHeader => videoEnvironmentManager.xStreamClientHeader;

/// The SFU `ClientDetails` proto for the current environment.
ClientDetails get clientDetails => videoEnvironmentManager.clientDetails;
