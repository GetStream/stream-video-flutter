import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_video/stream_video.dart';

import '../../stream_video_push_notification_platform_interface.dart';
import '../stream_video_push_configuration.dart';
import '../stream_video_push_params.dart';
import 'ringing_event_broadcaster.dart';

/// Decides what [NativeCallController.endCallByCid] has to end for [cid].
@visibleForTesting
({bool endAll, List<CallData> calls}) resolveCallsToEnd(
  List<CallData> activeCalls,
  String cid,
) {
  final matching = activeCalls
      .where((call) => call.callCid == cid && call.uuid != null)
      .toList();

  // Every active call belongs to this cid, so ending them one by one and ending them all are the
  // same thing. This also covers a platform that reports no calls while still holding one, which
  // is what the Android Telecom sweep in `endAllCalls` relies on.
  if (activeCalls.length == matching.length) {
    return (endAll: true, calls: const []);
  }

  // Calls the platform still has but that can no longer be identified: iOS reports a CallKit call
  // that outlived the process that created it with its uuid only. They are ended too.
  final unidentified = activeCalls
      .where((call) => call.callCid == null && call.uuid != null)
      .toList();

  // Anything still identifiable that belongs to another cid is deliberately left alone.
  return (endAll: false, calls: [...matching, ...unidentified]);
}

/// The commands the SDK sends to the native call UI (CallKit on iOS, the
/// notification and Telecom on Android), with the platform rules that go
/// with them: which platform a command exists on, how a call is found by its
/// cid, and which native echo of a command has to be suppressed.
@internal
class NativeCallController {
  NativeCallController({
    required this.configuration,
    required this._broadcaster,
    this._platform,
  });

  /// The push configuration every call's params are built from.
  final StreamVideoPushConfiguration configuration;

  final RingingEventBroadcaster _broadcaster;
  final StreamVideoPushNotificationPlatform? _platform;

  final _logger = taggedLogger(tag: 'SV:NativeCallController');

  /// The audio output last asked of Telecom for each call cid, sent again
  /// once an outgoing call the app starts after joining is registered.
  /// Android only.
  final _audioOutputs = <String, RtcMediaDevice>{};

  StreamVideoPushNotificationPlatform get _resolvedPlatform =>
      _platform ?? StreamVideoPushNotificationPlatform.instance;

  Future<void> showIncomingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
    Duration? ringTimeout,
  }) {
    final params = StreamVideoPushParams.forCall(
      configuration,
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
      ringTimeout: ringTimeout,
    );

    return _resolvedPlatform.showIncomingCall(params);
  }

  Future<void> showMissedCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  }) {
    final params = StreamVideoPushParams.forCall(
      configuration,
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
    );

    return _resolvedPlatform.showMissCallNotification(params);
  }

  Future<void> startOutgoingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  }) async {
    final params = StreamVideoPushParams.forCall(
      configuration,
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
    );

    await _resolvedPlatform.startCall(params);

    // Telecom holds the call only from here, so an output picked while
    // joining before has to be asked for again. Not awaited, as the output
    // can take seconds to appear.
    if (_audioOutputs[callCid] case final device?) {
      unawaited(
        setCallAudioOutputDeviceByCid(callCid, device).catchError((
          Object e,
          StackTrace stk,
        ) {
          _logger.w(() => '[startOutgoingCall] output not routed: $e\n$stk');
        }),
      );
    }
  }

  /// The calls the native side currently shows or tracks; none off mobile.
  Future<List<CallData>> activeCalls() async {
    if (!CurrentPlatform.isMobile) return [];

    return _resolvedPlatform.activeCalls();
  }

  Future<void> endAllCalls() {
    _audioOutputs.clear();
    return _resolvedPlatform.endAllCalls();
  }

  Future<void> endCall(String uuid) => _resolvedPlatform.endCall(uuid);

  /// Ends the ring of the calls with [cid] for [reason], by default because
  /// the user accepted the call and is now in it.
  ///
  /// Not [endCallByCid]. On Android, dismissing as accepted leaves the call
  /// registered with the Telecom stack so in-call controls on a watch, headset
  /// or car head unit keep working, and every reason is reported with the
  /// dismissal; see [StreamVideoPushNotificationPlatform.dismissRingingCall].
  /// On iOS this ends the call silently, since CallKit has nothing else to
  /// dismiss and the end is not the user declining or hanging up.
  Future<void> dismissRingingCallByCid(
    String cid, {
    CallDismissReason reason = CallDismissReason.accepted,
  }) {
    if (CurrentPlatform.isIos) return endCallByCid(cid, silent: true);
    return _resolvedPlatform.dismissRingingCall(cid, reason: reason);
  }

  /// Ends the ring of [cid], which is over before the user answered it on
  /// this device, without its end being reported as the user declining it.
  ///
  /// Ends nothing when the native side shows no ring of [cid], since the
  /// sweep [resolveCallsToEnd] falls back to would reach other calls, or when
  /// the user answered it on the native call screen: the client that takes it
  /// over owns it. Mobile only.
  Future<void> ringEnded(String cid) async {
    if (!CurrentPlatform.isMobile) return;

    final active = await activeCalls();
    if (!_showsUnansweredRing(active, cid)) return;

    await _end(active, cid, silent: true);
  }

  /// Ends the native call of [cid], a call the user answered on this device
  /// and is done with, its end reported as usual. Ends nothing when the
  /// native side lists no call of [cid], such as a call that never rang:
  /// every call the native side holds is listed, so the sweep
  /// [resolveCallsToEnd] falls back to would only reach other calls. Mobile
  /// only.
  Future<void> callLeft(String cid) async {
    if (!CurrentPlatform.isMobile) return;

    final active = await activeCalls();
    if (!active.any((call) => call.callCid == cid)) return;

    await _end(active, cid, silent: false);
  }

  /// Dismisses the ring of [cid], which the user accepted in the app, when
  /// the native side still shows it unanswered; the call goes on. Mobile
  /// only.
  Future<void> callAccepted(String cid) async {
    if (!CurrentPlatform.isMobile) return;

    final active = await activeCalls();
    if (!_showsUnansweredRing(active, cid)) return;

    // As [dismissRingingCallByCid] does, with the calls already read.
    if (CurrentPlatform.isIos) return _end(active, cid, silent: true);
    await _resolvedPlatform.dismissRingingCall(cid);
  }

  // Whether [active] has a call of [cid] and none of them is answered.
  bool _showsUnansweredRing(List<CallData> active, String cid) {
    final calls = active.where((call) => call.callCid == cid);
    return calls.isNotEmpty && !calls.any((call) => call.isAccepted);
  }

  /// Ends the native calls of [cid], see [resolveCallsToEnd]. Mobile only.
  ///
  /// With [silent], the reports of their end that carry [cid] are
  /// suppressed, while events of other calls still arrive, and nothing is
  /// ended when the native side lists no call of [cid]: the sweep that
  /// [resolveCallsToEnd] falls back to would also reach calls that only the
  /// Android Telecom stack still holds, such as an accepted call whose ring
  /// was dismissed.
  Future<void> endCallByCid(String cid, {bool silent = false}) async {
    if (!CurrentPlatform.isMobile) return;

    final active = await activeCalls();
    if (silent && !active.any((call) => call.callCid == cid)) return;

    await _end(active, cid, silent: silent);
  }

  // Ends the native calls of [cid] among [active], see [resolveCallsToEnd].
  Future<void> _end(
    List<CallData> active,
    String cid, {
    required bool silent,
  }) async {
    _audioOutputs.remove(cid);
    final decision = resolveCallsToEnd(active, cid);
    if (silent) _broadcaster.suppressCallEnd(cid);

    if (decision.endAll) {
      await endAllCalls();
      return;
    }

    for (final call in decision.calls) {
      await endCall(call.uuid!);
    }
  }

  /// Mirrors the app's microphone state on the CallKit screen. iOS only.
  Future<void> setCallMutedByCid(String cid, bool isMuted) async {
    // Muting call on CallKit screen
    if (!CurrentPlatform.isIos) {
      return;
    }

    final activeCalls = await this.activeCalls();
    final calls = activeCalls
        .where((call) => call.callCid == cid && call.uuid != null)
        .toList();

    for (final call in calls) {
      // Suppress CallKit event to avoid loop
      _broadcaster.suppressEvent(
        eventType: ActionCallToggleMute,
        valueKey: isMuted.toString(),
      );

      await _resolvedPlatform.muteCall(call.uuid!, isMuted: isMuted);
    }
  }

  /// Routes the audio of the calls with [cid] to [device] in Telecom, which
  /// owns the audio route of a call it holds. Android only. An outgoing call
  /// started later with [startOutgoingCall] asks for [device] again.
  ///
  /// Does nothing for a device Telecom has no endpoint for. When Telecom does
  /// not route the call there, that is logged; the SDK has picked the device
  /// for WebRTC either way.
  Future<void> setCallAudioOutputDeviceByCid(
    String cid,
    RtcMediaDevice device,
  ) async {
    if (!CurrentPlatform.isAndroid) return;

    _audioOutputs[cid] = device;
    final endpoint = TelecomAudioEndpoint.fromAudioOutput(device);
    if (endpoint == null) {
      _logger.d(
        () => '[setCallAudioOutputDeviceByCid] no endpoint for $device',
      );
      return;
    }

    // The label is the device's name, which tells Bluetooth headsets apart.
    final routed = await _resolvedPlatform.requestAudioEndpoint(
      cid,
      endpoint,
      name: device.label.isEmpty ? null : device.label,
    );
    if (!routed) {
      _logger.d(
        () =>
            '[setCallAudioOutputDeviceByCid] Telecom did not route $cid to '
            '${endpoint.name}; fine when the integration does not hold it',
      );
    }
  }

  Future<void> holdCall(String uuid, {bool isOnHold = true}) {
    return _resolvedPlatform.holdCall(uuid, isOnHold: isOnHold);
  }

  Future<void> muteCall(String uuid, {bool isMuted = true}) {
    return _resolvedPlatform.muteCall(uuid, isMuted: isMuted);
  }

  Future<void> setCallConnected(String uuid) {
    return _resolvedPlatform.setCallConnected(uuid);
  }

  /// Reports how a call ended so it shows up correctly in the system call history.
  ///
  /// iOS only. CallKit lists every call it displayed in Recents, and the reason decides how: a
  /// call reported as [CallEndedReason.unanswered] appears as a missed call, while the default
  /// hang-up path lists it as a regular one. Has no effect on Android.
  Future<void> reportCallEnded(
    String uuid, {
    CallEndedReason reason = CallEndedReason.remoteEnded,
  }) {
    return _resolvedPlatform.reportCallEnded(uuid, reason);
  }
}
