//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_rtmp_broadcast_started_event.g.dart';

/// This event is sent when RTMP broadcast has started
///
/// Properties:
/// * [callCid] - The unique identifier for a call (<type>:<id>)
/// * [createdAt] - Date/time of creation
/// * [name] - Name of the given RTMP broadcast
/// * [type] - The type of event: \"call.rtmp_broadcast_started\" in this case
@BuiltValue()
abstract class CallRtmpBroadcastStartedEvent
    implements
        Built<CallRtmpBroadcastStartedEvent,
            CallRtmpBroadcastStartedEventBuilder> {
  /// The unique identifier for a call (<type>:<id>)
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Name of the given RTMP broadcast
  @BuiltValueField(wireName: r'name')
  String get name;

  /// The type of event: \"call.rtmp_broadcast_started\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallRtmpBroadcastStartedEvent._();

  factory CallRtmpBroadcastStartedEvent(
          [void updates(CallRtmpBroadcastStartedEventBuilder b)]) =
      _$CallRtmpBroadcastStartedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRtmpBroadcastStartedEventBuilder b) =>
      b..type = 'call.rtmp_broadcast_started';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRtmpBroadcastStartedEvent> get serializer =>
      _$CallRtmpBroadcastStartedEventSerializer();
}

class _$CallRtmpBroadcastStartedEventSerializer
    implements PrimitiveSerializer<CallRtmpBroadcastStartedEvent> {
  @override
  final Iterable<Type> types = const [
    CallRtmpBroadcastStartedEvent,
    _$CallRtmpBroadcastStartedEvent
  ];

  @override
  final String wireName = r'CallRtmpBroadcastStartedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRtmpBroadcastStartedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallRtmpBroadcastStartedEvent object, {
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
    required CallRtmpBroadcastStartedEventBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallRtmpBroadcastStartedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRtmpBroadcastStartedEventBuilder();
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
