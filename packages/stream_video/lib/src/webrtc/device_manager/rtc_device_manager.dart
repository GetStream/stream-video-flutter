import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import '../../errors/video_error_composer.dart';
import '../../utils/result.dart';
import 'package:rate_limiter/rate_limiter.dart';

import 'rtc_media_device.dart';

typedef OnDevicesChange = void Function(
  List<RtcMediaDevice> previous,
  List<RtcMediaDevice> current,
);

class RtcMediaDevices {
  RtcMediaDevices._internal() {
    // Debounce call the onDeviceChange callback.
    rtc.navigator.mediaDevices.ondevicechange = _onDeviceChange;
    // Triggers the initial device change event to get the devices list.
    _onDeviceChange(null);
  }

  static final RtcMediaDevices instance = RtcMediaDevices._internal();

  OnDevicesChange? onDevicesChange;
  var _currentDevices = const <RtcMediaDevice>[];


  Future<void> _onDeviceChange(_) async {
    final devicesResult = await enumerateDevices();
    final devices = devicesResult.getDataOrNull();

    if (devices == null) return;

    final previous = [..._currentDevices];
    _currentDevices = devices;
    onDevicesChange?.call(previous, _currentDevices);
  }

  Future<Result<List<RtcMediaDevice>>> enumerateDevices({
    RtcMediaDeviceKind? kind,
  }) async {
    try {
      final devices = await rtc.navigator.mediaDevices.enumerateDevices();

      final mediaDevices = devices.map((it) {
        return RtcMediaDevice(
          id: it.deviceId,
          label: it.label,
          kind: RtcMediaDeviceKind.fromAlias(it.kind),
        );
      });

      if (kind != null) {
        final devices = mediaDevices.where((d) => d.kind == kind);
        if (devices.isEmpty) {
          return Result.error('No devices found for kind: $kind');
        }
        return Result.success(devices.toList());
      }

      if (mediaDevices.isEmpty) return Result.error('No devices found');
      return Result.success(mediaDevices.toList());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<List<RtcMediaDevice>>> audioInputs() {
    return enumerateDevices(kind: RtcMediaDeviceKind.audioInput);
  }

  Future<Result<List<RtcMediaDevice>>> audioOutputs() {
    return enumerateDevices(kind: RtcMediaDeviceKind.audioOutput);
  }

  Future<Result<List<RtcMediaDevice>>> videoInputs() {
    return enumerateDevices(kind: RtcMediaDeviceKind.videoInput);
  }
}
