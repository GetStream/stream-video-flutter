# Third-party code

These files in `test/` come from [flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc), through Stream's fork [GetStream/webrtc-flutter](https://github.com/GetStream/webrtc-flutter). The fork's changes are under the same MIT licence.

- Upstream: https://github.com/flutter-webrtc/flutter-webrtc
- Baseline: flutter-webrtc v1.5.2, through GetStream/webrtc-flutter at `9b4f503` (stream_webrtc_flutter 4.0.1)
- Copied into this repository: 2026-10-22
- Copyright holder: (c) 2018 湖北捷智云技术有限公司
- Licence: MIT, see `LICENSE`

This is not a hermetic snapshot: the code keeps being modified in this repository, and those changes stay under the MIT licence.

Files that are not on this list are Stream code, under the licence in the package's root `LICENSE`.

## Files

- `unit/darwin_parity_test.dart`
- `unit/media_stream_track_clone_test.dart`
- `unit/rtc_peerconnection_test.dart`
- `unit/web/rtc_videw_view_test.dart`
