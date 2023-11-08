import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

import 'stream_video_push_params.dart';

part 'stream_video_push_provider.dart';

/// Implementation of [PushNotificationManager] for Stream Video.
class StreamVideoPushNotificationManager implements PushNotificationManager {
  /// Factory for creating a new instance of [StreamVideoPushNotificationManager].
  static create({
    required StreamVideoPushProvider iosPushProvider,
    required StreamVideoPushProvider androidPushProvider,
    StreamVideoPushParams? pushParams,
  }) {
    return (CoordinatorClient client) {
      final params = _defaultPushParams.merge(pushParams);

      StreamVideoPushNotificationPlatform.instance.initData(params.toJson());

      return StreamVideoPushNotificationManager._(
        client: client,
        iosPushProvider: iosPushProvider,
        androidPushProvider: androidPushProvider,
        pushParams: params,
      );
    };
  }

  StreamVideoPushNotificationManager._({
    required CoordinatorClient client,
    required this.iosPushProvider,
    required this.androidPushProvider,
    required this.pushParams,
  }) : _client = client;

  final CoordinatorClient _client;
  final StreamVideoPushProvider iosPushProvider;
  final StreamVideoPushProvider androidPushProvider;
  final StreamVideoPushParams pushParams;

  final _logger = taggedLogger(tag: 'SV:PNManager');

  StreamSubscription<String>? _tokenSubscription;

  @override
  void registerDevice() {
    final pushProvider = switch (CurrentPlatform.type) {
      PlatformType.ios => iosPushProvider,
      PlatformType.android => androidPushProvider,
      _ => null,
    };

    if (pushProvider == null) {
      _logger.w(() => 'Cannot register device: unsupported platform');
      return;
    }

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
  void unregisterDevice() async {
    final token = await getDevicePushTokenVoIP();
    if (token == null) return;

    _client.deleteDevice(id: token);

    _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }

  @override
  Stream<CallKitEvent> get onCallEvent {
    return StreamCallKit()
        .onEvent
        .map((event) => event.toCallKitEvent())
        .doOnData((event) => _logger.v(() => '[onCallKitEvent] event: $event'));
  }

  @override
  Future<void> showIncomingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? nameCaller,
    bool hasVideo = true,
  }) {
    final params = pushParams.copyWith(
      id: uuid,
      avatar: avatar,
      handle: pushParams.incomingCallerHandlerOverride ?? handle,
      nameCaller: pushParams.incomingCallerNameOverride ?? nameCaller,
      type: hasVideo ? 1 : 0,
      extra: {'callCid': callCid},
    );

    return FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  @override
  Future<void> showMissedCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? nameCaller,
    bool hasVideo = true,
  }) {
    final params = pushParams.copyWith(
      id: uuid,
      avatar: avatar,
      handle: pushParams.incomingCallerHandlerOverride ?? handle,
      nameCaller: pushParams.incomingCallerNameOverride ?? nameCaller,
      type: hasVideo ? 1 : 0,
      extra: {'callCid': callCid},
    );

    return FlutterCallkitIncoming.showMissCallNotification(params);
  }

  @override
  Future<void> startOutgoingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? nameCaller,
    bool hasVideo = true,
  }) {
    final params = pushParams.copyWith(
      id: uuid,
      avatar: avatar,
      handle: handle,
      nameCaller: nameCaller,
      type: hasVideo ? 1 : 0,
      extra: {'callCid': callCid},
    );

    return FlutterCallkitIncoming.startCall(params);
  }

  @override
  Future<List<CallData>> activeCalls() async {
    final activeCalls = await FlutterCallkitIncoming.activeCalls();
    if (activeCalls is! List) return [];

    final calls = <CallData>[];
    for (final call in activeCalls) {
      try {
        final callJson = call.cast<String, dynamic>();
        calls.add(_callDataFromJson(callJson));
      } catch (_) {
        continue;
      }
    }

    return calls;
  }

  @override
  Future<void> endAllCalls() => FlutterCallkitIncoming.endAllCalls();

  @override
  Future<void> endCall(String uuid) => FlutterCallkitIncoming.endCall(uuid);

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    if (Platform.isIOS) {
      return await StreamTokenProvider.getVoIPToken();
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

const _defaultPushParams = StreamVideoPushParams(
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
    handleType: 'generic',
    supportsVideo: true,
    maximumCallGroups: 1,
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

CallData _callDataFromJson(Map<String, dynamic> json) {
  final extraData = json['extra']?.cast<String, dynamic>();
  return CallData(
    uuid: json['id'] as String?,
    callCid: extraData?['callCid'] as String?,
    avatar: json['avatar'] as String?,
    handle: json['handle'] as String?,
    nameCaller: json['nameCaller'] as String?,
    hasVideo: json['type'] == 1,
    extraData: extraData,
  );
}

extension on CallEvent {
  CallData toCallData() => _callDataFromJson(body);

  CallKitEvent toCallKitEvent() {
    return switch (event) {
      Event.actionCallIncoming => ActionCallIncoming(data: toCallData()),
      Event.actionCallStart => ActionCallStart(data: toCallData()),
      Event.actionCallAccept => ActionCallAccept(data: toCallData()),
      Event.actionCallDecline => ActionCallDecline(data: toCallData()),
      Event.actionCallEnded => ActionCallEnded(data: toCallData()),
      Event.actionCallTimeout => ActionCallTimeout(data: toCallData()),
      Event.actionCallCallback => ActionCallCallback(data: toCallData()),
      Event.actionDidUpdateDevicePushTokenVoip =>
        ActionDidUpdateDevicePushTokenVoip(
          token: body['deviceTokenVoIP'] as String,
        ),
      Event.actionCallToggleHold => ActionCallToggleHold(
          uuid: body['id'] as String,
          isOnHold: body['isOnHold'] as bool,
        ),
      Event.actionCallToggleMute => ActionCallToggleMute(
          uuid: body['id'] as String,
          isMuted: body['isMuted'] as bool,
        ),
      Event.actionCallToggleDmtf => ActionCallToggleDmtf(
          uuid: body['id'] as String,
          digits: body['digits'] as String,
        ),
      Event.actionCallToggleGroup => ActionCallToggleGroup(
          uuid: body['id'] as String,
          callUUIDToGroupWith: body['callUUIDToGroupWith'] as String,
        ),
      Event.actionCallToggleAudioSession => ActionCallToggleAudioSession(
          isActivate: body['isActivate'] as bool,
        ),
      Event.actionCallCustom => ActionCallCustom(body),
    };
  }
}

/// Wrapper class to support multiple subscriptions to the
/// [FlutterCallkitIncoming.onEvent] stream.
final class StreamCallKit {
  factory StreamCallKit() => _singleton ??= StreamCallKit._();

  StreamCallKit._();

  static StreamCallKit? _singleton;

  StreamController<CallEvent>? _controller;

  /// Returns a Stream of [CallEvent].
  Stream<CallEvent> get onEvent {
    _controller ??= StreamController<CallEvent>.broadcast(
      onListen: _startListenEvent,
      onCancel: _stopListenEvent,
    );
    return _controller!.stream;
  }

  StreamSubscription<CallEvent?>? _eventSubscription;

  Future<void> _startListenEvent() async {
    _eventSubscription ??= FlutterCallkitIncoming.onEvent.listen((event) {
      if (event != null) _controller?.add(event);
    });
  }

  Future<void> _stopListenEvent() async {
    await _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}
