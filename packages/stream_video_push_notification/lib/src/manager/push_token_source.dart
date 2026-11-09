import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

import '../../stream_video_push_notification_platform_interface.dart';
import 'ringing_event_broadcaster.dart';

/// One kind of device push token: where to read it and when it changes.
@internal
abstract class PushTokenSource {
  const PushTokenSource();

  /// The current token, or null when the platform has not issued one.
  Future<String?> token();

  /// Emits a token whenever the platform issues a new one.
  Stream<String> get onRefresh;

  /// The current token, when there is one, followed by every refresh.
  Stream<String> get tokens async* {
    final current = await token();
    if (current != null) yield current;

    yield* onRefresh;
  }
}

/// The PushKit VoIP token of this device. iOS only; empty elsewhere.
@internal
final class VoIPTokenSource extends PushTokenSource {
  const VoIPTokenSource();

  @override
  Future<String?> token() async {
    if (!CurrentPlatform.isIos) return null;

    final token = await StreamVideoPushNotificationPlatform.instance
        .getDevicePushTokenVoIP();

    if (token.isEmpty) return null;
    return token;
  }

  @override
  Stream<String> get onRefresh {
    if (!CurrentPlatform.isIos) return const Stream.empty();

    return RingingEventBroadcaster.shared.onEvent
        .whereType<ActionDidUpdateDevicePushTokenVoip>()
        .map((event) => event.token);
  }
}

/// The APNs token of this device, as Firebase Messaging reports it. iOS only;
/// null elsewhere. Used for the missed-call pushes an app opts into with
/// `registerApnDeviceToken`. There is no refresh stream for it.
@internal
final class ApnsTokenSource extends PushTokenSource {
  const ApnsTokenSource();

  @override
  Future<String?> token() async {
    if (!CurrentPlatform.isIos) return null;

    final token = await FirebaseMessaging.instance.getAPNSToken();
    if (token is! String || token.isEmpty) return null;

    return token;
  }

  @override
  Stream<String> get onRefresh => const Stream.empty();
}

/// The Firebase Cloud Messaging token of this device.
@internal
final class FcmTokenSource extends PushTokenSource {
  const FcmTokenSource();

  @override
  Future<String?> token() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return null;

    return token;
  }

  @override
  Stream<String> get onRefresh => FirebaseMessaging.instance.onTokenRefresh;
}
