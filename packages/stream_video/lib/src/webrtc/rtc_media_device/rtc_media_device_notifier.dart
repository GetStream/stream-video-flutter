import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../open_api/video/coordinator/api.dart';
import '../../errors/video_error_composer.dart';
import '../../platform_detector/platform_detector.dart';
import '../../utils/extensions.dart';
import '../../utils/result.dart';
import 'rtc_media_device.dart';

class RtcMediaDeviceNotifier {
  RtcMediaDeviceNotifier._internal() {
    // Debounce call the onDeviceChange callback.
    rtc.navigator.mediaDevices.ondevicechange = _onDeviceChange;
    // Triggers the initial device change event to get the devices list.
    _onDeviceChange(null);
  }

  static final instance = RtcMediaDeviceNotifier._internal();

  Stream<List<RtcMediaDevice>> get onDeviceChange => _devicesController.stream;
  final _devicesController = BehaviorSubject<List<RtcMediaDevice>>();

  Future<void> _onDeviceChange(_) async {
    final devicesResult = await enumerateDevices();
    final devices = devicesResult.getDataOrNull();

    if (devices == null) return;

    _devicesController.add(devices);
  }

  Future<Result<List<RtcMediaDevice>>> enumerateDevices({
    RtcMediaDeviceKind? kind,
  }) async {
    try {
      final devices = await rtc.navigator.mediaDevices.enumerateDevices();

      final mediaDevices = [
        ...devices.map((it) {
          return RtcMediaDevice(
            id: it.deviceId,
            label: it.label,
            groupId: it.groupId,
            kind: RtcMediaDeviceKind.fromAlias(it.kind),
          );
        }),
        if (CurrentPlatform.isIos &&
            (kind == null || kind == RtcMediaDeviceKind.audioOutput) &&
            devices.none(
              (d) => d.deviceId.equalsIgnoreCase(
                AudioSettingsRequestDefaultDeviceEnum.earpiece.value,
              ),
            ))
          RtcMediaDevice(
            id: AudioSettingsRequestDefaultDeviceEnum.earpiece.value,
            label: AudioSettingsRequestDefaultDeviceEnum.earpiece.value
                .capitalizeFirstLetter(),
            kind: RtcMediaDeviceKind.audioOutput,
          ),
      ];

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
