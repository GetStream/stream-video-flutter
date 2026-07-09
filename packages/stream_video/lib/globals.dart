import 'package:meta/meta.dart';

import 'protobuf/video/sfu/models/models.pb.dart';
import 'src/video_environment_manager.dart';

const String streamSdkName = 'stream-flutter';
const String streamVideoVersion = '1.4.1';
const String openapiModelsVersion = '225.14.0';
const String protocolModelsVersion = '1.48.0';

// Bundled native WebRTC.org version from `stream_webrtc_flutter`. Kept as a
// literal (rather than importing the plugin) so stream_video has no
// dependency on it; bump this alongside the plugin's own version.
const String androidWebRTCVersion = '145.9.0';
const String iosWebRTCVersion = '145.9.0';

const String streamDefaultUserAgent =
    'stream-video-flutter-v$streamVideoVersion';

/// Manages the current video environment (OS, device, app info).
@internal
final videoEnvironmentManager = VideoEnvironmentManager();

/// The `X-Stream-Client` header value.
String get xStreamClientHeader => videoEnvironmentManager.xStreamClientHeader;

/// The SFU `ClientDetails` proto for the current environment.
ClientDetails get clientDetails => videoEnvironmentManager.clientDetails;
