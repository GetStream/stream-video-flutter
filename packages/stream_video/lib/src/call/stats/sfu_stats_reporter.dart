import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thermal/thermal.dart';

import '../../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../globals.dart';
import '../../../open_api/video/coordinator/api.dart';
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/models/models.pb.dart';
import '../../extensions/thermal_status_ext.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../platform_detector/platform_detector.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../webrtc/rtc_media_device/rtc_media_device.dart';
import '../../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../session/call_session.dart';
import '../state/call_state_notifier.dart';
import 'trace_record.dart';
import 'tracer.dart';

class SfuStatsReporter {
  SfuStatsReporter({
    required this.callSession,
    required this.stateManager,
    required this.statsOptions,
    this.unifiedSessionId,
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
        _logger.d(() => 'Failed to subscribe to thermal status changes');
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
  final StatsOptions statsOptions;
  final String? unifiedSessionId;

  late final _sfuStatsLock = Lock();

  final _logger = taggedLogger(tag: 'SV:SfuStatsReporter');

  StreamSubscription<List<RtcMediaDevice>>? _mediaDeviceSubscription;
  StreamSubscription<ThermalStatus>? _thermalStatusSubscription;

  List<String>? _availableAudioInputs;
  List<String>? _availableVideoInputs;
  ThermalStatus? _thermalStatus;

  Timer? _timer;

  void run({Duration interval = const Duration(seconds: 8)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      try {
        sendSfuStats();
      } catch (e) {
        _logger.v(() => 'Failed to send SFU stats');
      }
    });
  }

  Future<void> sendSfuStats({
    int? connectionTimeMs,
    SfuReconnectionStrategy? reconnectionStrategy,
  }) async {
    try {
      await _sfuStatsLock.synchronized(() async {
        final publisherStatsBundle =
            await callSession.rtcManager?.publisher?.getStats();
        final subscriberStatsBundle =
            await callSession.rtcManager?.subscriber.getStats();

        if (publisherStatsBundle == null && subscriberStatsBundle == null) {
          return;
        }

        final batterySaveModeAvailable = CurrentPlatform.isAndroid ||
            CurrentPlatform.isIos ||
            CurrentPlatform.isMacOS ||
            CurrentPlatform.isWindows;

        bool? lowPowerMode;
        if (batterySaveModeAvailable) {
          try {
            lowPowerMode = await Battery().isInBatterySaveMode;
          } on PlatformException {
            _logger.d(() => 'Failed to get battery save mode from the device');
          }
        }

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

        List<PerformanceStats>? encodeStats;
        List<PerformanceStats>? decodeStats;
        final traces = <TraceSlice>[];

        if (statsOptions.enableRtcStats) {
          if (publisherStatsBundle != null) {
            await callSession.rtcManager?.publisher?.traceStats(
              publisherStatsBundle.rawStats,
            );

            encodeStats =
                callSession.rtcManager?.publisher?.getPerformanceStats(
              publisherStatsBundle.rtcStats,
              callSession.getTrackType,
            );
          }

          if (subscriberStatsBundle != null) {
            await callSession.rtcManager?.subscriber.traceStats(
              subscriberStatsBundle.rawStats,
            );

            decodeStats =
                callSession.rtcManager?.subscriber.getPerformanceStats(
              subscriberStatsBundle.rtcStats,
              callSession.getTrackType,
            );
          }

          final subscriberTrace =
              callSession.rtcManager?.subscriber.tracer.take();
          final publisherTrace =
              callSession.rtcManager?.publisher?.tracer.take();
          final sessionTrace = callSession.getTrace();

          traces.addAll([
            if (subscriberTrace != null) subscriberTrace,
            if (publisherTrace != null) publisherTrace,
            sessionTrace,
          ]);
        }

        try {
          final request = sfu.SendStatsRequest(
            sessionId: callSession.sessionId,
            publisherStats: publisherStatsBundle == null
                ? null
                : jsonEncode(publisherStatsBundle.rawStats),
            subscriberStats: subscriberStatsBundle == null
                ? null
                : jsonEncode(subscriberStatsBundle.rawStats),
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
            telemetry:
                _calculateTelemetry(connectionTimeMs, reconnectionStrategy),
            rtcStats:
                [...traces.expand((trace) => trace.snapshot)].toJsonString(),
            encodeStats: encodeStats,
            decodeStats: decodeStats,
            unifiedSessionId: unifiedSessionId,
          );

          final result = await callSession.sfuClient.sendStats(
            request,
          );

          if (result.isFailure) {
            for (final trace in traces) {
              trace.rollback();
            }
          }
        } catch (e) {
          for (final trace in traces) {
            trace.rollback();
          }

          rethrow;
        }
      });
    } catch (e) {
      _logger.v(
        () => 'Failed to send SFU stats: $e',
      );
    }
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
