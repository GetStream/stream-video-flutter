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

  StreamVideoPushNotificationPlatform get _resolvedPlatform =>
      _platform ?? StreamVideoPushNotificationPlatform.instance;

  Future<void> showIncomingCall({
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

    return _resolvedPlatform.startCall(params);
  }

  /// The calls the native side currently shows or tracks; none off mobile.
  Future<List<CallData>> activeCalls() async {
    if (!CurrentPlatform.isMobile) return [];

    return _resolvedPlatform.activeCalls();
  }

  Future<void> endAllCalls() => _resolvedPlatform.endAllCalls();

  Future<void> endCall(String uuid) => _resolvedPlatform.endCall(uuid);

  /// Ends the ring of the calls with [cid] for [reason], by default because
  /// the user accepted the call and is now in it.
  ///
  /// Not [endCallByCid]. On Android, dismissing as accepted leaves the call
  /// registered with the Telecom stack so in-call controls on a watch, headset
  /// or car head unit keep working, and every reason is reported with the
  /// dismissal; see [StreamVideoPushNotificationPlatform.dismissRingingCall].
  /// On iOS this ends the call, since CallKit has nothing else to dismiss.
  Future<void> dismissRingingCallByCid(
    String cid, {
    CallDismissReason reason = CallDismissReason.accepted,
  }) {
    if (CurrentPlatform.isIos) return endCallByCid(cid);
    return _resolvedPlatform.dismissRingingCall(cid, reason: reason);
  }

  /// Ends the native calls of [cid], see [resolveCallsToEnd]. With [silent],
  /// the native events the end produces are suppressed.
  Future<void> endCallByCid(String cid, {bool silent = false}) async {
    final decision = resolveCallsToEnd(await activeCalls(), cid);

    if (decision.endAll) {
      if (silent) _broadcaster.suppressEvent();
      await endAllCalls();
      return;
    }

    for (final call in decision.calls) {
      if (silent) _broadcaster.suppressEvent();
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
  /// owns the audio route of a call it holds. Android only.
  ///
  /// Does nothing for a device Telecom has no endpoint for. When Telecom does
  /// not route the call there, that is logged; the SDK has picked the device
  /// for WebRTC either way.
  Future<void> setCallAudioOutputDeviceByCid(
    String cid,
    RtcMediaDevice device,
  ) async {
    if (!CurrentPlatform.isAndroid) return;

    final endpoint = TelecomAudioEndpoint.fromAudioOutput(device);
    if (endpoint == null) {
      _logger.d(
        () => '[setCallAudioOutputDeviceByCid] no endpoint for $device',
      );
      return;
    }

    final routed = await _resolvedPlatform.requestAudioEndpoint(cid, endpoint);
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
