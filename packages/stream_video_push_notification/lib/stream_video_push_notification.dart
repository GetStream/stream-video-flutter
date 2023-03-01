library stream_video_push_notification;

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';

import 'src/call_notification_wrapper.dart';
import 'src/stream_video_push_notification_event_channel.dart';
import 'src/stream_video_push_notification_method_channel.dart';

class StreamVideoPushNotificationManager implements PushNotificationManager {
  StreamVideoPushNotificationManager._create({
    required StreamVideo client,
    required SharedPreferences sharedPreferences,
    required CallNotificationWrapper callNotification,
    required StreamVideoPushNotificationMethodChannel methodChannel,
    required StreamVideoPushNotificationEventChannel eventChannel,
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

  final _logger = taggedLogger(tag: 'PNManager');
  final StreamVideo _client;
  final CallNotificationWrapper _callNotification;
  final SharedPreferences _sharedPreferences;
  final StreamVideoPushNotificationMethodChannel _methodChannel;
  final StreamVideoPushNotificationEventChannel _eventChannel;

  @override
  Future<void> onUserLoggedIn() async {
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
        _logger.w(() => 'Firebase Token was null');
      }
    }
  }

  Future<void> _registerIOSDevice() async {
    final token = await _methodChannel.getDevicePushTokenVoIP();
    _logger.d(() => 'New PushTokenVoIP: $token');
    if (token != null) {
      await _client.createDevice(token: token, pushProviderId: 'apn');
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    _logger.d(() => 'New Firebase Token: $token');
    await _client.createDevice(token: token, pushProviderId: 'firebase');
  }

  Future<bool> _showCall(String cid) async {
    final streamCallCid = StreamCallCid(cid: cid);
    final call = await _from(streamCallCid);
    if (call != null) {
      await _callNotification.showCallNotification(
        streamCallCid: streamCallCid,
        callers: call.metadata.users.values.map((e) => e.name).join(', '),
        isVideoCall: true,
        avatarUrl: call.metadata.users.values.firstOrNull?.imageUrl,
        onCallAccepted: _acceptCall,
        onCallRejected: _rejectCall,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> handlePushNotification(Map<String, dynamic> payload) async {
    if (_isValid(payload)) {
      return await _showCall(payload['call_cid'] as String);
    }
    return false;
  }

  Future<void> _acceptCall(StreamCallCid streamCallCid) async {
    await _sharedPreferences.setString('incomingCallCid', streamCallCid.value);
    await _client.acceptCall(cid: streamCallCid);
  }

  Future<void> _rejectCall(StreamCallCid streamCallCid) async {
    await _client.rejectCall(cid: streamCallCid);
  }

  bool _isValid(Map<String, dynamic> payload) {
    return _isFromStreamServer(payload) && _isValidIncomingCall(payload);
  }

  bool _isFromStreamServer(Map<String, dynamic> payload) {
    return payload['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(Map<String, dynamic> payload) {
    return payload['type'] == 'call_incoming' &&
        ((payload['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }

  Future<CallCreated?> _from(StreamCallCid streamCallCid) async {
    return (await _client.getOrCreateCall(cid: streamCallCid))
        .getDataOrNull()
        ?.data;
  }

  Future<CallCreated?> consumeIncomingCall() async {
    // We need to wait for a second to be sure sharedPreferences has been updated
    await _sharedPreferences.reload();
    final incomingCallCid = _sharedPreferences.getString('incomingCallCid');
    await _sharedPreferences.remove('incomingCallCid');
    if (incomingCallCid != null) {
      return _from(StreamCallCid(cid: incomingCallCid));
    }
    return Future.value();
  }

  static Future<StreamVideoPushNotificationManager> create(
    StreamVideo client, {
    SharedPreferences? sharedPreferences,
    CallNotificationWrapper? callNotification,
    StreamVideoPushNotificationMethodChannel? methodChannel,
    StreamVideoPushNotificationEventChannel? eventChannel,
  }) async {
    return StreamVideoPushNotificationManager._create(
      client: client,
      sharedPreferences:
          sharedPreferences ?? await SharedPreferences.getInstance(),
      callNotification: callNotification ?? const CallNotificationWrapper(),
      methodChannel:
          methodChannel ?? const StreamVideoPushNotificationMethodChannel(),
      eventChannel:
          eventChannel ?? const StreamVideoPushNotificationEventChannel(),
    );
  }
}
