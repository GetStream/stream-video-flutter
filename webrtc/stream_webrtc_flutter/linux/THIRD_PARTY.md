# Third-party code

These files in `linux/` come from [flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc), through Stream's fork [GetStream/webrtc-flutter](https://github.com/GetStream/webrtc-flutter). The fork's changes are under the same MIT licence.

- Upstream: https://github.com/flutter-webrtc/flutter-webrtc
- Baseline: flutter-webrtc v1.5.2, through GetStream/webrtc-flutter at `9b4f503` (stream_webrtc_flutter 4.0.0)
- Copied into this repository: 2026-10-22
- Copyright holder: (c) 2018 湖北捷智云技术有限公司
- Licence: MIT, see `LICENSE`

This is not a hermetic snapshot: the code keeps being modified in this repository, and those changes stay under the MIT licence.

Files that are not on this list are Stream code, under the licence in the package's root `LICENSE`.

## Files

- `CMakeLists.txt`
- `flutter/binary_messenger_impl.h`
- `flutter/byte_buffer_streams.h`
- `flutter/core_implementations.cc`
- `flutter/include/flutter/basic_message_channel.h`
- `flutter/include/flutter/binary_messenger.h`
- `flutter/include/flutter/byte_streams.h`
- `flutter/include/flutter/encodable_value.h`
- `flutter/include/flutter/engine_method_result.cc`
- `flutter/include/flutter/engine_method_result.h`
- `flutter/include/flutter/event_channel.h`
- `flutter/include/flutter/event_sink.h`
- `flutter/include/flutter/event_stream_handler.h`
- `flutter/include/flutter/event_stream_handler_functions.h`
- `flutter/include/flutter/message_codec.h`
- `flutter/include/flutter/method_call.h`
- `flutter/include/flutter/method_channel.h`
- `flutter/include/flutter/method_codec.h`
- `flutter/include/flutter/method_result.h`
- `flutter/include/flutter/method_result_functions.h`
- `flutter/include/flutter/plugin_registrar.h`
- `flutter/include/flutter/standard_codec_serializer.h`
- `flutter/include/flutter/standard_message_codec.h`
- `flutter/include/flutter/standard_method_codec.h`
- `flutter/include/flutter/texture_registrar.h`
- `flutter/plugin_registrar.cc`
- `flutter/standard_codec.cc`
- `flutter/texture_registrar_impl.h`
- `stream_webrtc_flutter/flutter_web_r_t_c_plugin.h`
- `stream_webrtc_flutter_plugin.cc`
- `task_runner_linux.cc`
- `task_runner_linux.h`
