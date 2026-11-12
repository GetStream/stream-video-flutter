import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import '../stream_video_push_notification.dart';
import '../stream_video_push_notification_platform_interface.dart';
import 'manager/native_call_controller.dart';
import 'manager/push_device_registrar.dart';
import 'manager/push_token_source.dart';
import 'manager/ringing_event_broadcaster.dart';
import 'manager/ringing_sync_observer.dart';
import 'outgoing_call_reporter.dart';

/// Implementation of [PushNotificationManager] for Stream Video.
///
/// Composes the parts that do the work: [PushDeviceRegistrar] for the device
/// tokens, [NativeCallController] for the commands to the native call UI,
/// [RingingSyncObserver] for keeping that UI in step with the backend and
/// the app, and the shared [RingingEventBroadcaster] for the native events.
class StreamVideoPushNotificationManager implements PushNotificationManager {
  StreamVideoPushNotificationManager._({
    required CoordinatorClient client,
    required StreamVideo streamVideo,
    required this.iosPushProvider,
    required this.androidPushProvider,
    required this.pushConfiguration,
    this.registerApnDeviceToken = false,
  }) {
    _registrar = PushDeviceRegistrar(
      client: client,
      iosPushProvider: iosPushProvider,
      androidPushProvider: androidPushProvider,
      registerApnDeviceToken: registerApnDeviceToken,
      currentDeviceToken: getDevicePushTokenVoIP,
    );
    _controller = NativeCallController(
      configuration: pushConfiguration,
      broadcaster: _broadcaster,
    );

    if (!CurrentPlatform.isMobile) return;

    _observer = RingingSyncObserver(
      streamVideo: streamVideo,
      client: client,
      controller: _controller,
      broadcaster: _broadcaster,
      ringingEvents: onCallEvent,
    )..start();

    if (CurrentPlatform.isIos &&
        (pushConfiguration.ios?.reportOutgoingCalls ?? false)) {
      _outgoingCallReporter = OutgoingCallReporter(
        manager: this,
        outgoingCalls: streamVideo.state.outgoingCall,
        isActive: (call) => streamVideo.state.activeCalls.value.any(
          (active) => identical(active, call),
        ),
      );
    }
  }

  /// Preferences key of the last APNs token registered.
  static const userDeviceTokenKey = PushDeviceRegistrar.userDeviceTokenKey;

  /// Preferences key of the last provider token registered.
  static const userDeviceTokenVoIPKey =
      PushDeviceRegistrar.userDeviceTokenVoIPKey;

  /// Factory for creating a new instance of [StreamVideoPushNotificationManager].
  static StreamVideoPushNotificationManager Function(
    CoordinatorClient client,
    StreamVideo streamVideo,
  )
  create({
    required StreamVideoPushProvider iosPushProvider,
    required StreamVideoPushProvider androidPushProvider,
    StreamVideoPushConfiguration? pushConfiguration,
    bool registerApnDeviceToken = false,
  }) {
    return (CoordinatorClient client, StreamVideo streamVideo) {
      final configuration = _defaultPushConfiguration.merge(pushConfiguration);

      StreamVideoPushNotificationPlatform.instance.init(configuration.toJson());

      return StreamVideoPushNotificationManager._(
        client: client,
        streamVideo: streamVideo,
        iosPushProvider: iosPushProvider,
        androidPushProvider: androidPushProvider,
        pushConfiguration: configuration,
        registerApnDeviceToken: registerApnDeviceToken,
      );
    };
  }

  final StreamVideoPushProvider iosPushProvider;
  final StreamVideoPushProvider androidPushProvider;
  final StreamVideoPushConfiguration pushConfiguration;
  final bool registerApnDeviceToken;

  /// Registers and unregisters this device's push tokens.
  late final PushDeviceRegistrar _registrar;

  /// Sends the commands to the native call UI.
  late final NativeCallController _controller;

  /// Keeps the native call UI in step with the backend and the app. Only on
  /// mobile, where there is a native call UI.
  RingingSyncObserver? _observer;

  /// Set when [IOSPushConfiguration.reportOutgoingCalls] is on, on iOS.
  OutgoingCallReporter? _outgoingCallReporter;

  /// The one broadcaster of this process's ringing events; see
  /// [RingingEventBroadcaster.shared].
  final _broadcaster = RingingEventBroadcaster.shared;

  final _logger = taggedLogger(tag: 'SV:PNManager');

  @override
  void registerDevice() => _registrar.registerDevice();

  @override
  Future<void> unregisterDevice() => _registrar.unregisterDevice();

  @override
  Stream<RingingEvent> get onCallEvent {
    return _broadcaster.onEvent
        .doOnData((event) => _logger.v(() => '[onCallEvent] event: $event'))
        .share();
  }

  @override
  Future<void> showIncomingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  }) {
    return _controller.showIncomingCall(
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
    );
  }

  @override
  Future<void> showMissedCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  }) {
    return _controller.showMissedCall(
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
    );
  }

  @override
  Future<void> startOutgoingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  }) {
    return _controller.startOutgoingCall(
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
    );
  }

  @override
  Future<List<CallData>> activeCalls() => _controller.activeCalls();

  @override
  Future<void> endAllCalls() => _controller.endAllCalls();

  @override
  Future<void> endCall(String uuid) => _controller.endCall(uuid);

  /// Dismisses the ringing UI of a call that the user accepted and is now in.
  ///
  /// Not [endCallByCid]: on Android, ending disconnects the call from the
  /// Telecom stack, while dismissing leaves it registered so in-call controls
  /// on a watch, headset or car head unit keep working. On iOS the two are the
  /// same, since CallKit is the ring.
  Future<void> dismissRingingCallByCid(String cid) =>
      _controller.dismissRingingCallByCid(cid);

  @override
  Future<void> endCallByCid(String cid, {bool silent = false}) =>
      _controller.endCallByCid(cid, silent: silent);

  @override
  Future<void> setCallMutedByCid(String cid, bool isMuted) =>
      _controller.setCallMutedByCid(cid, isMuted);

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    if (CurrentPlatform.isIos) {
      return const VoIPTokenSource().token();
    } else if (CurrentPlatform.isAndroid) {
      return const FcmTokenSource().token();
    }

    return null;
  }

  @override
  Future<void> holdCall(String uuid, {bool isOnHold = true}) =>
      _controller.holdCall(uuid, isOnHold: isOnHold);

  @override
  Future<void> muteCall(String uuid, {bool isMuted = true}) =>
      _controller.muteCall(uuid, isMuted: isMuted);

  @override
  Future<void> setCallConnected(String uuid) =>
      _controller.setCallConnected(uuid);

  /// Reports how a call ended so it shows up correctly in the system call history.
  ///
  /// iOS only. CallKit lists every call it displayed in Recents, and the reason decides how: a
  /// call reported as [CallEndedReason.unanswered] appears as a missed call, while the default
  /// hang-up path lists it as a regular one. Has no effect on Android.
  Future<void> reportCallEnded(
    String uuid, {
    CallEndedReason reason = CallEndedReason.remoteEnded,
  }) => _controller.reportCallEnded(uuid, reason: reason);

  @override
  Future<void> dispose() async {
    _observer?.dispose();
    await _registrar.dispose();
    await _outgoingCallReporter?.dispose();
    _outgoingCallReporter = null;
  }

  static Future<void> ensureFullScreenIntentPermission() {
    return StreamVideoPushNotificationPlatform.instance
        .ensureFullScreenIntentPermission();
  }
}

const _defaultPushConfiguration = StreamVideoPushConfiguration(
  android: AndroidPushConfiguration(
    ringtonePath: 'system_ringtone_default',
    incomingCallNotificationChannelName: 'Incoming Call',
    missedCallNotification: MissedCallNotificationParams(
      showNotification: true,
      showCallbackButton: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    // No colours: the plugin's own resources carry the design's, and naming
    // one here would mean the default could only be changed in two places.
    incomingCallNotification: IncomingCallNotificationParams(
      fullScreenShowLogo: false,
    ),
  ),
  ios: IOSPushConfiguration(
    handleType: 'generic',
    supportsVideo: true,
    maximumCallGroups: 1,
    audioSessionMode: 'default',
    audioSessionPreferredSampleRate: 44100,
    audioSessionPreferredIOBufferDuration: 0.005,
    supportsDTMF: true,
    supportsHolding: false,
    supportsGrouping: false,
    supportsUngrouping: false,
    ringtonePath: 'system_ringtone_default',
  ),
);
