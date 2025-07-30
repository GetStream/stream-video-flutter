//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_frame_recording_frame_ready_event.g.dart';

/// This event is sent when a frame is captured from a call
///
/// Properties:
/// * [callCid]
/// * [capturedAt] - The time the frame was captured
/// * [createdAt]
/// * [egressId]
/// * [sessionId] - Call session ID
/// * [trackType] - The type of the track frame was captured from (TRACK_TYPE_VIDEO|TRACK_TYPE_SCREEN_SHARE)
/// * [type] - The type of event: \"call.frame_recording_ready\" in this case
/// * [url] - The URL of the frame
/// * [users] - The users in the frame
@BuiltValue()
abstract class CallFrameRecordingFrameReadyEvent
    implements
        Built<CallFrameRecordingFrameReadyEvent,
            CallFrameRecordingFrameReadyEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  /// The time the frame was captured
  @BuiltValueField(wireName: r'captured_at')
  DateTime get capturedAt;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'egress_id')
  String get egressId;

  /// Call session ID
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// The type of the track frame was captured from (TRACK_TYPE_VIDEO|TRACK_TYPE_SCREEN_SHARE)
  @BuiltValueField(wireName: r'track_type')
  String get trackType;

  /// The type of event: \"call.frame_recording_ready\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  /// The URL of the frame
  @BuiltValueField(wireName: r'url')
  String get url;

  /// The users in the frame
  @BuiltValueField(wireName: r'users')
  BuiltMap<String, UserResponse> get users;

  CallFrameRecordingFrameReadyEvent._();

  factory CallFrameRecordingFrameReadyEvent(
          [void updates(CallFrameRecordingFrameReadyEventBuilder b)]) =
      _$CallFrameRecordingFrameReadyEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallFrameRecordingFrameReadyEventBuilder b) =>
      b..type = 'call.frame_recording_ready';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallFrameRecordingFrameReadyEvent> get serializer =>
      _$CallFrameRecordingFrameReadyEventSerializer();
}

class _$CallFrameRecordingFrameReadyEventSerializer
    implements PrimitiveSerializer<CallFrameRecordingFrameReadyEvent> {
  @override
  final Iterable<Type> types = const [
    CallFrameRecordingFrameReadyEvent,
    _$CallFrameRecordingFrameReadyEvent
  ];

  @override
  final String wireName = r'CallFrameRecordingFrameReadyEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallFrameRecordingFrameReadyEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'captured_at';
    yield serializers.serialize(
      object.capturedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'egress_id';
    yield serializers.serialize(
      object.egressId,
      specifiedType: const FullType(String),
    );
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'track_type';
    yield serializers.serialize(
      object.trackType,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(UserResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallFrameRecordingFrameReadyEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CallFrameRecordingFrameReadyEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callCid = valueDes;
          break;
        case r'captured_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.capturedAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'egress_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.egressId = valueDes;
          break;
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        case r'track_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trackType = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType(UserResponse)]),
          ) as BuiltMap<String, UserResponse>;
          result.users.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallFrameRecordingFrameReadyEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallFrameRecordingFrameReadyEventBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
