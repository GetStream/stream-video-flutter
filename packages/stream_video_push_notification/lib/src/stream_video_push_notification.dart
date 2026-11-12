// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import '../stream_video_push_notification.dart';
import '../stream_video_push_notification_platform_interface.dart';
import 'manager/push_device_registrar.dart';
import 'manager/push_token_source.dart';
import 'manager/ringing_event_broadcaster.dart';

const _idRinging = 2;
const _idCallEnded = 3;
const _idCallAccepted = 4;
const _idCallRejected = 6;
const _idCallParticipantCount = 7;
const _idActiveCall = 8;

/// Decides what [StreamVideoPushNotificationManager.endCallByCid] has to end for [cid].
///
/// Pulled out of the method so the choice can be tested. The live path cannot be exercised in a
/// unit test: `activeCalls` short-circuits to an empty list off-device, which always lands on
/// `endAll`.
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

  // Calls the platform still has but that can no longer be identified.
  //
  // iOS reports a call the system knows about with nothing but its uuid once the in-process object
  // describing it is gone — a CallKit call outliving the process that created it, after the app was
  // killed, ran out of memory or was hot restarted. No cid can ever match those, so they used to
  // fall through both branches untouched and the CallKit screen stayed up for the rest of the app's
  // life. Nothing else can address them either, so this is the only chance to clear them.
  final unidentified = activeCalls
      .where((call) => call.callCid == null && call.uuid != null)
      .toList();

  // Anything still identifiable that belongs to another cid is deliberately left alone.
  return (endAll: false, calls: [...matching, ...unidentified]);
}

/// Decides whether a `call.accepted` event for the current user describes an acceptance that
/// happened on this device.
@visibleForTesting
bool isAcceptedOnThisDevice({
  required bool acceptedLocally,
  required Call? activeCall,
}) {
  if (acceptedLocally) return true;
  return activeCall?.state.value.status is CallStatusActive;
}

/// Implementation of [PushNotificationManager] for Stream Video.
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

    if (!CurrentPlatform.isMobile) return;

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
        client.events.on<StreamCallEndedEvent>((event) {
          _logger.d(
            () => '[subscribeToEvents] Call ended event: ${event.callCid}',
          );
          _broadcaster.suppressEvent();
          endCallByCid(event.callCid.toString());
        }),
      );

      _subscriptions.add(
        _idCallParticipantCount,
        client.events.on<StreamCallSessionParticipantCountUpdatedEvent>((
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

            _broadcaster.suppressEvent();
            await endCallByCid(event.callCid.toString());
          }
        }),
      );

      _subscriptions.add(
        _idCallRejected,
        client.events.on<StreamCallRejectedEvent>((event) async {
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

            _broadcaster.suppressEvent();
            await endCallByCid(event.callCid.toString());
          }
        }),
      );

      _subscriptions.add(
        _idCallAccepted,
        client.events.on<StreamCallAcceptedEvent>((event) async {
          _logger.d(
            () =>
                '[subscribeToEvents] Call accepted event: ${event.callCid}, accepted by: ${event.acceptedByUserId}',
          );
          if (event.acceptedByUserId != streamVideo.currentUser.id) return;

          final activeCall = streamVideo.activeCalls.firstWhereOrNull(
            (call) => call.callCid == event.callCid,
          );

          final acceptedOnThisDevice = isAcceptedOnThisDevice(
            acceptedLocally: streamVideo.ringing.isCallAcceptedOnThisDevice(
              event.callCid.toString(),
            ),
            activeCall: activeCall,
          );

          // End the CallKit call on this device if the call was accepted on another device
          if (!acceptedOnThisDevice) {
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

            // The call is live on this device from here on, so only the ringing UI goes away.
            _broadcaster.suppressEvent();
            await dismissRingingCallByCid(event.callCid.toString());
          }
        }),
      );
    }

    //if there are active calls (for iOS) when connecting, subscribe to events as if the call was incoming
    StreamVideoPushNotificationPlatform.instance.activeCalls().then((calls) {
      if (calls.isNotEmpty) {
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

  /// The one broadcaster of this process's ringing events; see
  /// [RingingEventBroadcaster.shared].
  final _broadcaster = RingingEventBroadcaster.shared;

  final _logger = taggedLogger(tag: 'SV:PNManager');

  final Subscriptions _subscriptions = Subscriptions();

  List<Call> currentActiveCalls = [];

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
    final params = StreamVideoPushParams.forCall(
      pushConfiguration,
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
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
    final params = StreamVideoPushParams.forCall(
      pushConfiguration,
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
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
    final params = StreamVideoPushParams.forCall(
      pushConfiguration,
      uuid: uuid,
      callCid: callCid,
      avatar: avatar,
      handle: handle,
      callerName: callerName,
      hasVideo: hasVideo,
    );

    return StreamVideoPushNotificationPlatform.instance.startCall(params);
  }

  @override
  Future<List<CallData>> activeCalls() async {
    if (!CurrentPlatform.isMobile) return [];

    return StreamVideoPushNotificationPlatform.instance.activeCalls();
  }

  @override
  Future<void> endAllCalls() =>
      StreamVideoPushNotificationPlatform.instance.endAllCalls();

  @override
  Future<void> endCall(String uuid) =>
      StreamVideoPushNotificationPlatform.instance.endCall(uuid);

  /// Dismisses the ringing UI of a call that the user accepted and is now in.
  ///
  /// This is deliberately not [endCallByCid]. On Android the two differ: ending disconnects the
  /// call from the Telecom stack, while dismissing leaves it registered so in-call controls on a
  /// watch, headset or car head unit keep working. Only the caller knows which one it means —
  /// natively an accept and an accept that failed to join look identical.
  ///
  /// On iOS there is nothing to keep: CallKit *is* the ring, and ending it is what dismissing it
  /// means, so this behaves exactly as it always has.
  Future<void> dismissRingingCallByCid(String cid) {
    if (CurrentPlatform.isIos) return endCallByCid(cid);
    return StreamVideoPushNotificationPlatform.instance.dismissRingingCall(cid);
  }

  @override
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
      // Suppress CallKit event to avoid loop
      _broadcaster.suppressEvent(
        eventType: ActionCallToggleMute,
        valueKey: isMuted.toString(),
      );

      await StreamVideoPushNotificationPlatform.instance.muteCall(
        call.uuid!,
        isMuted: isMuted,
      );
    }
  }

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

  /// Reports how a call ended so it shows up correctly in the system call history.
  ///
  /// iOS only. CallKit lists every call it displayed in Recents, and the reason decides how: a
  /// call reported as [CallEndedReason.unanswered] appears as a missed call, while the default
  /// hang-up path lists it as a regular one. Has no effect on Android.
  Future<void> reportCallEnded(
    String uuid, {
    CallEndedReason reason = CallEndedReason.remoteEnded,
  }) {
    return StreamVideoPushNotificationPlatform.instance.reportCallEnded(
      uuid,
      reason,
    );
  }

  @override
  Future<void> dispose() async {
    _subscriptions.cancelAll();
    await _registrar.dispose();
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
