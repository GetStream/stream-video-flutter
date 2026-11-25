import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'screen_share_constraints.dart';

/// Where a screen share captures from.
///
/// iOS can capture through a broadcast extension. Desktop platforms capture
/// the screen or window the app picked. Android and web ask the system or the
/// browser.
@internal
abstract interface class ScreenShareSource {
  /// The source of the current platform.
  factory ScreenShareSource.forPlatform() {
    final capabilities = rtc.webRtcCapabilities;
    if (capabilities.supportsBroadcastExtension) {
      return const BroadcastExtensionScreenShareSource();
    }
    if (capabilities.supportsScreenShareSourceSelection) {
      return const SelectedScreenShareSource();
    }
    return const SystemScreenShareSource();
  }

  /// Whether a share with [constraints] runs in the broadcast extension.
  bool usesBroadcastExtension(ScreenShareConstraints constraints);

  /// Adds what names the source of a share with [constraints] to its
  /// [video] constraints.
  void addTo(Map<String, dynamic> video, ScreenShareConstraints constraints);
}

/// Captures through the iOS broadcast extension when asked to. The capture
/// shows no picker: it is shown on its own before the broadcast starts.
@internal
class BroadcastExtensionScreenShareSource implements ScreenShareSource {
  const BroadcastExtensionScreenShareSource();

  @override
  bool usesBroadcastExtension(ScreenShareConstraints constraints) {
    return constraints.useiOSBroadcastExtension;
  }

  @override
  void addTo(Map<String, dynamic> video, ScreenShareConstraints constraints) {
    if (constraints.useiOSBroadcastExtension) {
      video['deviceId'] = 'broadcast-manual';
    }
  }
}

/// Captures the screen or window the app picked, at most at its frame rate.
@internal
class SelectedScreenShareSource implements ScreenShareSource {
  const SelectedScreenShareSource();

  @override
  bool usesBroadcastExtension(ScreenShareConstraints constraints) => false;

  @override
  void addTo(Map<String, dynamic> video, ScreenShareConstraints constraints) {
    if (constraints.deviceId case final sourceId?) {
      video['deviceId'] = {'exact': sourceId};
    }
    // Left out entirely when there is no cap to ask for: a null here reaches
    // the platform as a null `frameRate`, which every implementation has to
    // defend against to fall back to its own default.
    final maxFrameRate = constraints.maxFrameRate;
    if (maxFrameRate != null && maxFrameRate != 0.0) {
      video['mandatory'] = {'frameRate': maxFrameRate};
    }
  }
}

/// Lets the system or the browser ask the user what to share.
@internal
class SystemScreenShareSource implements ScreenShareSource {
  const SystemScreenShareSource();

  @override
  bool usesBroadcastExtension(ScreenShareConstraints constraints) => false;

  @override
  void addTo(Map<String, dynamic> video, ScreenShareConstraints constraints) {}
}
