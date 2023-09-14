import 'dart:async';
import 'dart:io';

import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

import 'stream_video_push_params.dart';
import 'stream_video_push_provider.dart';

class StreamVideoPushNotificationManager implements PushNotificationManager {
  static create({
    required StreamVideoPushProvider iosPushProvider,
    required StreamVideoPushProvider androidPushProvider,
    VideoPushParams? pushParams,
  }) {
    return (CoordinatorClient client) {
      return StreamVideoPushNotificationManager._(
        client: client,
        iosPushProvider: iosPushProvider,
        androidPushProvider: androidPushProvider,
        pushParams: _defaultPushParams.merge(pushParams),
      );
    };
  }

  StreamVideoPushNotificationManager._({
    required CoordinatorClient client,
    required this.iosPushProvider,
    required this.androidPushProvider,
    this.pushParams = _defaultPushParams,
  }) : _client = client;

  final CoordinatorClient _client;
  final StreamVideoPushProvider iosPushProvider;
  final StreamVideoPushProvider androidPushProvider;
  final VideoPushParams pushParams;

  final _logger = taggedLogger(tag: 'SV:PNManager');

  StreamSubscription<String>? _tokenSubscription;

  @override
  void registerDevice() {
    final pushProvider = switch (CurrentPlatform.type) {
      PlatformType.ios => iosPushProvider,
      PlatformType.android => androidPushProvider,
      _ => null,
    };

    // TODO: Log error.
    if (pushProvider == null) return;

    void registerDevice(String token) {
      _client.createDevice(
        id: token,
        voipToken: pushProvider.isVoIP,
        pushProvider: pushProvider.type,
        pushProviderName: pushProvider.name,
      );
    }

    _tokenSubscription ??= pushProvider.onTokenRefresh.listen(registerDevice);
  }

  @override
  void unregisterDevice() {
    // TODO: Fetch token from the client and delete it.
    _client.deleteDevice(id: 'id');

    _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }

  @override
  Stream<CallKitEvent> get onCallEvent => FlutterCallkitIncoming.onEvent
      .whereType<CallEvent>()
      .map((event) => event.toCallKitEvent());

  @override
  Future<void> showIncomingCall({
    required String uuid,
    required StreamCallCid callCid,
    String? avatar,
    String? nameCaller,
    bool hasVideo = true,
  }) {
    final params = pushParams.copyWith(
      id: uuid,
      avatar: avatar,
      handle: callCid.value,
      nameCaller: nameCaller,
      type: hasVideo ? 1 : 0,
      extra: {
        'incomingCallCid': callCid.value,
      },
    );

    return FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  @override
  Future<void> showMissedCall({
    required String uuid,
    required StreamCallCid callCid,
    String? avatar,
    String? nameCaller,
    bool hasVideo = true,
  }) {
    final params = pushParams.copyWith(
      id: uuid,
      avatar: avatar,
      handle: callCid.value,
      nameCaller: nameCaller,
      type: hasVideo ? 1 : 0,
      extra: {
        'incomingCallCid': callCid.value,
      },
    );

    return FlutterCallkitIncoming.showMissCallNotification(params);
  }

  @override
  Future<void> startOutgoingCall({
    required String uuid,
    required StreamCallCid callCid,
    String? avatar,
    String? nameCaller,
    bool hasVideo = true,
  }) {
    final params = pushParams.copyWith(
      id: uuid,
      avatar: avatar,
      handle: callCid.value,
      nameCaller: nameCaller,
      type: hasVideo ? 1 : 0,
      extra: {
        'incomingCallCid': callCid.value,
      },
    );

    return FlutterCallkitIncoming.startCall(params);
  }

  @override
  Future<void> activeCalls() => FlutterCallkitIncoming.activeCalls();

  @override
  Future<void> endAllCalls() => FlutterCallkitIncoming.endAllCalls();

  @override
  Future<void> endCall(String uuid) => FlutterCallkitIncoming.endCall(uuid);

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    if (Platform.isIOS) {
      return await StreamTokenProvider.getAPNsToken();
    } else if (Platform.isAndroid) {
      return await StreamTokenProvider.getFirebaseToken();
    }

    return null;
  }

  @override
  Future<void> holdCall(String uuid, {bool isOnHold = true}) {
    return FlutterCallkitIncoming.holdCall(uuid, isOnHold: isOnHold);
  }

  @override
  Future<void> muteCall(String uuid, {bool isMuted = true}) {
    return FlutterCallkitIncoming.muteCall(uuid, isMuted: isMuted);
  }

  @override
  Future<void> setCallConnected(uuid) {
    return FlutterCallkitIncoming.setCallConnected(uuid);
  }

  @override
  Future<void> dispose() async {
    _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }
}

const _defaultPushParams = VideoPushParams(
  duration: 30000,
  textAccept: 'Accept',
  textDecline: 'Decline',
  missedCallNotification: NotificationParams(
    showNotification: true,
    isShowCallback: true,
    subtitle: 'Missed call',
    callbackText: 'Call back',
  ),
  android: AndroidParams(
    isCustomNotification: true,
    isShowLogo: false,
    ringtonePath: 'system_ringtone_default',
    backgroundColor: '#0955fa',
    actionColor: '#4CAF50',
    incomingCallNotificationChannelName: "Incoming Call",
  ),
  ios: IOSParams(
    iconName: 'CallKitLogo',
    handleType: 'generic',
    supportsVideo: true,
    maximumCallGroups: 2,
    maximumCallsPerCallGroup: 1,
    audioSessionMode: 'default',
    audioSessionActive: true,
    audioSessionPreferredSampleRate: 44100.0,
    audioSessionPreferredIOBufferDuration: 0.005,
    supportsDTMF: true,
    supportsHolding: true,
    supportsGrouping: false,
    supportsUngrouping: false,
    ringtonePath: 'system_ringtone_default',
  ),
);

extension on CallEvent {
  CallKitEvent toCallKitEvent() {
    return switch (event) {
      Event.actionDidUpdateDevicePushTokenVoip =>
        ActionDidUpdateDevicePushTokenVoip(body),
      Event.actionCallIncoming => ActionCallIncoming(body),
      Event.actionCallStart => ActionCallStart(body),
      Event.actionCallAccept => ActionCallAccept(body),
      Event.actionCallDecline => ActionCallDecline(body),
      Event.actionCallEnded => ActionCallEnded(body),
      Event.actionCallTimeout => ActionCallTimeout(body),
      Event.actionCallCallback => ActionCallCallback(body),
      Event.actionCallToggleHold => ActionCallToggleHold(body),
      Event.actionCallToggleMute => ActionCallToggleMute(body),
      Event.actionCallToggleDmtf => ActionCallToggleDmtf(body),
      Event.actionCallToggleGroup => ActionCallToggleGroup(body),
      Event.actionCallToggleAudioSession => ActionCallToggleAudioSession(body),
      Event.actionCallCustom => ActionCallCustom(body),
    };
  }
}
