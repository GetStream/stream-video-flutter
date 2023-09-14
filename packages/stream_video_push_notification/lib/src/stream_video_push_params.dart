import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:meta/meta.dart';

class VideoPushParams extends CallKitParams {
  const VideoPushParams({
    super.appName,
    super.avatar,
    super.duration,
    super.textAccept,
    super.textDecline,
    super.missedCallNotification,
    super.extra,
    super.headers,
    super.android,
    super.ios,
  });

  const VideoPushParams._internal({
    super.id,
    super.nameCaller,
    super.appName,
    super.avatar,
    super.handle,
    super.type,
    super.duration,
    super.textAccept,
    super.textDecline,
    super.missedCallNotification,
    super.extra,
    super.headers,
    super.android,
    super.ios,
  });

  @internal
  VideoPushParams copyWith({
    String? id,
    String? nameCaller,
    String? appName,
    String? avatar,
    String? handle,
    int? type,
    int? duration,
    String? textAccept,
    String? textDecline,
    NotificationParams? missedCallNotification,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
    AndroidParams? android,
    IOSParams? ios,
  }) {
    return VideoPushParams._internal(
      id: id ?? this.id,
      nameCaller: nameCaller ?? this.nameCaller,
      appName: appName ?? this.appName,
      avatar: avatar ?? this.avatar,
      handle: handle ?? this.handle,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      textAccept: textAccept ?? this.textAccept,
      textDecline: textDecline ?? this.textDecline,
      missedCallNotification:
          missedCallNotification ?? this.missedCallNotification,
      extra: extra ?? this.extra,
      headers: headers ?? this.headers,
      android: android ?? this.android,
      ios: ios ?? this.ios,
    );
  }

  @internal
  VideoPushParams merge(VideoPushParams? other) {
    if (other == null) return this;

    return copyWith(
      id: other.id,
      nameCaller: other.nameCaller,
      appName: other.appName,
      avatar: other.avatar,
      handle: other.handle,
      type: other.type,
      duration: other.duration,
      textAccept: other.textAccept,
      textDecline: other.textDecline,
      missedCallNotification: other.missedCallNotification,
      extra: other.extra,
      headers: other.headers,
      android: other.android,
      ios: other.ios,
    );
  }
}
