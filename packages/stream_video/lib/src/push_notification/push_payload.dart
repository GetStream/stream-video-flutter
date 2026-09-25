part of 'push_notification_manager.dart';

/// The wire contract for the push payloads Stream sends.
class StreamPushPayload {
  const StreamPushPayload._();

  /// Marks a payload as Stream's. The SDK acts on nothing without it.
  static const sender = 'stream.video';

  /// Says which side sent the push; [sender] when it is ours.
  static const senderKey = 'sender';

  /// Says what happened, as one of [EventType]'s aliases.
  static const typeKey = 'type';

  /// The call the push is about, as `<type>:<id>`.
  static const callCidKey = 'call_cid';

  /// Who started the call.
  static const createdByIdKey = 'created_by_id';

  /// What to show for whoever started the call.
  static const createdByDisplayNameKey = 'created_by_display_name';

  /// What to show for the call itself, preferred over the caller's name.
  static const callDisplayNameKey = 'call_display_name';

  /// Whether the call has video, as a string.
  static const videoKey = 'video';

  /// Whether [payload] came from Stream at all.
  static bool isStreamPush(Map<String, dynamic> payload) =>
      payload[senderKey] == sender;

  /// Whether [payload] is the ringing push, the only one whose flow waits for
  /// the user to answer.
  static bool isRingingPush(Map<String, dynamic> payload) =>
      _isTyped(payload, EventType.callRing);

  /// Whether [payload] is the missed call push.
  ///
  /// It only posts a notification: no accept, decline, timeout or end is ever
  /// emitted for one, so nothing resolves it later.
  static bool isMissedCallPush(Map<String, dynamic> payload) =>
      _isTyped(payload, EventType.callMissed);

  /// The call [payload] is about, or null when it names none.
  static String? callCidOf(Map<String, dynamic> payload) =>
      payload[callCidKey] as String?;

  /// The call a ringing push is for, or null when [payload] is not one.
  ///
  /// What anything tracking a ringing flow of its own should key on, so it
  /// matches the notification the SDK goes on to post.
  static String? ringingCallCid(Map<String, dynamic> payload) =>
      isRingingPush(payload) ? callCidOf(payload) : null;

  static bool _isTyped(Map<String, dynamic> payload, EventType type) =>
      isStreamPush(payload) && payload[typeKey] == type.alias;
}
