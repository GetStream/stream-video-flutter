import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class StreamVideoEventChannel {
  const StreamVideoEventChannel(
      {EventChannel eventChannel = const EventChannel('stream_video_events')})
      : _eventChannel = eventChannel;

  final EventChannel _eventChannel;

  Stream<NativeEvent> get onEvent =>
      _eventChannel.receiveBroadcastStream().mapNotNull(_parseBroadcast);

  NativeEvent? _parseBroadcast(dynamic data) {
    if (data is Map) {
      return NativeEvent(
        NativeEventType.values.firstWhere((e) => e.name == data['event']),
        Map<String, dynamic>.from(data['body']),
      );
    }
    return null;
  }
}

class NativeEvent {
  NativeEvent(this.type, this.content);

  NativeEventType type;
  dynamic content;
}

enum NativeEventType { ACTION_INCOMING_CALL }
