import 'dart:async';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:stream_video/stream_video.dart';

const _tag = 'SV:Foreground';
const _idCancelBtn = 'cancelButton';

void injectTaskHandler() {
  streamLog.v(_tag, () => '[injectTaskHandler] no args');
  print('[injectTaskHandler] no args at all');
  FlutterForegroundTask.setTaskHandler(ForegroundService());
}

class ForegroundService extends TaskHandler {
  ForegroundService() {
    streamLog.i(_tag, () => '<init> no args');
  }

  final _logger = taggedLogger(tag: _tag);

  static void init({
    AndroidNotificationOptions? androidNotificationOptions,
    IOSNotificationOptions? iosNotificationOptions,
    ForegroundTaskOptions? foregroundTaskOptions,
    Function? callback,
  }) {
    FlutterForegroundTask.init(
      androidNotificationOptions:
          androidNotificationOptions ?? _defaultAndroidNotificationOptions(),
      iosNotificationOptions:
          iosNotificationOptions ?? _defaultIosNotificationOptions(),
      foregroundTaskOptions:
          foregroundTaskOptions ?? _defaultForegroundTaskOptions(),
    );

    CallV2.onActiveCall = (call) {
      _onActiveCall(call, callback ?? injectTaskHandler);
    };
  }

  static Future<void> _onActiveCall(CallV2? call, [Function? callback]) async {
    StreamSubscription<dynamic>? receivePortSubscription;
    try {
      streamLog.d(_tag, () => '[onActiveCall] activeCall: $call');
      if (call != null) {
        if (!await FlutterForegroundTask.canDrawOverlays) {
          final isGranted =
              await FlutterForegroundTask.openSystemAlertWindowSettings();
          if (!isGranted) {
            streamLog.w(
              _tag,
              () => '[onActiveCall] "SYSTEM_ALERT_WINDOW"'
                  ' permission denied',
            );
          }
        }

        final result = await FlutterForegroundTask.startService(
          notificationTitle: 'Stream Sample App',
          notificationText: '${call.callCid}',
          callback: callback,
        );
        streamLog.v(_tag, () => '[onActiveCall] result: $result');
        if (result) {
          receivePortSubscription = await _listenReceivePort();
        }
      } else {
        await receivePortSubscription?.cancel();
        await FlutterForegroundTask.stopService();
      }
    } catch (e, stk) {
      streamLog.e(_tag, () => '[onActiveCall] failed: $e, stk: $stk');
    }
  }

  static Future<StreamSubscription<dynamic>?> _listenReceivePort() async {
    streamLog.d(_tag, () => '[listenReceivePort] no args');
    final receivePort = await FlutterForegroundTask.receivePort;
    streamLog.v(_tag, () => '[listenReceivePort] receivePort: $receivePort');
    if (receivePort == null) {
      return null;
    }
    return receivePort.listen((message) {
      print('[Foreground.listenReceivePort] message: $message');
      streamLog.d(_tag, () => '[listenReceivePort] message: $message');
    });
  }

  SendPort? _sendPort;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    //_logger.d(() => '[onStart] timestamp: $timestamp');

    print('[Foreground.onStart] ts: $timestamp');
    _sendPort = sendPort;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    //_logger.d(() => '[onDestroy] timestamp: $timestamp');
    print('[Foreground.onStart] ts: $timestamp');
    _sendPort = null;
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    _logger.d(() => '[onEvent] timestamp: $timestamp');
    print('[Foreground2.onEvent] ts: $timestamp');
  }

  @override
  Future<void> onButtonPressed(String id) async {
    //_logger.d(() => '[onEvent] id: $id');
    print('[Foreground.onButtonPressed] id: $id');
    _sendPort?.send(id);
  }

  @override
  void onNotificationPressed() {
    print('[Foreground.onNotificationPressed] no args');
    //_logger.d(() => '[onNotificationPressed] no args');
    FlutterForegroundTask.launchApp();
  }
}

AndroidNotificationOptions _defaultAndroidNotificationOptions() {
  return AndroidNotificationOptions(
    channelId: 'notification_channel_id',
    channelName: 'Foreground Notification',
    channelDescription:
        'This notification appears when the foreground service is running.',
    channelImportance: NotificationChannelImportance.MAX,
    priority: NotificationPriority.MAX,
    iconData: const NotificationIconData(
      resType: ResourceType.mipmap,
      resPrefix: ResourcePrefix.ic,
      name: 'launcher',
    ),
    buttons: [
      const NotificationButton(id: _idCancelBtn, text: 'Cancel'),
    ],
  );
}

IOSNotificationOptions _defaultIosNotificationOptions() {
  return const IOSNotificationOptions(
    showNotification: true,
    playSound: false,
  );
}

ForegroundTaskOptions _defaultForegroundTaskOptions() {
  return const ForegroundTaskOptions(
    interval: 5000,
    isOnceEvent: false,
    autoRunOnBoot: false,
    allowWakeLock: true,
    allowWifiLock: false,
  );
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    print('[Handler.onEvent] ts: $timestamp, _eventCount: $_eventCount');
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print('[Handler.onEvent] ts: $timestamp, _eventCount: $_eventCount');
    FlutterForegroundTask.updateService(
      notificationTitle: 'MyTaskHandler',
      notificationText: 'seconds: $_eventCount',
    );

    // Send data to the main isolate.
    sendPort?.send(_eventCount);

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    print('[Handler.onDestroy] ts: $timestamp, _eventCount: $_eventCount');
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
    _sendPort = null;
    _eventCount = 0;
  }

  @override
  void onButtonPressed(String id) {
    print('[Handler.onButtonPressed] id: $id');
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    print('[Handler.onNotificationPressed] no args');
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}
