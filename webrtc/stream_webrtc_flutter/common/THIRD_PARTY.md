# Third-party code

These files in `common/` come from [flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc), through Stream's fork [GetStream/webrtc-flutter](https://github.com/GetStream/webrtc-flutter). The fork's changes are under the same MIT licence.

- Upstream: https://github.com/flutter-webrtc/flutter-webrtc
- Baseline: flutter-webrtc v1.5.2, through GetStream/webrtc-flutter at `9b4f503` (stream_webrtc_flutter 4.0.1)
- Copied into this repository: 2026-10-22
- Copyright holder: (c) 2018 湖北捷智云技术有限公司
- Licence: MIT, see `LICENSE`

This is not a hermetic snapshot: the code keeps being modified in this repository, and those changes stay under the MIT licence.

Files that are not on this list are Stream code, under the licence in the package's root `LICENSE`.

## Files

- `cpp/include/flutter_common.h`
- `cpp/include/flutter_data_channel.h`
- `cpp/include/flutter_frame_capturer.h`
- `cpp/include/flutter_media_stream.h`
- `cpp/include/flutter_peerconnection.h`
- `cpp/include/flutter_screen_capture.h`
- `cpp/include/flutter_video_renderer.h`
- `cpp/include/flutter_webrtc.h`
- `cpp/include/flutter_webrtc_base.h`
- `cpp/include/task_runner.h`
- `cpp/src/flutter_common.cc`
- `cpp/src/flutter_data_channel.cc`
- `cpp/src/flutter_frame_capturer.cc`
- `cpp/src/flutter_media_stream.cc`
- `cpp/src/flutter_peerconnection.cc`
- `cpp/src/flutter_screen_capture.cc`
- `cpp/src/flutter_video_renderer.cc`
- `cpp/src/flutter_webrtc.cc`
- `cpp/src/flutter_webrtc_base.cc`
