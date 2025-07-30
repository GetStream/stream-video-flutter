//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_rtmp_broadcast_failed_event.g.dart';

/// This event is sent when a call RTMP broadcast has failed
///
/// Properties:
/// * [callCid] - The unique identifier for a call (<type>:<id>)
/// * [createdAt] - Date/time of creation
/// * [name] - Name of the given RTMP broadcast
/// * [type] - The type of event: \"call.rtmp_broadcast_failed\" in this case
@BuiltValue()
abstract class CallRtmpBroadcastFailedEvent
    implements
        Built<CallRtmpBroadcastFailedEvent,
            CallRtmpBroadcastFailedEventBuilder> {
  /// The unique identifier for a call (<type>:<id>)
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Name of the given RTMP broadcast
  @BuiltValueField(wireName: r'name')
  String get name;

  /// The type of event: \"call.rtmp_broadcast_failed\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallRtmpBroadcastFailedEvent._();

  factory CallRtmpBroadcastFailedEvent(
          [void updates(CallRtmpBroadcastFailedEventBuilder b)]) =
      _$CallRtmpBroadcastFailedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRtmpBroadcastFailedEventBuilder b) =>
      b..type = 'call.rtmp_broadcast_failed';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRtmpBroadcastFailedEvent> get serializer =>
      _$CallRtmpBroadcastFailedEventSerializer();
}

class _$CallRtmpBroadcastFailedEventSerializer
    implements PrimitiveSerializer<CallRtmpBroadcastFailedEvent> {
  @override
  final Iterable<Type> types = const [
    CallRtmpBroadcastFailedEvent,
    _$CallRtmpBroadcastFailedEvent
  ];

  @override
  final String wireName = r'CallRtmpBroadcastFailedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRtmpBroadcastFailedEvent object, {
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
    CallRtmpBroadcastFailedEvent object, {
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
    required CallRtmpBroadcastFailedEventBuilder result,
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
  CallRtmpBroadcastFailedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRtmpBroadcastFailedEventBuilder();
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
