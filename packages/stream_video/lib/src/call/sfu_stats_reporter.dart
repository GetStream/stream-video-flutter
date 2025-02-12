import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:thermal/thermal.dart';

import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../version.g.dart';
import '../extensions/thermal_status_ext.dart';
import '../models/models.dart';
import '../platform_detector/platform_detector.dart';
import '../sfu/data/models/sfu_error.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';
import '../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import 'session/call_session.dart';
import 'state/call_state_notifier.dart';

class SfuStatsReporter {
  SfuStatsReporter({
    required this.callSession,
    required this.stateManager,
  }) {
    final thermalStatusAvailable =
        CurrentPlatform.isAndroid || CurrentPlatform.isIos;
    if (thermalStatusAvailable) {
      try {
        _thermalStatusSubscription =
            Thermal().onThermalStatusChanged.listen((ThermalStatus status) {
          _thermalStatus = status;
        });
      } catch (e) {
        // ignore: thermal status not available
      }
    }

    _mediaDeviceSubscription =
        RtcMediaDeviceNotifier.instance.onDeviceChange.listen(
      (devices) {
        _availableAudioInputs = devices
            .where((device) => device.kind == RtcMediaDeviceKind.audioInput)
            .map((device) => device.label)
            .toList();

        _availableVideoInputs = devices
            .where((device) => device.kind == RtcMediaDeviceKind.videoInput)
            .map((device) => device.label)
            .toList();
      },
    );
  }

  final CallSession callSession;
  final CallStateNotifier stateManager;

  StreamSubscription<List<RtcMediaDevice>>? _mediaDeviceSubscription;
  StreamSubscription<ThermalStatus>? _thermalStatusSubscription;

  List<String>? _availableAudioInputs;
  List<String>? _availableVideoInputs;
  ThermalStatus? _thermalStatus;

  Timer? _timer;

  void run({Duration interval = const Duration(seconds: 10)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      sendSfuStats();
    });
  }

  Future<void> sendSfuStats({
    int? connectionTimeMs,
    SfuReconnectionStrategy? reconnectionStrategy,
  }) async {
    final publisherStatsBundle =
        await callSession.rtcManager?.publisher?.getStats();
    final subscriberStatsBundle =
        await callSession.rtcManager?.subscriber.getStats();

    if (publisherStatsBundle == null || subscriberStatsBundle == null) {
      return;
    }

    final batterySaveModeAvailable = CurrentPlatform.isAndroid ||
        CurrentPlatform.isIos ||
        CurrentPlatform.isMacOS ||
        CurrentPlatform.isWindows;
    final lowPowerMode =
        batterySaveModeAvailable && await Battery().isInBatterySaveMode;

    sfu_models.AndroidState? androidState;
    sfu_models.AppleState? appleState;

    final audioInputDevices = sfu_models.InputDevices(
      availableDevices: _availableAudioInputs,
      currentDevice: stateManager.callState.audioInputDevice?.label,
      isPermitted: stateManager.callState.audioInputDevice != null &&
          stateManager.callState.ownCapabilities
              .contains(CallPermission.sendAudio),
    );

    final videoInputDevices = sfu_models.InputDevices(
      availableDevices: _availableVideoInputs,
      currentDevice: stateManager.callState.videoInputDevice?.label,
      isPermitted: stateManager.callState.videoInputDevice != null &&
          stateManager.callState.ownCapabilities
              .contains(CallPermission.sendVideo),
    );

    if (CurrentPlatform.isAndroid) {
      androidState = sfu_models.AndroidState(
        thermalState: _thermalStatus?.toAndroidThermalState(),
        isPowerSaverMode: lowPowerMode,
      );
    } else if (CurrentPlatform.isIos) {
      appleState = sfu_models.AppleState(
        thermalState: _thermalStatus?.toAppleThermalState(),
        isLowPowerModeEnabled: lowPowerMode,
      );
    }

    final request = sfu.SendStatsRequest(
      sessionId: callSession.sessionId,
      publisherStats: jsonEncode(publisherStatsBundle.rawStats),
      subscriberStats: jsonEncode(subscriberStatsBundle.rawStats),
      sdkVersion: streamVideoVersion,
      sdk: streamSdkName,
      android: androidState,
      apple: appleState,
      audioDevices: audioInputDevices,
      videoDevices: videoInputDevices,
      webrtcVersion: switch (CurrentPlatform.type) {
        PlatformType.android => androidWebRTCVersion,
        PlatformType.ios => iosWebRTCVersion,
        _ => null,
      },
      telemetry: _calculateTelemetry(connectionTimeMs, reconnectionStrategy),
    );

    await callSession.sfuClient.sendStats(
      request,
    );
  }

  sfu.Telemetry? _calculateTelemetry(
    int? connectionTimeMs,
    SfuReconnectionStrategy? reconnectionStrategy,
  ) {
    if (connectionTimeMs == null) return null;

    final timeSeconds = connectionTimeMs / 1000;
    if (reconnectionStrategy != null &&
        reconnectionStrategy != SfuReconnectionStrategy.unspecified) {
      return sfu.Telemetry(
        reconnection: sfu.Reconnection(
          timeSeconds: timeSeconds,
          strategy: reconnectionStrategy.toDto(),
        ),
      );
    } else {
      return sfu.Telemetry(
        connectionTimeSeconds: timeSeconds,
      );
    }
  }

  void stop() {
    _timer?.cancel();
    _mediaDeviceSubscription?.cancel();
    _thermalStatusSubscription?.cancel();
  }
}
