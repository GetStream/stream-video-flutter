import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart' hide CallEvent;
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

import 'stream_video_push_params.dart';

part 'stream_video_push_provider.dart';

const _idToken = 1;
const _idCallKitIncoming = 2;
const _idCallEnded = 3;
const _idCallAccepted = 4;
const _idCallKitAcceptDecline = 5;
const _idCallRejected = 6;
const _idCallParticipantCount = 7;

/// Implementation of [PushNotificationManager] for Stream Video.
class StreamVideoPushNotificationManager implements PushNotificationManager {
  static const userDeviceTokenKey = 'io.getstream.userDeviceToken';
  static const userDeviceTokenVoIPKey = 'io.getstream.userDeviceTokenVoIP';

  /// Factory for creating a new instance of [StreamVideoPushNotificationManager].
  ///   /// Parameters:
  /// * [callerCustomizationCallback] callback providing customized caller data used for call screen and CallKit call. (for iOS this will only work for foreground calls)
  /// * [backgroundVoipCallHandler] handler called when there is a VoIP call and app is in terminated state (for iOS only) - this handler must be a top-level function
  /// refer to documentation for more details (https://getstream.io/video/docs/flutter/advanced/ringing_and_callkit/#integrating-apns-for-ios)
  static create({
    required StreamVideoPushProvider iosPushProvider,
    required StreamVideoPushProvider androidPushProvider,
    CallerCustomizationFunction? callerCustomizationCallback,
    BackgroundVoipCallHandler? backgroundVoipCallHandler,
    StreamVideoPushParams? pushParams,
    bool registerApnDeviceToken = false,
  }) {
    return (CoordinatorClient client, StreamVideo streamVideo) {
      final params = _defaultPushParams.merge(pushParams);

      if (CurrentPlatform.isIos) {
        StreamVideoPushNotificationPlatform.instance.init(
          params.toJson(),
          callerCustomizationCallback,
          backgroundVoipCallHandler,
        );
      }

      return StreamVideoPushNotificationManager._(
        client: client,
        streamVideo: streamVideo,
        iosPushProvider: iosPushProvider,
        androidPushProvider: androidPushProvider,
        pushParams: params,
        callerCustomizationCallback: callerCustomizationCallback,
        registerApnDeviceToken: registerApnDeviceToken,
      );
    };
  }

  StreamVideoPushNotificationManager._({
    required CoordinatorClient client,
    required StreamVideo streamVideo,
    required this.iosPushProvider,
    required this.androidPushProvider,
    required this.pushParams,
    this.callerCustomizationCallback,
    this.registerApnDeviceToken = false,
  }) : _client = client {
    if (CurrentPlatform.isWeb) return;

    SharedPreferences.getInstance().then((prefs) => _sharedPreferences = prefs);

    subscribeToEvents() {
      _subscriptions.add(
        _idCallEnded,
        client.events.on<CoordinatorCallEndedEvent>(
          (event) {
            _logger.d(
                () => '[subscribeToEvents] Call ended event: ${event.callCid}');
            endCallByCid(event.callCid.toString());
          },
        ),
      );

      _subscriptions.add(
        _idCallParticipantCount,
        client.events.on<CoordinatorCallSessionParticipantCountUpdatedEvent>(
          (event) async {
            final totalCount = event.participantsCountByRole.values
                .map((v) => v)
                .reduce((a, b) => a + b);

            _logger.d(() =>
                '[subscribeToEvents] Participant count updated event: ${event.callCid}, count: $totalCount');
            if (totalCount == 0) {
              _logger.v(() =>
                  '[subscribeToEvents] No participants left, ending call: ${event.callCid}');
              endCallByCid(event.callCid.toString());
            }
          },
        ),
      );

      _subscriptions.add(
        _idCallRejected,
        client.events.on<CoordinatorCallRejectedEvent>(
          (event) async {
            _logger.d(() =>
                '[subscribeToEvents] Call rejected event: ${event.callCid}, rejected by: ${event.rejectedByUserId}');
            if (event.rejectedByUserId == event.metadata.details.createdBy.id ||
                event.rejectedByUserId == streamVideo.currentUser.id) {
              _logger.v(() =>
                  '[subscribeToEvents] Call rejected by the current user or call owner, ending call: ${event.callCid}');
              endCallByCid(event.callCid.toString());
            }
          },
        ),
      );

      _subscriptions.add(
        _idCallAccepted,
        client.events.on<CoordinatorCallAcceptedEvent>(
          (event) async {
            _logger.d(() =>
                '[subscribeToEvents] Call accepted event: ${event.callCid}, accepted by: ${event.acceptedByUserId}');
            if (event.acceptedByUserId != streamVideo.currentUser.id) return;

            // end CallKit call on other devices if the call was accepted on one of them
            if (streamVideo.activeCall?.state.value.status
                is! CallStatusActive) {
              _logger.v(() =>
                  '[subscribeToEvents] Call accepted on other device, ending call: ${event.callCid}');
              await endCallByCid(event.callCid.toString());
            }

            // if the call was accepted on the same device, end the CallKit call silently
            // (in case it was accepted from the app and not from the CallKit UI)
            else {
              _logger.v(() =>
                  '[subscribeToEvents] Call accepted on the same device, ending CallKit silently: ${event.callCid}');
              await FlutterCallkitIncoming.silenceEvents();
              await endCallByCid(event.callCid.toString());
              await Future<void>.delayed(const Duration(milliseconds: 300));
              await FlutterCallkitIncoming.unsilenceEvents();
            }
          },
        ),
      );
    }

    //if there are active calls (for iOS) when connecting, subscribe to events as if the call was incoming
    FlutterCallkitIncoming.activeCalls().then((value) {
      if (value is List && value.isNotEmpty) {
        subscribeToEvents();
      }
    });

    _subscriptions.add(
      _idCallKitIncoming,
      onCallEvent.whereType<ActionCallIncoming>().listen(
        (_) {
          if (!client.isConnected) {
            _wasWsConnected = client.isConnected;
            client.openConnection();
          }

          subscribeToEvents();
        },
      ),
    );

    _subscriptions.add(
      _idCallKitAcceptDecline,
      onCallEvent.whereType<ActionCallAccept>().map((_) => null).mergeWith([
        onCallEvent.whereType<ActionCallDecline>().map((_) => null),
        onCallEvent.whereType<ActionCallTimeout>().map((_) => null),
      ]).listen(
        (_) {
          if (_wasWsConnected == false) {
            _wasWsConnected = null;
            client.closeConnection();
          }

          _subscriptions.cancel(_idCallAccepted);
          _subscriptions.cancel(_idCallEnded);
          _subscriptions.cancel(_idCallRejected);
          _subscriptions.cancel(_idCallParticipantCount);
        },
      ),
    );
  }

  final CoordinatorClient _client;
  final StreamVideoPushProvider iosPushProvider;
  final StreamVideoPushProvider androidPushProvider;
  final StreamVideoPushParams pushParams;
  final CallerCustomizationFunction? callerCustomizationCallback;
  final bool registerApnDeviceToken;
  late SharedPreferences _sharedPreferences;

  final _logger = taggedLogger(tag: 'SV:PNManager');
  bool? _wasWsConnected;

  final Subscriptions _subscriptions = Subscriptions();

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

    void registerDevice(String token, bool isVoIP) async {
      final tokenKey = isVoIP ? userDeviceTokenVoIPKey : userDeviceTokenKey;

      final storedToken = _sharedPreferences.getString(tokenKey);
      if (storedToken == token) return;

      _client
          .createDevice(
        id: token,
        voipToken: isVoIP,
        pushProvider: pushProvider.type,
        pushProviderName: pushProvider.name,
      )
          .then((result) {
        if (result is Success) {
          _sharedPreferences.setString(tokenKey, token);
        }
      });
    }

    if (CurrentPlatform.isIos && registerApnDeviceToken) {
      StreamTokenProvider.getAPNToken().then((token) {
        if (token != null) {
          registerDevice(token, false);
        }
      });
    }

    _subscriptions.addIfAbsent(
        _idToken,
        () => pushProvider.onTokenRefresh
            .listen((token) => registerDevice(token, true)));
  }

  Future<void> removedStoredTokens() async {
    await _sharedPreferences.remove(userDeviceTokenKey);
    await _sharedPreferences.remove(userDeviceTokenVoIPKey);
  }

  @override
  void unregisterDevice() async {
    final token = await getDevicePushTokenVoIP();
    if (token != null) {
      _client.deleteDevice(id: token);
      _subscriptions.cancel(_idToken);
    }

    final apnToken = await StreamTokenProvider.getAPNToken();
    if (apnToken != null) {
      _client.deleteDevice(id: apnToken);
    }

    removedStoredTokens();
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
    final customData = callerCustomizationCallback?.call(
      callCid: callCid,
      callerName: nameCaller,
      callerHandle: handle,
    );

    final params = pushParams.copyWith(
      id: uuid,
      avatar: customData?.avatar ?? avatar,
      handle: customData?.handle ?? handle,
      nameCaller: customData?.name ?? nameCaller,
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
    final customData = callerCustomizationCallback?.call(
      callCid: callCid,
      callerName: nameCaller,
      callerHandle: handle,
    );

    final params = pushParams.copyWith(
      id: uuid,
      avatar: customData?.avatar ?? avatar,
      handle: customData?.handle ?? handle,
      nameCaller: customData?.name ?? nameCaller,
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
    if (CurrentPlatform.isWeb) return [];

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

  Future<void> endCallByCid(String cid) async {
    final activeCalls = await this.activeCalls();
    final calls =
        activeCalls.where((call) => call.callCid == cid && call.uuid != null);

    for (final call in calls) {
      await endCall(call.uuid!);
    }
  }

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    if (CurrentPlatform.isIos) {
      return await StreamTokenProvider.getVoIPToken();
    } else if (CurrentPlatform.isAndroid) {
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
    _subscriptions.cancelAll();
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
    supportsHolding: false,
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
