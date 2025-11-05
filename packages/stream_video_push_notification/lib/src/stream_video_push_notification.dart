// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';
import '../stream_video_push_notification.dart';
import '../stream_video_push_notification_platform_interface.dart';

part 'stream_video_push_provider.dart';

const _idToken = 1;
const _idRinging = 2;
const _idCallEnded = 3;
const _idCallAccepted = 4;
const _idCallRejected = 6;
const _idCallParticipantCount = 7;
const _idActiveCall = 8;

/// Implementation of [PushNotificationManager] for Stream Video.
class StreamVideoPushNotificationManager implements PushNotificationManager {
  StreamVideoPushNotificationManager._({
    required CoordinatorClient client,
    required StreamVideo streamVideo,
    required this.iosPushProvider,
    required this.androidPushProvider,
    required this.pushConfiguration,
    this.registerApnDeviceToken = false,
  }) : _client = client {
    if (!CurrentPlatform.isMobile) return;

    SharedPreferences.getInstance().then((prefs) => _sharedPreferences = prefs);

    _subscriptions.add(
      _idActiveCall,
      streamVideo.state.activeCalls.listen((calls) async {
        _logger.d(
          () =>
              '[activeCall] Active calls changed to [${calls.map((c) => c.callCid).join(', ')}]',
        );

        for (final previousCall in currentActiveCalls) {
          if (!calls.any((c) => c.callCid == previousCall.callCid)) {
            _logger.d(
              () =>
                  '[activeCall] Stopping previous call: ${previousCall.callCid}',
            );
            await endCallByCid(previousCall.callCid.value);
          }
        }

        currentActiveCalls = calls;
      }),
    );

    void subscribeToEvents() {
      _subscriptions.add(
        _idCallEnded,
        client.events.on<CoordinatorCallEndedEvent>((event) {
          _logger.d(
            () => '[subscribeToEvents] Call ended event: ${event.callCid}',
          );
          endCallByCid(event.callCid.toString());
        }),
      );

      _subscriptions.add(
        _idCallParticipantCount,
        client.events.on<CoordinatorCallSessionParticipantCountUpdatedEvent>((
          event,
        ) async {
          final roleCounts = event.participantsCountByRole.values.map((v) => v);

          final totalCount = roleCounts.isEmpty
              ? 0
              : roleCounts.reduce((a, b) => a + b);

          _logger.d(
            () =>
                '[subscribeToEvents] Participant count updated event: ${event.callCid}, count: $totalCount',
          );
          if (totalCount == 0) {
            _logger.v(
              () =>
                  '[subscribeToEvents] No participants left, ending call: ${event.callCid}',
            );

            await endCallByCid(event.callCid.toString());
          }
        }),
      );

      _subscriptions.add(
        _idCallRejected,
        client.events.on<CoordinatorCallRejectedEvent>((event) async {
          _logger.d(
            () =>
                '[subscribeToEvents] Call rejected event: ${event.callCid}, rejected by: ${event.rejectedByUserId}',
          );
          if (event.rejectedByUserId == event.metadata.details.createdBy.id ||
              event.rejectedByUserId == streamVideo.currentUser.id) {
            _logger.v(
              () =>
                  '[subscribeToEvents] Call rejected by the current user or call owner, ending call: ${event.callCid}',
            );

            await endCallByCid(event.callCid.toString());
          }
        }),
      );

      _subscriptions.add(
        _idCallAccepted,
        client.events.on<CoordinatorCallAcceptedEvent>((event) async {
          _logger.d(
            () =>
                '[subscribeToEvents] Call accepted event: ${event.callCid}, accepted by: ${event.acceptedByUserId}',
          );
          if (event.acceptedByUserId != streamVideo.currentUser.id) return;

          final activeCall = streamVideo.activeCalls.firstWhereOrNull(
            (call) => call.callCid == event.callCid,
          );

          // End the CallKit call on this device if the call was accepted on another device
          if (activeCall?.state.value.status is! CallStatusActive) {
            _logger.v(
              () =>
                  '[subscribeToEvents] Call accepted on other device, ending call: ${event.callCid}',
            );
            await endCallByCid(event.callCid.toString());
          }
          // If the call was accepted on this device, end the Ringing call silently
          // (useful if the call was accepted via the app instead of the CallKit UI)
          else {
            _logger.v(
              () =>
                  '[subscribeToEvents] Call accepted on the same device, ending CallKit silently: ${event.callCid}',
            );
            await StreamVideoPushNotificationPlatform.instance.silenceEvents();
            await endCallByCid(event.callCid.toString());
            await Future<void>.delayed(const Duration(milliseconds: 300));
            await StreamVideoPushNotificationPlatform.instance
                .unsilenceEvents();
          }
        }),
      );
    }

    //if there are active calls (for iOS) when connecting, subscribe to events as if the call was incoming
    StreamVideoPushNotificationPlatform.instance.activeCalls().then((value) {
      if (value is List && value.isNotEmpty) {
        subscribeToEvents();
      }
    });

    _subscriptions.add(
      _idRinging,
      onCallEvent.listen((event) {
        if (event is ActionCallToggleMute) {
          {
            _logger.d(
              () =>
                  '[onCallEvent] ActionCallToggleMute received: uuid=${event.uuid}, isMuted=${event.isMuted}',
            );
            final call = currentActiveCalls.firstWhereOrNull(
              (c) => c.state.value.isRingingFlow,
            );
            if (call != null) {
              call.setMicrophoneEnabled(enabled: !event.isMuted);
            } else {
              _logger.w(
                () => '[onCallEvent] Cannot toggle mute: no active call',
              );
            }
          }
        } else if (event is ActionCallIncoming) {
          if (!client.isConnected) {
            client.openConnection();
          }

          subscribeToEvents();
        } else if (event is ActionCallAccept ||
            event is ActionCallDecline ||
            event is ActionCallTimeout ||
            event is ActionCallEnded) {
          _subscriptions.cancel(_idCallAccepted);
          _subscriptions.cancel(_idCallEnded);
          _subscriptions.cancel(_idCallRejected);
          _subscriptions.cancel(_idCallParticipantCount);
        }
      }),
    );
  }
  static const userDeviceTokenKey = 'io.getstream.userDeviceToken';
  static const userDeviceTokenVoIPKey = 'io.getstream.userDeviceTokenVoIP';

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

  final CoordinatorClient _client;
  final StreamVideoPushProvider iosPushProvider;
  final StreamVideoPushProvider androidPushProvider;
  final StreamVideoPushConfiguration pushConfiguration;
  final bool registerApnDeviceToken;
  late SharedPreferences _sharedPreferences;

  final _logger = taggedLogger(tag: 'SV:PNManager');

  final Subscriptions _subscriptions = Subscriptions();

  List<Call> currentActiveCalls = [];

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

    Future<void> registerDevice(String token, bool isVoIP) async {
      final tokenKey = isVoIP ? userDeviceTokenVoIPKey : userDeviceTokenKey;

      final storedToken = _sharedPreferences.getString(tokenKey);
      if (storedToken == token) return;

      await _client
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
      () => pushProvider.onTokenRefresh.listen(
        (token) => registerDevice(token, true),
      ),
    );
  }

  Future<void> removedStoredTokens() async {
    await _sharedPreferences.remove(userDeviceTokenKey);
    await _sharedPreferences.remove(userDeviceTokenVoIPKey);
  }

  @override
  Future<void> unregisterDevice() async {
    final token = await getDevicePushTokenVoIP();
    if (token != null) {
      await _client.deleteDevice(id: token);
      _subscriptions.cancel(_idToken);
    }

    final apnToken = await StreamTokenProvider.getAPNToken();
    if (apnToken != null) {
      await _client.deleteDevice(id: apnToken);
    }

    await removedStoredTokens();
  }

  @override
  Stream<RingingEvent> get onCallEvent {
    return RingingEventBroadcaster().onEvent
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
    final paramsFromConfig = StreamVideoPushParams.fromPushConfiguration(
      pushConfiguration,
    );

    final params = paramsFromConfig.copyWith(
      id: uuid,
      handle: handle,
      callerName: callerName,
      type: hasVideo ? 1 : 0,
      extra: {'callCid': callCid},
      android: paramsFromConfig.android?.copyWith(avatar: avatar),
    );

    return StreamVideoPushNotificationPlatform.instance.showIncomingCall(
      params,
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
    final paramsFromConfig = StreamVideoPushParams.fromPushConfiguration(
      pushConfiguration,
    );

    final params = paramsFromConfig.copyWith(
      id: uuid,
      handle: handle,
      callerName: callerName,
      type: hasVideo ? 1 : 0,
      extra: {'callCid': callCid},
      android: paramsFromConfig.android?.copyWith(avatar: avatar),
    );

    return StreamVideoPushNotificationPlatform.instance
        .showMissCallNotification(params);
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
    final paramsFromConfig = StreamVideoPushParams.fromPushConfiguration(
      pushConfiguration,
    );

    final params = paramsFromConfig.copyWith(
      id: uuid,
      handle: handle,
      callerName: callerName,
      type: hasVideo ? 1 : 0,
      extra: {'callCid': callCid},
      android: paramsFromConfig.android?.copyWith(avatar: avatar),
    );

    return StreamVideoPushNotificationPlatform.instance.startCall(params);
  }

  @override
  Future<List<CallData>> activeCalls() async {
    if (!CurrentPlatform.isMobile) return [];

    final activeCalls = await StreamVideoPushNotificationPlatform.instance
        .activeCalls();
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
  Future<void> endAllCalls() =>
      StreamVideoPushNotificationPlatform.instance.endAllCalls();

  @override
  Future<void> endCall(String uuid) =>
      StreamVideoPushNotificationPlatform.instance.endCall(uuid);

  @override
  Future<void> endCallByCid(String cid) async {
    final activeCalls = await this.activeCalls();
    final calls = activeCalls
        .where((call) => call.callCid == cid && call.uuid != null)
        .toList();

    // If multiple native ringing calls are stacked with identical metadata,
    // ending by callCid may not be sufficient; fall back to endAllCalls.
    if (activeCalls.length == calls.length) {
      await endAllCalls();
    } else {
      for (final call in calls) {
        await endCall(call.uuid!);
      }
    }
  }

  @override
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
      // Silence events to avoid infinite loop
      await StreamVideoPushNotificationPlatform.instance.silenceEvents();
      await StreamVideoPushNotificationPlatform.instance.muteCall(
        call.uuid!,
        isMuted: isMuted,
      );
      await StreamVideoPushNotificationPlatform.instance.unsilenceEvents();
    }
  }

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    if (CurrentPlatform.isIos) {
      return StreamTokenProvider.getVoIPToken();
    } else if (CurrentPlatform.isAndroid) {
      return StreamTokenProvider.getFirebaseToken();
    }

    return null;
  }

  @override
  Future<void> holdCall(String uuid, {bool isOnHold = true}) {
    return StreamVideoPushNotificationPlatform.instance.holdCall(
      uuid,
      isOnHold: isOnHold,
    );
  }

  @override
  Future<void> muteCall(String uuid, {bool isMuted = true}) {
    return StreamVideoPushNotificationPlatform.instance.muteCall(
      uuid,
      isMuted: isMuted,
    );
  }

  @override
  Future<void> setCallConnected(String uuid) {
    return StreamVideoPushNotificationPlatform.instance.setCallConnected(uuid);
  }

  @override
  Future<void> dispose() async {
    _subscriptions.cancelAll();
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
    incomingCallNotification: IncomingCallNotificationParams(
      fullScreenShowLogo: false,
      fullScreenBackgroundColor: '#0955fa',
    ),
  ),
  ios: IOSPushConfiguration(
    handleType: 'generic',
    supportsVideo: true,
    maximumCallGroups: 1,
    audioSessionMode: 'default',
    audioSessionActive: true,
    audioSessionPreferredSampleRate: 44100,
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
    handle: json['handle'] as String?,
    callerName: json['callerName'] as String?,
    hasVideo: json['type'] == 1,
    extraData: extraData,
  );
}

/// Wrapper class to support multiple subscriptions to the
/// [StreamVideoPushNotificationPlatform.onEvent] stream.
final class RingingEventBroadcaster {
  factory RingingEventBroadcaster() =>
      _singleton ??= RingingEventBroadcaster._();

  RingingEventBroadcaster._();

  static RingingEventBroadcaster? _singleton;

  StreamController<RingingEvent>? _controller;

  /// Returns a Stream of [RingingEvent].
  Stream<RingingEvent> get onEvent {
    _controller ??= StreamController<RingingEvent>.broadcast(
      onListen: _startListenEvent,
      onCancel: _stopListenEvent,
    );
    return _controller!.stream;
  }

  StreamSubscription<RingingEvent?>? _eventSubscription;

  Future<void> _startListenEvent() async {
    _eventSubscription ??= StreamVideoPushNotificationPlatform.instance.onEvent
        .distinct()
        .listen((event) {
          if (event != null) _controller?.add(event);
        });
  }

  Future<void> _stopListenEvent() async {
    await _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}
