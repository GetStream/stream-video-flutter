import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thermal/thermal.dart';

import '../../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../globals.dart';
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/models/models.pb.dart';
import '../../../stream_video.dart';
import '../../extensions/thermal_status_ext.dart';
import '../session/call_session.dart';
import '../state/call_state_notifier.dart';
import 'trace_record.dart';
import 'trace_tag.dart';
import 'tracer.dart';

class SfuStatsReporter {
  SfuStatsReporter({
    required this.callSession,
    required this.stateManager,
    required this.statsOptions,
    this.unifiedSessionId,
  }) {
    _deviceTracer = Tracer('sfu-stats-device')
      ..setEnabled(statsOptions.enableRtcStats);

    final sharedStream = _ThermalMonitor.stream;
    if (sharedStream != null) {
      _thermalStatus = _ThermalMonitor.lastStatus;
      _thermalStatusSubscription = sharedStream.listen((ThermalStatus status) {
        _thermalStatus = status;
        _deviceTracer.trace(TraceTag.deviceThermalState, status.name);
      });
    }

    _mediaDeviceSubscription = RtcMediaDeviceNotifier.instance.onDeviceChange
        .listen(
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

  // In the initial stage send stats more often in case of early-call issues.
  static const _initialReportingDelays = <Duration>[
    Duration(milliseconds: 1500),
    Duration(seconds: 3),
    Duration(seconds: 3),
    Duration(seconds: 5),
  ];

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
  bool? _lastLowPowerMode;

  late final Tracer _deviceTracer;

  Timer? _timer;
  int _reportCount = 0;
  bool _stopped = false;
  bool _flushing = false;

  static const _flushTimeout = Duration(seconds: 2);

  bool get _shouldSkipSfuStats => _stopped && !_flushing;

  void run({Duration interval = const Duration(seconds: 8)}) {
    _timer?.cancel();
    _reportCount = 0;
    _stopped = false;
    _scheduleNextReport(interval);
  }

  void _scheduleNextReport(Duration regularInterval) {
    if (_reportCount < _initialReportingDelays.length) {
      _timer = Timer(_initialReportingDelays[_reportCount], () {
        _reportCount++;
        _invokeSendStats();
        _scheduleNextReport(regularInterval);
      });
    } else {
      _timer = Timer.periodic(regularInterval, (_) => _invokeSendStats());
    }
  }

  void _invokeSendStats() {
    try {
      sendSfuStats();
    } catch (e) {
      _logger.v(() => 'Failed to send SFU stats');
    }
  }

  Future<void> flush() async {
    if (_stopped) return;
    _flushing = true;

    final sendStatsFuture = sendSfuStats().whenComplete(() {
      _flushing = false;
    });

    try {
      await sendStatsFuture.timeout(
        _flushTimeout,
        onTimeout: () {
          _logger.v(() => 'SFU stats flush timed out during sampling');
        },
      );
    } catch (e) {
      _logger.v(() => 'Failed to flush SFU stats: $e');
    }
  }

  Future<void> sendSfuStats({
    int? connectionTimeMs,
    SfuReconnectionStrategy? reconnectionStrategy,
  }) async {
    if (_shouldSkipSfuStats) return;
    try {
      await _sfuStatsLock.synchronized(() async {
        if (_shouldSkipSfuStats) return;
        final publisherStatsBundle = await callSession.rtcManager?.publisher
            ?.getStats();

        if (_shouldSkipSfuStats) return;
        final subscriberStatsBundle = await callSession.rtcManager?.subscriber
            .getStats();

        if (_shouldSkipSfuStats ||
            (publisherStatsBundle == null && subscriberStatsBundle == null)) {
          return;
        }

        final batterySaveModeAvailable =
            CurrentPlatform.isAndroid ||
            CurrentPlatform.isIos ||
            CurrentPlatform.isMacOS ||
            CurrentPlatform.isWindows;

        bool? lowPowerMode;
        if (batterySaveModeAvailable) {
          try {
            lowPowerMode = await Battery().isInBatterySaveMode;
            if (lowPowerMode != _lastLowPowerMode) {
              _deviceTracer.trace(TraceTag.deviceLowPowerMode, lowPowerMode);
              _lastLowPowerMode = lowPowerMode;
            }
          } on PlatformException {
            _logger.d(() => 'Failed to get battery save mode from the device');
          }
        }

        sfu_models.AndroidState? androidState;
        sfu_models.AppleState? appleState;

        final audioInputDevices = sfu_models.InputDevices(
          availableDevices: _availableAudioInputs,
          currentDevice: stateManager.callState.audioInputDevice?.label,
          isPermitted:
              stateManager.callState.audioInputDevice != null &&
              stateManager.callState.ownCapabilities.contains(
                CallPermission.sendAudio,
              ),
        );

        final videoInputDevices = sfu_models.InputDevices(
          availableDevices: _availableVideoInputs,
          currentDevice: stateManager.callState.videoInputDevice?.label,
          isPermitted:
              stateManager.callState.videoInputDevice != null &&
              stateManager.callState.ownCapabilities.contains(
                CallPermission.sendVideo,
              ),
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

            encodeStats = callSession.rtcManager?.publisher
                ?.getPerformanceStats(
                  publisherStatsBundle.rtcStats,
                  callSession.getTrackType,
                );
          }

          if (subscriberStatsBundle != null) {
            await callSession.rtcManager?.subscriber.traceStats(
              subscriberStatsBundle.rawStats,
            );

            decodeStats = callSession.rtcManager?.subscriber
                .getPerformanceStats(
                  subscriberStatsBundle.rtcStats,
                  callSession.getTrackType,
                );
          }

          final subscriberTrace = callSession.rtcManager?.subscriber.tracer
              .take();
          final publisherTrace = callSession.rtcManager?.publisher?.tracer
              .take();
          final sessionTrace = callSession.getTrace();
          final mediaDeviceNotifierTrace = RtcMediaDeviceNotifier.instance
              .getTrace();

          traces.addAll([
            if (subscriberTrace != null) subscriberTrace,
            if (publisherTrace != null) publisherTrace,
            ...sessionTrace,
            mediaDeviceNotifierTrace,
            _deviceTracer.take(),
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
              PlatformType.macOS => macOsWebRTCVersion,
              PlatformType.windows => windowsWebRTCVersion,
              PlatformType.linux => linuxWebRTCVersion,
              _ => null,
            },
            telemetry: _calculateTelemetry(
              connectionTimeMs,
              reconnectionStrategy,
            ),
            rtcStats: [
              ...traces.expand((trace) => trace.snapshot),
            ].toJsonString(),
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
    _stopped = true;
    _timer?.cancel();
    _mediaDeviceSubscription?.cancel();
    _thermalStatusSubscription?.cancel();
    _deviceTracer.dispose();
  }
}

/// Shared, never-cancelled bridge to `Thermal().onThermalStatusChanged`.
class _ThermalMonitor {
  _ThermalMonitor._();

  static StreamController<ThermalStatus>? _controller;
  static ThermalStatus? _lastStatus;
  static bool _initialized = false;

  static ThermalStatus? get lastStatus => _lastStatus;

  static Stream<ThermalStatus>? get stream {
    final available = CurrentPlatform.isAndroid || CurrentPlatform.isIos;
    if (!available) return null;
    _ensureSubscribed();
    return _controller?.stream;
  }

  static void _ensureSubscribed() {
    if (_initialized) return;
    _initialized = true;
    _controller = StreamController<ThermalStatus>.broadcast();
    try {
      Thermal().onThermalStatusChanged.listen((ThermalStatus status) {
        _lastStatus = status;
        _controller?.add(status);
      });
    } catch (_) {
      // Thermal plugin not available
    }
  }
}
