import 'dart:async';

import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter_background/model/notification_options.dart';
import 'package:stream_video_flutter_background/model/notification_payload.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background.dart';

const _tag = 'SV:Background';
const _btnCancel = 'cancel';

enum ButtonType {
  cancel;
}

typedef NotificationOptionsBuilder = NotificationOptions Function(Call);

typedef OnButtonClick = Future<void> Function(Call, ButtonType);
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
    NotificationOptionsBuilder optionsBuilder = _defaultOptions,
    OnNotificationClick? onNotificationClick,
    OnButtonClick? onButtonClick,
    OnUiLayerDestroyed? onPlatformUiLayerDestroyed,
  }) {
    _activeCalSubscription?.cancel();
    _activeCalSubscription = streamVideo.listenActiveCall((call) async {
      await _instance.onActiveCall(
        call: call,
        optionsBuilder: optionsBuilder,
        onNotificationClick: onNotificationClick,
        onButtonClick: onButtonClick,
        onUiLayerDestroyed: onPlatformUiLayerDestroyed,
      );
    });
  }

  final _logger = taggedLogger(tag: _tag);
  StreamSubscription<CallState>? _subscription;

  Future<void> onActiveCall({
    Call? call,
    NotificationOptionsBuilder optionsBuilder = _defaultOptions,
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
      final result = await StreamVideoFlutterBackground.startService(
        NotificationPayload(
          callCid: call.callCid.value,
          options: optionsBuilder.call(call),
        ),
      );
      _logger.d(() => '[onConnected] service start result: $result');
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
      final result = await StreamVideoFlutterBackground.stopService();
      _logger.d(() => '[onDisconnected] service stop result: $result');
    } catch (e, stk) {
      _logger.e(() => '[onDisconnected] service stop failed: $e, stk: $stk');
    }
  }

  OnNotificationButtonClick _buildOnButtonClick(
    Call call,
    OnButtonClick? onButtonClick,
  ) {
    return (btn, callCid) async {
      _logger.d(() => '[onButtonClick] btn: $btn, callCid: $callCid');
      final expected = call.callCid.value;
      if (call.callCid.value != callCid) {
        _logger.w(() => '[onButtonClick] rejected (expectedCid: $expected)');
        return;
      }
      if (btn == _btnCancel) {
        if (onButtonClick != null) {
          await onButtonClick.call(call, ButtonType.cancel);
        } else {
          await call.leave();
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
      try {
        final result = await StreamVideoFlutterBackground.updateService(
          NotificationPayload(
            callCid: call.callCid.value,
            options: optionsBuilder.call(call),
          ),
        );
        _logger.v(() => '[listenState] service update result: $result');
      } catch (e, stk) {
        _logger.e(() => '[listenState] service update failed: $e; $stk');
      }
    });
  }
}

NotificationOptions _defaultOptions(Call call) {
  final users = call.state.valueOrNull?.callParticipants
          .map((it) => it.userId)
          .join(', ') ??
      '';
  return NotificationOptions(
    content: NotificationContent(
      text: '${call.callCid.id}: $users',
    ),
  );
}
