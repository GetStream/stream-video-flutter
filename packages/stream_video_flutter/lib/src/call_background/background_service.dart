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

class StreamBackgroundService {
  factory StreamBackgroundService() {
    return _instance;
  }

  StreamBackgroundService._();

  static final StreamBackgroundService _instance = StreamBackgroundService._();

  static StreamSubscription<Call?>? _activeCalSubscription;

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

    _activeCalSubscription?.cancel();
    _activeCalSubscription = streamVideo.listenActiveCall((call) async {
      await _instance.onActiveCall(
        call: call,
        optionsBuilder: callNotificationOptionsBuilder,
        onNotificationClick: onNotificationClick,
        onButtonClick: onButtonClick,
        onUiLayerDestroyed: onPlatformUiLayerDestroyed,
      );
    });
  }

  final _logger = taggedLogger(tag: _tag);

  StreamSubscription<CallState>? _subscription;
  NotificationOptionsBuilder? _screenShareNotificationOptionsBuilder;

  Future<void> startScreenSharingNotificationService(Call call) async {
    await StreamVideoFlutterBackground.startService(
      NotificationPayload(
        callCid: call.callCid.value,
        options: (_screenShareNotificationOptionsBuilder ??
                _screenShareDefaultOptions)
            .call(call),
      ),
      ServiceType.screenSharing,
    );
  }

  Future<void> stopScreenSharingNotificationService() async {
    await StreamVideoFlutterBackground.stopService(
      ServiceType.screenSharing,
    );
  }

  Future<void> onActiveCall({
    Call? call,
    NotificationOptionsBuilder optionsBuilder = _callDefaultOptions,
    OnNotificationClick? onNotificationClick,
    OnButtonClick? onButtonClick,
    OnUiLayerDestroyed? onUiLayerDestroyed,
  }) async {
    try {
      _logger.d(() => '[onActiveCall] activeCall: $call');
      if (call != null) {
        await _onConnected(
          call: call,
          optionsBuilder: optionsBuilder,
          onNotificationClick: onNotificationClick,
          onButtonClick: onButtonClick,
          onUiLayerDestroyed: onUiLayerDestroyed,
        );
      } else {
        await _onDisconnected();
      }
    } catch (e, stk) {
      _logger.e(() => '[onActiveCall] failed: $e, stk: $stk');
    }
  }

  Future<void> _onConnected({
    required Call call,
    required NotificationOptionsBuilder optionsBuilder,
    OnNotificationClick? onNotificationClick,
    OnButtonClick? onButtonClick,
    OnUiLayerDestroyed? onUiLayerDestroyed,
  }) async {
    try {
      if (!await Permission.microphone.isGranted) {
        _logger.d(
          () =>
              '[onConnected] cannot start the service, microphone permission is not granted',
        );
        return;
      }

      final result = await StreamVideoFlutterBackground.startService(
        NotificationPayload(
          callCid: call.callCid.value,
          options: optionsBuilder.call(call),
        ),
        ServiceType.call,
      );

      _logger.d(() => '[onConnected] call service start result: $result');
      if (result) {
        StreamVideoFlutterBackground.setOnNotificationContentClick(
          _buildOnContentClick(call, onNotificationClick),
        );
        StreamVideoFlutterBackground.setOnNotificationButtonClick(
          _buildOnButtonClick(call, onButtonClick),
        );
        StreamVideoFlutterBackground.setOnPlatformUiLayerDestroyed(
          _buildOnUiLayerDestroyed(call, onUiLayerDestroyed),
        );
        _subscription = _listenState(call, optionsBuilder);
      }
    } catch (e, stk) {
      _logger.e(() => '[onConnected] service start failed: $e, stk: $stk');
    }
  }

  Future<void> _onDisconnected() async {
    try {
      StreamVideoFlutterBackground.setOnNotificationContentClick(null);
      StreamVideoFlutterBackground.setOnNotificationButtonClick(null);
      StreamVideoFlutterBackground.setOnPlatformUiLayerDestroyed(null);
      await _subscription?.cancel();

      final callResult =
          await StreamVideoFlutterBackground.stopService(ServiceType.call);

      final sharingResult = await StreamVideoFlutterBackground.stopService(
        ServiceType.screenSharing,
      );
      _logger.d(
        () =>
            '[onDisconnected] call service stop result: $callResult, screen sharing service stop result: $sharingResult',
      );
    } catch (e, stk) {
      _logger
          .e(() => '[onDisconnected] call service stop failed: $e, stk: $stk');
    }
  }

  OnNotificationButtonClick _buildOnButtonClick(
    Call call,
    OnButtonClick? onButtonClick,
  ) {
    return (btn, callCid, serviceType) async {
      _logger.d(
        () =>
            '[onButtonClick] btn: $btn, callCid: $callCid, serviceType: $serviceType',
      );
      final expected = call.callCid.value;
      if (call.callCid.value != callCid) {
        _logger.w(() => '[onButtonClick] rejected (expectedCid: $expected)');
        return;
      }
      if (btn == _btnCancel) {
        if (onButtonClick != null) {
          await onButtonClick.call(call, ButtonType.cancel, serviceType);
        } else {
          if (serviceType == ServiceType.call) {
            await call.reject(reason: CallRejectReason.cancel());
          } else if (serviceType == ServiceType.screenSharing) {
            await StreamVideoFlutterBackground.stopService(
              ServiceType.screenSharing,
            );
            await call.setScreenShareEnabled(enabled: false);
          }
        }
      }
    };
  }

  OnNotificationContentClick _buildOnContentClick(
    Call call,
    OnNotificationClick? onNotificationClick,
  ) {
    return (callCid) async {
      _logger.d(() => '[onContentClick] callCid: $callCid');
      final expected = call.callCid.value;
      if (expected != callCid) {
        _logger.w(() => '[onContentClick] rejected (expectedCid: $expected)');
        return;
      }
      await onNotificationClick?.call(call);
    };
  }

  OnPlatformUiLayerDestroyed _buildOnUiLayerDestroyed(
    Call call,
    OnUiLayerDestroyed? onUiLayerDestroyed,
  ) {
    return (callCid) async {
      _logger.d(() => '[onUiLayerDestroyed] callCid: $callCid');
      final expected = call.callCid.value;
      if (expected != callCid) {
        _logger
            .w(() => '[onUiLayerDestroyed] rejected (expectedCid: $expected)');
        return;
      }
      await onUiLayerDestroyed?.call(call);
    };
  }

  StreamSubscription<CallState> _listenState(
    Call call,
    NotificationOptionsBuilder optionsBuilder,
  ) {
    return call.state.listen((value) async {
      _logger.v(() => '[listenState] call service update, state: $value');

      if (value.status is CallStatusDisconnected) {
        return;
      }

      try {
        final result = await StreamVideoFlutterBackground.updateService(
          NotificationPayload(
            callCid: call.callCid.value,
            options: optionsBuilder.call(call),
          ),
          ServiceType.call,
        );
        _logger.v(() => '[listenState] call service update result: $result');
      } catch (e, stk) {
        _logger.e(() => '[listenState] call service update failed: $e; $stk');
      }
    });
  }
}

NotificationOptions _callDefaultOptions(Call call) {
  final users = call.state.valueOrNull?.callParticipants
          .map((it) => it.userId)
          .join(', ') ??
      '';
  return NotificationOptions(
    content: NotificationContent(
      title: 'Call in progress',
      text: '${call.callCid.id}: $users',
    ),
  );
}

NotificationOptions _screenShareDefaultOptions(Call call) {
  return const NotificationOptions(
    content: NotificationContent(
      title: 'You are screen sharing',
    ),
  );
}
