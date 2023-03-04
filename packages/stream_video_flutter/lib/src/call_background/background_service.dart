import 'dart:async';

import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter_background/model/notification_options.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background.dart';

const _tag = 'SV:Background';
const _btnCancel = 'cancel';

typedef ContentOptionsBuilder = ContentOptions Function(Call);

typedef OnCancelClick = Future<void> Function(Call);

class StreamBackgroundService {
  factory StreamBackgroundService() {
    return _instance;
  }
  StreamBackgroundService._();
  static final StreamBackgroundService _instance = StreamBackgroundService._();

  static void init({
    ContentOptionsBuilder optionsBuilder = _defaultOptions,
    OnCancelClick? onCancelClick,
  }) {
    Call.onActiveCall = (call) async {
      await _instance.onActiveCall(
        call: call,
        optionsBuilder: optionsBuilder,
        onCancelClick: onCancelClick,
      );
    };
  }

  final _logger = taggedLogger(tag: _tag);
  StreamSubscription<CallState>? _subscription;

  Future<void> onActiveCall({
    Call? call,
    ContentOptionsBuilder optionsBuilder = _defaultOptions,
    OnCancelClick? onCancelClick,
  }) async {
    try {
      _logger.d(() => '[onActiveCall] activeCall: $call');
      if (call != null) {
        await _onConnected(call, optionsBuilder, onCancelClick);
      } else {
        await _onDisconnected();
      }
    } catch (e, stk) {
      _logger.e(() => '[onActiveCall] failed: $e, stk: $stk');
    }
  }

  Future<void> _onConnected(
    Call call,
    ContentOptionsBuilder optionsBuilder,
    OnCancelClick? onCancelClick,
  ) async {
    try {
      final result = await StreamVideoFlutterBackground.startService(
        NotificationOptions(
          callCid: call.callCid.value,
          content: optionsBuilder.call(call),
        ),
      );
      _logger.d(() => '[onConnected] service start result: $result');
      if (result) {
        StreamVideoFlutterBackground.setOnButtonClick(
          _buildOnButtonClick(call, onCancelClick),
        );
        _subscription = _listenState(call, optionsBuilder);
      }
    } catch (e, stk) {
      _logger.e(() => '[onConnected] service start failed: $e, stk: $stk');
    }
  }

  Future<void> _onDisconnected() async {
    try {
      StreamVideoFlutterBackground.setOnButtonClick(null);
      await _subscription?.cancel();
      final result = await StreamVideoFlutterBackground.stopService();
      _logger.d(() => '[onDisconnected] service stop result: $result');
    } catch (e, stk) {
      _logger.e(() => '[onDisconnected] service stop failed: $e, stk: $stk');
    }
  }

  OnNotificationButtonClick _buildOnButtonClick(
    Call call,
    OnCancelClick? onCancelClick,
  ) {
    return (btn, callCid) async {
      _logger.d(() => '[onButtonClick] btn: $btn, callCid: $callCid');
      if (call.callCid.value != callCid) {
        return;
      }
      if (btn == _btnCancel) {
        if (onCancelClick != null) {
          await onCancelClick.call(call);
        } else {
          await call.apply(const CancelCall());
        }
      }
    };
  }

  StreamSubscription<CallState> _listenState(
    Call call,
    ContentOptionsBuilder optionsBuilder,
  ) {
    return call.state.listen((value) async {
      try {
        final result = await StreamVideoFlutterBackground.updateService(
          NotificationOptions(
            callCid: call.callCid.value,
            content: optionsBuilder.call(call),
          ),
        );
        _logger.v(() => '[listenState] service update result: $result');
      } catch (e, stk) {
        _logger.e(() => '[listenState] service update failed: $e; $stk');
      }
    });
  }
}

ContentOptions _defaultOptions(Call call) {
  final users = call.state.valueOrNull?.callParticipants
          .map((it) => it.userId)
          .join(', ') ??
      '';
  return ContentOptions(
    text: '${call.callCid.id}: $users',
  );
}
