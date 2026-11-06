library flutter_webrtc;

export 'package:stream_webrtc_interface/stream_webrtc_interface.dart'
    hide MediaDevices, MediaRecorder, Navigator;

export 'src/third_party/flutter_webrtc/desktop_capturer.dart';
export 'src/third_party/flutter_webrtc/e2ee/encryption_manager.dart';
export 'src/third_party/flutter_webrtc/e2ee/encryption_types.dart';
export 'src/third_party/flutter_webrtc/helper.dart';
export 'src/third_party/flutter_webrtc/media_devices.dart';
export 'src/third_party/flutter_webrtc/media_recorder.dart';
export 'src/third_party/flutter_webrtc/native/adapter_type.dart';
export 'src/third_party/flutter_webrtc/native/android/audio_configuration.dart';
export 'src/third_party/flutter_webrtc/native/audio_management.dart';
export 'src/third_party/flutter_webrtc/native/camera_utils.dart';
export 'src/third_party/flutter_webrtc/native/factory_impl.dart'
    if (dart.library.js_interop) 'src/third_party/flutter_webrtc/web/factory_impl.dart';
export 'src/third_party/flutter_webrtc/native/ios/audio_configuration.dart';
export 'src/third_party/flutter_webrtc/native/ios/audio_management.dart';
export 'src/third_party/flutter_webrtc/native/native_peer_connection_factory.dart'
    if (dart.library.js_interop) 'src/third_party/flutter_webrtc/web/native_peer_connection_factory.dart';
export 'src/third_party/flutter_webrtc/native/rtc_video_platform_view.dart';
export 'src/third_party/flutter_webrtc/native/rtc_video_platform_view_controller.dart';
export 'src/third_party/flutter_webrtc/native/rtc_video_renderer_impl.dart'
    if (dart.library.js_interop) 'src/third_party/flutter_webrtc/web/rtc_video_renderer_impl.dart';
export 'src/third_party/flutter_webrtc/native/rtc_video_view_impl.dart'
    if (dart.library.js_interop) 'src/third_party/flutter_webrtc/web/rtc_video_view_impl.dart';
export 'src/third_party/flutter_webrtc/native/utils.dart'
    if (dart.library.js_interop) 'src/third_party/flutter_webrtc/web/utils.dart';
export 'src/third_party/flutter_webrtc/video_renderer_extension.dart';

const String androidWebRTCVersion = '145.17.0';
const String iosWebRTCVersion = '145.17.0';
const String macOsWebRTCVersion = '145.17.0';
const String windowsWebRTCVersion = '144.7559.09';
const String linuxWebRTCVersion = '144.7559.09';
