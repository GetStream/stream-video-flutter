import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// How the user chooses what to share on desktop.
enum ScreenSharePickerType {
  /// The picker built into the SDK, listing screens and windows with
  /// thumbnails. Works on every desktop platform.
  inApp,

  /// The picker of the operating system.
  ///
  /// Only available when [isContentSharingPickerSupported] is true; anywhere
  /// else [inApp] is used instead.
  system,
}

/// Whether the operating system offers its own picker to choose what to share.
///
/// Only true on macOS 14 or newer.
Future<bool> isContentSharingPickerSupported() =>
    desktopCapturer.isContentSharingPickerSupported();
