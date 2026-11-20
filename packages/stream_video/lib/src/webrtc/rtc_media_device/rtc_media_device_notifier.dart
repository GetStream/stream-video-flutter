import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import '../../call/stats/trace_tag.dart';
import '../../call/stats/tracer.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../utils/extensions.dart';
import 'device_enumeration_trigger.dart';

class RtcMediaDeviceNotifier {
  RtcMediaDeviceNotifier._internal() {
    rtc.navigator.mediaDevices.ondevicechange = _onDeviceChange;
    // Reads the initial devices list.
    enumerateDevicesFor(DeviceEnumerationTrigger.initial);
  }

  static RtcMediaDeviceNotifier? _instance;

  /// The shared [RtcMediaDeviceNotifier] instance.
  ///
  /// Created lazily on first access so that platform channels are only
  /// touched when the notifier is actually used.
  // ignore: prefer_constructors_over_static_methods, lazy singleton accessor
  static RtcMediaDeviceNotifier get instance =>
      _instance ??= RtcMediaDeviceNotifier._internal();

  /// Overrides the shared [instance], for testing.
  ///
  /// Pass `null` to restore the default lazily-created instance. Always
  /// reset the override (e.g. in `tearDown`) to avoid leaking a mock between
  /// tests.
  @visibleForTesting
  static set instance(RtcMediaDeviceNotifier? notifier) => _instance = notifier;

  /// Whether remote audio can be routed to an output picked from the
  /// [RtcMediaDeviceKind.audioOutput] devices, through
  /// `Call.setAudioOutputDevice`.
  ///
  /// False on WebKit browsers (Safari, every iOS browser and web view) and on
  /// browsers without `setSinkId`: audio plays on the system default output,
  /// and an output picker should be hidden. True on native platforms.
  static bool get isAudioOutputSelectionSupported =>
      rtc.webRtcCapabilities.supportsAudioOutputSelection;

  Stream<List<RtcMediaDevice>> get onDeviceChange => _devicesController.stream;
  final _devicesController = BehaviorSubject<List<RtcMediaDevice>>();

  final _tracer = Tracer(null);

  /// How long device-change events are collected before the devices are
  /// enumerated once for all of them.
  @visibleForTesting
  static const deviceChangeDebounce = Duration(milliseconds: 250);

  Timer? _deviceChangeTimer;

  /// The enumeration currently running on the platform, shared by every
  /// caller that asks for the devices while it runs.
  Future<Result<List<RtcMediaDevice>>>? _pendingEnumeration;

  @internal
  TraceSlice getTrace() {
    return _tracer.take();
  }

  void _onDeviceChange(_) {
    // A single physical change (e.g. a headset connecting) can arrive as
    // several events, and enumerating is expensive on some platforms (on
    // Android it blocks the main thread), so enumerate once per burst.
    _deviceChangeTimer?.cancel();
    _deviceChangeTimer = Timer(deviceChangeDebounce, () {
      enumerateDevicesFor(DeviceEnumerationTrigger.deviceChange);
    });
  }

  /// Returns the available media devices, optionally filtered by [kind], and
  /// emits the full list on [onDeviceChange].
  ///
  /// Calls made while an enumeration is already running share its result
  /// instead of starting another one.
  Future<Result<List<RtcMediaDevice>>> enumerateDevices({
    RtcMediaDeviceKind? kind,
  }) {
    return enumerateDevicesFor(DeviceEnumerationTrigger.explicit, kind: kind);
  }

  /// [enumerateDevices], recording [trigger] in the RTC trace as the reason
  /// the devices are read.
  @internal
  Future<Result<List<RtcMediaDevice>>> enumerateDevicesFor(
    DeviceEnumerationTrigger trigger, {
    RtcMediaDeviceKind? kind,
  }) async {
    var pending = _pendingEnumeration;

    // A device change that lands while an enumeration runs may not be
    // reflected in its result, so wait for it and read the devices again.
    if (pending != null && trigger == DeviceEnumerationTrigger.deviceChange) {
      await pending;
      pending = _pendingEnumeration;
    }

    _tracer.trace(TraceTag.enumerateDevicesTrigger, {
      'trigger': trigger.name,
      'coalesced': pending != null,
    });

    final result = await (pending ?? _startEnumeration());

    final allDevices = result.getDataOrNull();
    if (allDevices == null) return result;

    if (kind == null) {
      if (allDevices.isEmpty) return failureWithError('No devices found');
      // The shared list is unmodifiable, so give each caller its own copy.
      return Result.success(allDevices.toList());
    }

    final devices = allDevices.where((d) => d.kind == kind).toList();
    if (devices.isEmpty) {
      return failureWithError('No devices found for kind: $kind');
    }
    return Result.success(devices);
  }

  Future<Result<List<RtcMediaDevice>>> _startEnumeration() {
    final enumeration = _enumerateAllDevices();
    _pendingEnumeration = enumeration;
    enumeration.whenComplete(() {
      if (identical(_pendingEnumeration, enumeration)) {
        _pendingEnumeration = null;
      }
    }).ignore();
    return enumeration;
  }

  Future<Result<List<RtcMediaDevice>>> _enumerateAllDevices() async {
    try {
      final devices = await rtc.navigator.mediaDevices.enumerateDevices();

      // Shared by every caller of a coalesced enumeration and every
      // [onDeviceChange] listener, so it must not be mutated.
      final mediaDevices = List<RtcMediaDevice>.unmodifiable([
        ...devices.map((it) {
          return RtcMediaDevice(
            id: it.deviceId,
            label: it.label,
            groupId: it.groupId,
            kind: RtcMediaDeviceKind.fromAlias(it.kind),
          );
        }),

        if (rtc.webRtcCapabilities.omitsEarpieceFromEnumeration &&
            devices.none(
              (d) => d.deviceId.equalsIgnoreCase(
                AudioDefaultDevice.earpiece,
              ),
            ))
          RtcMediaDevice(
            id: AudioDefaultDevice.earpiece,
            label: AudioDefaultDevice.earpiece.capitalizeFirstLetter(),
            kind: RtcMediaDeviceKind.audioOutput,
          ),
      ]);

      _tracer.trace(
        TraceTag.enumerateDevices,
        mediaDevices.map((device) => device.toJson()).toList(),
      );

      _devicesController.add(mediaDevices);

      return Result.success(mediaDevices);
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
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
