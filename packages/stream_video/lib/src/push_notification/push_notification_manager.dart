import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/src/stream_video_event_channel.dart';
import 'package:stream_video/src/stream_video_method_channel.dart';

import '../call/call.dart';
import '../stream_video.dart';
import 'call_notification_wrapper.dart';

class PushNotificationManager {
  PushNotificationManager({
    required StreamVideo client,
    required SharedPreferences sharedPreferences,
    StreamVideoMethodChannel methodChannel = const StreamVideoMethodChannel(),
    StreamVideoEventChannel eventChannel = const StreamVideoEventChannel(),
    CallNotificationWrapper callNotification = const CallNotificationWrapper(),
  })  : _client = client,
        _callNotification = callNotification,
        _sharedPreferences = sharedPreferences,
        _methodChannel = methodChannel,
        _eventChannel = eventChannel {
    _eventChannel.onEvent.listen((event) {
      if (event.type == NativeEventType.ACTION_INCOMING_CALL) {
        _showCall(event.content['call_cid']);
      }
    });
  }

  final StreamVideo _client;
  final CallNotificationWrapper _callNotification;
  final SharedPreferences _sharedPreferences;
  final StreamVideoMethodChannel _methodChannel;
  final StreamVideoEventChannel _eventChannel;

  Future<void> onUserLoggedIn() async {
    print('JcLog: [onUserLoggedIn]');
    if (Platform.isAndroid) {
      _registerAndroidDevice();
    } else if (Platform.isIOS) {
      _registerIOSDevice();
    }
  }

  Future<void> _registerAndroidDevice() async {
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await _registerFirebaseToken(token);
      });
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _registerFirebaseToken(token);
      } else {
        print('JcLog: Firebase Token was null');
      }
    }
  }

  Future<void> _registerIOSDevice() async {
    final token = await _methodChannel.getDevicePushTokenVoIP();
    print('register device is called $token');
    if (token != null) {
      await _client.createDevice(token: token, pushProviderId: 'apn');
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    print('JcLog: New Firebase Token: $token');
    await _client.createDevice(token: token, pushProviderId: 'firebase');
  }

  Future<void> _showCall(String cid) async {
    final type = cid.substring(0, cid.indexOf(':'));
    final id = cid.substring(cid.indexOf(':') + 1);
    final call = await _client.getOrCreateCall(type: type, id: id);
    await _callNotification.showCallNotification(
      callId: cid,
      callers: call.users.values.map((e) => e.name).join(', '),
      isVideoCall: true,
      avatarUrl: call.users.values.firstOrNull?.imageUrl,
      onCallAccepted: _acceptCall,
      onCallRejected: _rejectCall,
    );
  }

  Future<bool> handlePushNotification(RemoteMessage remoteMessage) async {
    if (_isValid(remoteMessage)) {
      final cid = remoteMessage.data['call_cid'] as String;
      await _showCall(cid);
      return true;
    }
    return false;
  }

  Future<void> _acceptCall(String cid) async {
    print('JcLog: Storing incomingCallCid: $cid');
    await _sharedPreferences.setString('incomingCallCid', cid);
    await _client.acceptCall(
      type: cid.substring(0, cid.indexOf(':')),
      id: cid.substring(cid.indexOf(':') + 1),
    );
  }

  Future<void> _rejectCall(String cid) async {
    await _client.rejectCall(callCid: cid);
  }

  bool _isValid(RemoteMessage remoteMessage) {
    return _isFromStreamServer(remoteMessage) &&
        _isValidIncomingCall(remoteMessage);
  }

  bool _isFromStreamServer(RemoteMessage remoteMessage) {
    return remoteMessage.data['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(RemoteMessage remoteMessage) {
    return remoteMessage.data['type'] == 'call_incoming' &&
        ((remoteMessage.data['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }

  Future<Call?> consumeIncomingCall() async {
    // We need to wait for a second to be sure sharedPreferences has been updated
    await _sharedPreferences.reload();
    final incomingCallCid = _sharedPreferences.getString('incomingCallCid');
    await _sharedPreferences.remove('incomingCallCid');
    print('JcLog: incomingCallCid from sharedPreferences: $incomingCallCid');
    if (incomingCallCid != null) {
      return _client.acceptCall(
        type: incomingCallCid.substring(0, incomingCallCid.indexOf(':')),
        id: incomingCallCid.substring(incomingCallCid.indexOf(':') + 1),
      );
    }
    return Future.value();
  }
}
