import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video/stream_video.dart';

import '../../stream_video_flutter_background.dart';
import 'model/notification_options.dart';
import 'model/notification_payload.dart';
import 'model/service_type.dart';

const _tag = 'SV:Background';
const _btnCancel = 'cancel';

enum ButtonType {
  cancel;
}

typedef NotificationOptionsBuilder = NotificationOptions Function(Call);

typedef OnButtonClick = Future<void> Function(Call, ButtonType, ServiceType);
typedef OnNotificationClick = Future<void> Function(Call);
typedef OnUiLayerDestroyed = Future<void> Function(Call);

// Context to hold data for each managed call service
class _CallServiceContext {
  _CallServiceContext({required this.call, this.stateSubscription});

  final Call call;
  StreamSubscription<CallState>? stateSubscription;
}

class StreamBackgroundService {
  factory StreamBackgroundService() {
    return _instance;
  }

  StreamBackgroundService._();

  static final StreamBackgroundService _instance = StreamBackgroundService._();

  static StreamSubscription<List<Call>>? _activeCalSubscription;

  // Map to store context for each managed call
  final Map<String, _CallServiceContext> _managedCalls = {};
  final _logger = taggedLogger(tag: _tag);
  NotificationOptionsBuilder? _screenShareNotificationOptionsBuilder;

  static void init(
    StreamVideo streamVideo, {
    NotificationOptionsBuilder callNotificationOptionsBuilder =
        _callDefaultOptions,
    NotificationOptionsBuilder screenShareNotificationOptionsBuilder =
        _screenShareDefaultOptions,
    OnNotificationClick? onNotificationClick,
    OnButtonClick? onButtonClick,
    OnUiLayerDestroyed? onPlatformUiLayerDestroyed,
  }) {
    _instance._screenShareNotificationOptionsBuilder =
        screenShareNotificationOptionsBuilder;

    // Global event handlers that will use the incoming callCid to find the correct Call object
    StreamVideoFlutterBackground.setOnNotificationContentClick((
      String callCid,
    ) async {
      final callContext = _instance._managedCalls[callCid];
      if (callContext == null) {
        _instance._logger.w(
          () =>
              '<$callCid> [onNotificationContentClick] no managed call for callCid',
        );
        return;
      }

      _instance._logger
          .d(() => '<$callCid> [onNotificationContentClick] handling click');
      await onNotificationClick?.call(callContext.call);
    });

    StreamVideoFlutterBackground.setOnNotificationButtonClick((
      String btn,
      String callCid,
      ServiceType serviceType,
    ) async {
      final callContext = _instance._managedCalls[callCid];
      if (callContext == null) {
        _instance._logger.w(
          () =>
              '<$callCid> [onNotificationButtonClick] no managed call for callCid',
        );
        return;
      }

      _instance._logger.d(
        () =>
            '<$callCid> [onNotificationButtonClick] btn: $btn, serviceType: $serviceType',
      );

      if (btn == _btnCancel) {
        if (onButtonClick != null) {
          await onButtonClick.call(
            callContext.call,
            ButtonType.cancel,
            serviceType,
          );
        } else {
          // Default cancel behavior
          if (serviceType == ServiceType.call) {
            await callContext.call.reject(reason: CallRejectReason.cancel());
          } else if (serviceType == ServiceType.screenSharing) {
            await _instance.stopScreenSharingNotificationService(callCid);
            await callContext.call.setScreenShareEnabled(enabled: false);
          }
        }
      }
    });

    StreamVideoFlutterBackground.setOnPlatformUiLayerDestroyed(
        (String callCid) async {
      final context = _instance._managedCalls[callCid];
      if (context == null) {
        _instance._logger.w(
          () =>
              '<$callCid> [onPlatformUiLayerDestroyed] no managed call for callCid',
        );
        return;
      }

      _instance._logger.d(
        () =>
            '<$callCid> [onPlatformUiLayerDestroyed] handling UI layer destroyed',
      );
      await onPlatformUiLayerDestroyed?.call(context.call);
    });

    _activeCalSubscription?.cancel();
    _activeCalSubscription =
        streamVideo.listenActiveCalls((List<Call> currentCalls) async {
      final currentCallCids = currentCalls.map((c) => c.callCid.value).toSet();
      final managedCallCids = _instance._managedCalls.keys.toSet();

      // Stop services for calls that are no longer active
      final cidsToRemove = managedCallCids.difference(currentCallCids);
      for (final cidToRemove in cidsToRemove) {
        await _instance._stopManagingCall(cidToRemove);
      }

      // Start or update services for current calls
      for (final call in currentCalls) {
        final callCid = call.callCid.value;
        if (managedCallCids.contains(callCid)) {
          // Call is already managed. Updates are handled by its state listener.
        } else {
          // New call, start managing it
          await _instance._startManagingCall(
            call,
            callNotificationOptionsBuilder,
          );
        }
      }

      // If there are no current calls, but some are still managed (e.g. due to race condition or error)
      // This ensures cleanup if the currentCalls list becomes empty.
      if (currentCalls.isEmpty && _instance._managedCalls.isNotEmpty) {
        _instance._logger.i(
          () =>
              '[listenActiveCalls] All calls ended, ensuring all managed services are stopped.',
        );
        final cidsToStop = _instance._managedCalls.keys.toList();
        for (final cid in cidsToStop) {
          await _instance._stopManagingCall(cid);
        }
      }
    });
  }

  Future<void> _startManagingCall(
    Call call,
    NotificationOptionsBuilder optionsBuilder,
  ) async {
    final callCid = call.callCid.value;

    _logger.d(() => '<$callCid> [_startManagingCall] Starting management.');
    try {
      // TODO: Why do we need to check this?
      final micPermissionGranted = await Permission.microphone.isGranted;
      if (!micPermissionGranted) {
        _logger.d(
          () =>
              '<$callCid> [_startManagingCall] cannot start service, microphone permission not granted',
        );
        return;
      }

      final options = optionsBuilder.call(call);
      final payload = NotificationPayload(
        callCid: callCid,
        options: options,
      );

      final result = await StreamVideoFlutterBackground.startService(
        payload,
        ServiceType.call,
      );

      _logger.d(
        () =>
            '<$callCid> [_startManagingCall] call service start result: $result',
      );

      if (result) {
        // ignore: cancel_subscriptions
        final stateSubscription = call.state.listen((CallState value) async {
          _logger.v(
            () =>
                '<$callCid> [_startManagingCall] state update: ${value.status}',
          );

          if (value.status is CallStatusDisconnected) {
            return;
          }

          try {
            final updateOptions = optionsBuilder.call(call);

            // TODO: That is a lot of service updates. We should only update the service if the options have changed.
            final updateResult =
                await StreamVideoFlutterBackground.updateService(
              NotificationPayload(
                callCid: callCid,
                options: updateOptions,
              ),
              ServiceType.call,
            );
            _logger.v(
              () =>
                  '<$callCid> [_startManagingCall] call service update result: $updateResult',
            );
          } catch (e, stk) {
            _logger.e(
              () =>
                  '<$callCid> [_startManagingCall] call service update failed: $e; $stk',
            );
          }
        });

        _managedCalls[callCid] = _CallServiceContext(
          call: call,
          stateSubscription: stateSubscription,
        );
      }
    } catch (e, stk) {
      _logger.e(() => '<$callCid> [_startManagingCall] failed: $e, stk: $stk');
    }
  }

  Future<void> _stopManagingCall(String callCid) async {
    _logger.d(() => '<$callCid> [_stopManagingCall] Stopping management.');
    final context = _managedCalls.remove(callCid);
    if (context == null) {
      _logger.w(
        () =>
            '<$callCid> [_stopManagingCall] was not in managed calls map during stop.',
      );
      return;
    }

    try {
      await context.stateSubscription?.cancel();

      final callResult = await StreamVideoFlutterBackground.stopService(
        ServiceType.call,
        callCid: callCid,
      );

      _logger.d(
        () =>
            '<$callCid> [_stopManagingCall] call service stop result: $callResult',
      );

      // If a call ends, we might also want to stop its associated screen share service.
      final screenShareStopResult =
          await StreamVideoFlutterBackground.stopService(
        ServiceType.screenSharing,
        callCid: callCid,
      );

      _logger.d(
        () =>
            '<$callCid> [_stopManagingCall] screen sharing service stop attempt result: $screenShareStopResult (attempted as part of call cleanup)',
      );
    } catch (e, stk) {
      _logger.e(() => '<$callCid> [_stopManagingCall] failed: $e, stk: $stk');
    }
  }

  // Screen sharing methods
  Future<void> startScreenSharingNotificationService(Call call) async {
    final callCid = call.callCid.value;

    _logger.d(
      () =>
          '<$callCid> [startScreenSharingNotificationService] Starting screen sharing service.',
    );

    final options =
        (_screenShareNotificationOptionsBuilder ?? _screenShareDefaultOptions)
            .call(call);

    final payload = NotificationPayload(
      callCid: callCid,
      options: options,
    );

    await StreamVideoFlutterBackground.startService(
      payload,
      ServiceType.screenSharing,
    );
  }

  Future<void> stopScreenSharingNotificationService(String callCid) async {
    _logger.d(
      () =>
          '<$callCid> [stopScreenSharingNotificationService] Stopping screen sharing service.',
    );

    await StreamVideoFlutterBackground.stopService(
      ServiceType.screenSharing,
      callCid: callCid,
    );
  }
}

NotificationOptions _callDefaultOptions(Call call) {
  final participants = call.state.valueOrNull?.callParticipants ?? [];
  final participantUserIds = participants.map((p) => p.userId).join(', ');

  final notificationContent = NotificationContent(
    title: 'Call in progress (${call.callCid.id})',
    text: participantUserIds.isNotEmpty ? participantUserIds : 'Connecting...',
  );

  final options = NotificationOptions(
    content: notificationContent,
  );

  return options;
}

NotificationOptions _screenShareDefaultOptions(Call call) {
  return NotificationOptions(
    content: NotificationContent(
      title: 'You are screen sharing (${call.callCid.id})',
      text: 'Tap to return to the call.',
    ),
  );
}
