import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'stream_video_push_params.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamVideoPushParams extends CallKitParams {
  const StreamVideoPushParams({
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

  const StreamVideoPushParams._internal({
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
  StreamVideoPushParams copyWith({
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
    Map<String, Object?>? extra,
    Map<String, Object?>? headers,
    AndroidParams? android,
    IOSParams? ios,
  }) {
    return StreamVideoPushParams._internal(
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
  StreamVideoPushParams merge(StreamVideoPushParams? other) {
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
      missedCallNotification:
          missedCallNotification?.merge(other.missedCallNotification),
      extra: other.extra,
      headers: other.headers,
      android: android?.merge(other.android),
      ios: ios?.merge(other.ios),
    );
  }

  factory StreamVideoPushParams.fromJson(Map<String, dynamic> json) =>
      _$StreamVideoPushParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StreamVideoPushParamsToJson(this);
}

extension on IOSParams {
  IOSParams copyWith({
    String? iconName,
    String? handleType,
    bool? supportsVideo,
    int? maximumCallGroups,
    int? maximumCallsPerCallGroup,
    String? audioSessionMode,
    bool? audioSessionActive,
    double? audioSessionPreferredSampleRate,
    double? audioSessionPreferredIOBufferDuration,
    bool? configureAudioSession,
    bool? supportsDTMF,
    bool? supportsHolding,
    bool? supportsGrouping,
    bool? supportsUngrouping,
    String? ringtonePath,
  }) {
    return IOSParams(
      iconName: iconName ?? this.iconName,
      handleType: handleType ?? this.handleType,
      supportsVideo: supportsVideo ?? this.supportsVideo,
      maximumCallGroups: maximumCallGroups ?? this.maximumCallGroups,
      maximumCallsPerCallGroup:
          maximumCallsPerCallGroup ?? this.maximumCallsPerCallGroup,
      audioSessionMode: audioSessionMode ?? this.audioSessionMode,
      audioSessionActive: audioSessionActive ?? this.audioSessionActive,
      audioSessionPreferredSampleRate: audioSessionPreferredSampleRate ??
          this.audioSessionPreferredSampleRate,
      audioSessionPreferredIOBufferDuration:
          audioSessionPreferredIOBufferDuration ??
              this.audioSessionPreferredIOBufferDuration,
      configureAudioSession:
          configureAudioSession ?? this.configureAudioSession,
      supportsDTMF: supportsDTMF ?? this.supportsDTMF,
      supportsHolding: supportsHolding ?? this.supportsHolding,
      supportsGrouping: supportsGrouping ?? this.supportsGrouping,
      supportsUngrouping: supportsUngrouping ?? this.supportsUngrouping,
      ringtonePath: ringtonePath ?? this.ringtonePath,
    );
  }

  IOSParams merge(IOSParams? other) {
    if (other == null) return this;

    return copyWith(
      iconName: other.iconName,
      handleType: other.handleType,
      supportsVideo: other.supportsVideo,
      maximumCallGroups: other.maximumCallGroups,
      maximumCallsPerCallGroup: other.maximumCallsPerCallGroup,
      audioSessionMode: other.audioSessionMode,
      audioSessionActive: other.audioSessionActive,
      audioSessionPreferredSampleRate: other.audioSessionPreferredSampleRate,
      audioSessionPreferredIOBufferDuration:
          other.audioSessionPreferredIOBufferDuration,
      configureAudioSession: other.configureAudioSession,
      supportsDTMF: other.supportsDTMF,
      supportsHolding: other.supportsHolding,
      supportsGrouping: other.supportsGrouping,
      supportsUngrouping: other.supportsUngrouping,
      ringtonePath: other.ringtonePath,
    );
  }
}

extension on AndroidParams {
  AndroidParams copyWith({
    bool? isCustomNotification,
    bool? isCustomSmallExNotification,
    bool? isShowLogo,
    String? ringtonePath,
    String? backgroundColor,
    String? backgroundUrl,
    String? actionColor,
    String? incomingCallNotificationChannelName,
    String? missedCallNotificationChannelName,
  }) {
    return AndroidParams(
      isCustomNotification: isCustomNotification ?? this.isCustomNotification,
      isCustomSmallExNotification:
          isCustomSmallExNotification ?? this.isCustomSmallExNotification,
      isShowLogo: isShowLogo ?? this.isShowLogo,
      ringtonePath: ringtonePath ?? this.ringtonePath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      actionColor: actionColor ?? this.actionColor,
      incomingCallNotificationChannelName:
          incomingCallNotificationChannelName ??
              this.incomingCallNotificationChannelName,
      missedCallNotificationChannelName: missedCallNotificationChannelName ??
          this.missedCallNotificationChannelName,
    );
  }

  AndroidParams merge(AndroidParams? other) {
    if (other == null) return this;

    return copyWith(
      isCustomNotification: other.isCustomNotification,
      isCustomSmallExNotification: other.isCustomSmallExNotification,
      isShowLogo: other.isShowLogo,
      ringtonePath: other.ringtonePath,
      backgroundColor: other.backgroundColor,
      backgroundUrl: other.backgroundUrl,
      actionColor: other.actionColor,
      incomingCallNotificationChannelName:
          other.incomingCallNotificationChannelName,
      missedCallNotificationChannelName:
          other.missedCallNotificationChannelName,
    );
  }
}

extension on NotificationParams {
  NotificationParams copyWith({
    int? id,
    bool? showNotification,
    String? subtitle,
    String? callbackText,
    bool? isShowCallback,
    int? count,
  }) {
    return NotificationParams(
      id: id ?? this.id,
      showNotification: showNotification ?? this.showNotification,
      subtitle: subtitle ?? this.subtitle,
      callbackText: callbackText ?? this.callbackText,
      isShowCallback: isShowCallback ?? this.isShowCallback,
      count: count ?? this.count,
    );
  }

  NotificationParams merge(NotificationParams? other) {
    if (other == null) return this;

    return copyWith(
      id: other.id,
      showNotification: other.showNotification,
      subtitle: other.subtitle,
      callbackText: other.callbackText,
      isShowCallback: other.isShowCallback,
      count: other.count,
    );
  }
}
