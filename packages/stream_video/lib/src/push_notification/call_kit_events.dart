part of 'push_notification_manager.dart';

/// Represents an event related to the CallKit.
///
/// Instances of this class are used to signify different call events that can be
/// received from [PushNotificationManager].
sealed class CallKitEvent with EquatableMixin {
  const CallKitEvent();

  @override
  bool? get stringify => true;
}

/// Event for updating the VoIP push token on the device (iOS specific).
class ActionDidUpdateDevicePushTokenVoip extends CallKitEvent {
  /// Creates an [ActionDidUpdateDevicePushTokenVoip] event instance with the
  /// specified [token].
  const ActionDidUpdateDevicePushTokenVoip({required this.token});

  /// The updated device push token for VoIP.
  final String token;

  @override
  List<Object?> get props => [token];
}

/// Represents an incoming call event.
///
/// This event is triggered when a incoming call is received.
class ActionCallIncoming extends CallKitEvent {
  /// Creates an [ActionCallIncoming] event instance with the specified [data].
  const ActionCallIncoming({required this.data});

  /// The call data associated with the incoming call.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call start event.
///
/// This event is triggered when a outgoing call is started.
class ActionCallStart extends CallKitEvent {
  /// Creates an [ActionCallStart] event instance with the specified [data].
  const ActionCallStart({required this.data});

  /// The call data associated with the outgoing call.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call accept event.
///
/// This event is triggered when a incoming call is accepted. This can happen
/// when a user clicks on the "Accept" action from a incoming call
/// notification.
class ActionCallAccept extends CallKitEvent {
  /// Creates an [ActionCallAccept] event instance with the specified [data].
  const ActionCallAccept({required this.data});

  /// The call data associated with the call that was accepted.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call decline event.
///
/// This event is triggered when a incoming call is declined. This can happen
/// when a user clicks on the "Decline" action from a incoming call
/// notification.
class ActionCallDecline extends CallKitEvent {
  /// Creates an [ActionCallDecline] event instance with the specified [data].
  const ActionCallDecline({required this.data});

  /// The call data associated with the call that was declined.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call end event.
///
/// This event is triggered when a incoming or outgoing call is ended. This can
/// happen when a user clicks on the "End" action from the notification.
class ActionCallEnded extends CallKitEvent {
  /// Creates an [ActionCallEnded] event instance with the specified [data].
  const ActionCallEnded({required this.data});

  /// The call data associated with the call that ended.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call timeout event.
///
/// This event is triggered when a call times out. This can happen when a user
/// doesn't answer a incoming call within a certain time frame.
class ActionCallTimeout extends CallKitEvent {
  /// Creates an [ActionCallTimeout] event instance with the specified [data].
  const ActionCallTimeout({required this.data});

  /// The call data associated with the call that timed out.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call callback event.
///
/// This event is triggered when a call is called back. This can happen when a
/// user clicks on the "Call back" action from a missed call notification.
///
/// Note: This event is only available on Android.
class ActionCallCallback extends CallKitEvent {
  /// Creates an [ActionCallCallback] event instance with the specified [data].
  const ActionCallCallback({required this.data});

  /// The call data associated with the call that was called back.
  final CallData data;

  @override
  List<Object?> get props => [data];
}

/// Represents a call toggle hold event.
///
/// Note: This event is only available on iOS.
class ActionCallToggleHold extends CallKitEvent {
  /// Creates an [ActionCallToggleHold] event instance with the specified [uuid]
  /// and [isOnHold] flag.
  const ActionCallToggleHold({
    required this.uuid,
    required this.isOnHold,
  });

  /// The unique identifier for the call.
  final String uuid;

  /// Indicates whether the call is on hold.
  final bool isOnHold;

  @override
  List<Object?> get props => [uuid, isOnHold];
}

/// Represents a call toggle mute event.
///
/// Note: This event is only available on iOS.
class ActionCallToggleMute extends CallKitEvent {
  /// Creates an [ActionCallToggleMute] event instance with the specified [uuid]
  /// and [isMuted] flag.
  const ActionCallToggleMute({
    required this.uuid,
    required this.isMuted,
  });

  /// The unique identifier for the call.
  final String uuid;

  /// Indicates whether the call is muted.
  final bool isMuted;

  @override
  List<Object?> get props => [uuid, isMuted];
}

/// Represents a call toggle DMTF event.
///
/// Note: This event is only available on iOS.
class ActionCallToggleDmtf extends CallKitEvent {
  /// Creates an [ActionCallToggleDmtf] event instance with the specified [uuid]
  /// and [digits].
  const ActionCallToggleDmtf({
    required this.uuid,
    required this.digits,
  });

  /// The unique identifier for the call.
  final String uuid;

  /// The digits to send.
  final String digits;

  @override
  List<Object?> get props => [uuid, digits];
}

/// Represents a call toggle group event.
///
/// Note: This event is only available on iOS.
class ActionCallToggleGroup extends CallKitEvent {
  /// Creates an [ActionCallToggleGroup] event instance with the specified
  /// [uuid] and [callUUIDToGroupWith].
  const ActionCallToggleGroup({
    required this.uuid,
    required this.callUUIDToGroupWith,
  });

  /// The unique identifier for the call.
  final String uuid;

  /// The unique identifier for the call to group with.
  final String callUUIDToGroupWith;

  @override
  List<Object?> get props => [uuid, callUUIDToGroupWith];
}

/// Represents a call toggle audio session event.
///
/// Note: This event is only available on iOS.
class ActionCallToggleAudioSession extends CallKitEvent {
  /// Creates an [ActionCallToggleAudioSession] event instance with the
  /// specified [isActivate] flag.
  const ActionCallToggleAudioSession({required this.isActivate});

  /// Indicates whether the audio session is active.
  final bool isActivate;

  @override
  List<Object?> get props => [isActivate];
}

/// Represents a custom call event.
class ActionCallCustom extends CallKitEvent {
  /// Creates an [ActionCallCustom] event instance with the specified [body].
  const ActionCallCustom(this.body);

  /// The custom data associated with the call.
  final Map<String, Object?>? body;

  @override
  List<Object?> get props => [body];
}

/// Represents call data with various properties related to the call.
///
/// This class encapsulates information about an ongoing or past call, including
/// unique identifiers, caller's avatar, handle, name, video availability, and
/// additional extra data associated with the call.
class CallData with EquatableMixin {
  /// Creates a [CallData] instance with the provided details.
  const CallData({
    this.uuid,
    this.callCid,
    this.avatar,
    this.handle,
    this.nameCaller,
    this.hasVideo,
    this.extraData,
  });

  /// Unique identifier for the call.
  final String? uuid;

  /// Call's unique identifier.
  final String? callCid;

  /// Avatar of the caller.
  final String? avatar;

  /// Handle of the caller.
  final String? handle;

  /// Name of the caller.
  final String? nameCaller;

  /// Indicates whether the call has video.
  final bool? hasVideo;

  /// Extra data associated with the call.
  final Map<String, Object?>? extraData;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        uuid,
        callCid,
        avatar,
        handle,
        nameCaller,
        hasVideo,
        extraData,
      ];
}
