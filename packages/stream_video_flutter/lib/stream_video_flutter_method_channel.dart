import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../src/call_background/model/notification_payload.dart';
import 'src/call_background/model/service_type.dart';
import 'stream_video_flutter_platform_interface.dart';

/// An implementation of [StreamVideoFlutterPlatform] that uses method channels.
class MethodChannelStreamVideoFlutter extends StreamVideoFlutterPlatform {
  MethodChannelStreamVideoFlutter() {
    methodChannel.setMethodCallHandler(methodHandler);
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_flutter');

  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case 'onBackgroundNotificationContentClick':
        final callCid = call.arguments;
        onBackgroundNotificationContentClick?.call(callCid);
        break;
      case 'onBackgroundNotificationButtonClick':
        final arguments = (call.arguments as List).cast<String>();

        final buttonType = arguments[0];
        final callCid = arguments[1];
        final serviceType = arguments[2];

        onBackgroundNotificationButtonClick?.call(
          buttonType,
          callCid,
          serviceType == ServiceType.call.name
              ? ServiceType.call
              : ServiceType.screenSharing,
        );
        break;
      case 'onPlatformUiLayerDestroyed':
        final callCid = call.arguments;
        onBackgroundNotificationUiLayerDestroyed?.call(callCid);
        break;
    }
  }

  @override
  Future<bool> startBackgroundService({
    required NotificationPayload payload,
    required ServiceType type,
  }) async {
    if (await isBackgroundServiceRunning(type, callCid: payload.callCid) ==
        false) {
      return await methodChannel.invokeMethod(
        'startBackgroundService',
        {
          ...payload.toJson(),
          'type': type.name,
        },
      );
    }
    return false;
  }

  @override
  Future<bool> updateBackgroundService({
    required NotificationPayload payload,
    required ServiceType type,
  }) async {
    if (await isBackgroundServiceRunning(type, callCid: payload.callCid) ==
        true) {
      return await methodChannel.invokeMethod(
        'updateBackgroundService',
        {
          ...payload.toJson(),
          'type': type.name,
        },
      );
    }
    return false;
  }

  @override
  Future<bool> stopBackgroundService(
    ServiceType type, {
    String? callCid,
  }) async {
    if (await isBackgroundServiceRunning(type, callCid: callCid) == true) {
      return await methodChannel.invokeMethod(
        'stopBackgroundService',
        {
          'type': type.name,
          if (callCid != null) 'callCid': callCid,
        },
      );
    }
    return false;
  }

  @override
  Future<bool> isBackgroundServiceRunning(
    ServiceType type, {
    String? callCid,
  }) async {
    return await methodChannel.invokeMethod(
      'isBackgroundServiceRunning',
      {
        'type': type.name,
        if (callCid != null) 'callCid': callCid,
      },
    );
  }

  @override
  Future<bool?> isBackgroundEffectSupported() async {
    return methodChannel.invokeMethod<bool>(
      'isBackgroundEffectSupported',
    );
  }

  @override
  Future<void> registerBlurEffectProcessors() {
    return methodChannel.invokeMethod(
      'registerBlurEffectProcessors',
    );
  }

  @override
  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) {
    return methodChannel.invokeMethod('registerImageEffectProcessors', {
      'backgroundImageUrl': backgroundImageUrl,
    });
  }
}
