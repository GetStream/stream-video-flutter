library stream_video_push_notification;

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:stream_video/stream_video.dart';

import 'src/call_notification_wrapper.dart';
import 'src/stream_video_push_notification_event_channel.dart';
import 'src/stream_video_push_notification_method_channel.dart';

typedef CallEventCallback = void Function(StreamCallCid cid);

class StreamVideoPushNotificationManager implements PushNotificationManager {
  StreamVideoPushNotificationManager._create({
    required CoordinatorClient client,
    required CallNotificationWrapper callNotification,
    required StreamVideoPushNotificationMethodChannel methodChannel,
    required StreamVideoPushNotificationEventChannel eventChannel,
    String? firebaseProviderName,
    String? apnsProviderName,
    CallEventCallback? onCallAccepted,
    CallEventCallback? onCallRejected,
  })  : _client = client,
        _callNotification = callNotification,
        _methodChannel = methodChannel,
        _eventChannel = eventChannel,
        _firebaseProviderName = firebaseProviderName,
        _apnsProviderName = apnsProviderName {
    _eventChannel.onEvent.listen((event) {
      if (event.type == NativeEventType.ACTION_INCOMING_CALL) {
        _showCall(event.content['call_cid']);
      }
    });
    FlutterCallkitIncoming.onEvent.listen((event) {
      if(event == null) {
        return;
      }

      if(event.event == Event.actionCallAccept) {
        var cid = StreamCallCid(cid: event.body['extra']['incomingCallCid']);
        _acceptCall(cid);
        onCallAccepted?.call(cid);
      } else if (event.event == Event.actionCallDecline) {
        var cid = StreamCallCid(cid: event.body['extra']['incomingCallCid']);
        _rejectCall(cid);
        onCallRejected?.call(cid);
      }
    });
  }

  final _logger = taggedLogger(tag: 'SV:PNManager');
  final CoordinatorClient _client;
  final CallNotificationWrapper _callNotification;
  final StreamVideoPushNotificationMethodChannel _methodChannel;
  final StreamVideoPushNotificationEventChannel _eventChannel;
  final String? _firebaseProviderName;
  final String? _apnsProviderName;

  @override
  Future<void> onUserLoggedIn() async {
    if (Platform.isAndroid) {
      _registerAndroidDevice();
    } else if (Platform.isIOS) {
      _registerIOSDevice();
    }
  }

  Future<void> _registerAndroidDevice() async {
    if (_firebaseProviderName == null) {
      _logger.w(() => '[registerAndroidDevice] No Firebase provider name set');
      return;
    }

    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        _logger.d(() => '[registerAndroidDevice] refreshedToken: $token');
        await _registerFirebaseToken(token);
      });
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        _logger.d(() => '[registerAndroidDevice] token: $token');
        await _registerFirebaseToken(token);
      } else {
        _logger.w(() => '[registerAndroidDevice] Firebase Token was null');
      }
    }
  }

  Future<void> _registerIOSDevice() async {
    if (_apnsProviderName == null) {
      _logger.w(() => '[registerIOSDevice] No APNS provider name set');
      return;
    }

    final token = await _methodChannel.getDevicePushTokenVoIP();
    _logger.d(() => '[registerIOSDevice] token: $token');
    if (token != null) {
      await _client.createDevice(
        id: token,
        voipToken: true,
        pushProvider: CreateDeviceRequestPushProviderEnum.apn,
        pushProviderName: _apnsProviderName,
      );
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    await _client.createDevice(
      id: token,
      pushProvider: CreateDeviceRequestPushProviderEnum.firebase,
      pushProviderName: _firebaseProviderName,
    );
  }

  Future<bool> _showCall(String cid) async {
    final streamCallCid = StreamCallCid(cid: cid);
    final call = await _from(streamCallCid);
    if (call != null) {
      await showCallIncoming(
        cid: streamCallCid,
        callers: call.metadata.users.values.map((e) => e.name).join(', '),
        avatarUrl: call.metadata.users.values.firstOrNull?.image,
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
    return payload['type'] == 'call.ring' &&
        ((payload['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }

  Future<CallCreatedData?> _from(StreamCallCid streamCallCid) async {
    final result = await _client.getOrCreateCall(callCid: streamCallCid);
    return result.getDataOrNull()?.data;
  }

  @override
  Future<void> showCallIncoming({
    required StreamCallCid cid,
    required String callers,
    required void Function(StreamCallCid streamCallCid) onCallAccepted,
    required void Function(StreamCallCid streamCallCid) onCallRejected,
    bool isVideoCall = true,
    String? avatarUrl,
  }) {
    return _callNotification.showCallNotification(
      streamCallCid: cid,
      callers: callers,
      isVideoCall: isVideoCall,
      avatarUrl: avatarUrl,
      onCallAccepted: onCallAccepted,
      onCallRejected: onCallRejected,
    );
  }

  @override
  Future<CallCreatedData?> consumeIncomingCall() async {
    final calls = await FlutterCallkitIncoming.activeCalls();

    // return if calls and data is not available.
    if (calls is! List) return null;
    final call = calls.lastOrNull;
    if(call is! Map) return null;

    final incomingCid = call['extra']?['incomingCallCid'];

    if (incomingCid == null) return null;

    return _from(StreamCallCid(cid: incomingCid));
  }

  @override
  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  static PushNotificationManagerFactory factory({
    String? firebaseProviderName,
    String? apnsProviderName,
    CallNotificationWrapper callNotification = const CallNotificationWrapper(),
    StreamVideoPushNotificationMethodChannel methodChannel =
        const StreamVideoPushNotificationMethodChannel(),
    StreamVideoPushNotificationEventChannel eventChannel =
        const StreamVideoPushNotificationEventChannel(),
    CallEventCallback? onCallAccepted,
    CallEventCallback? onCallRejected,
  }) {
    return (client) async {
      return StreamVideoPushNotificationManager._create(
        client: client,
        callNotification: callNotification,
        methodChannel: methodChannel,
        eventChannel: eventChannel,
        apnsProviderName: apnsProviderName,
        firebaseProviderName: firebaseProviderName,
        onCallAccepted: onCallAccepted,
        onCallRejected: onCallRejected,
      );
    };
  }
}
