//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_hls_broadcasting_stopped_event.g.dart';

/// This event is sent when HLS broadcasting has stopped
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [type] - The type of event: \"call.hls_broadcasting_stopped\" in this case
@BuiltValue()
abstract class CallHLSBroadcastingStoppedEvent
    implements
        Built<CallHLSBroadcastingStoppedEvent,
            CallHLSBroadcastingStoppedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.hls_broadcasting_stopped\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallHLSBroadcastingStoppedEvent._();

  factory CallHLSBroadcastingStoppedEvent(
          [void updates(CallHLSBroadcastingStoppedEventBuilder b)]) =
      _$CallHLSBroadcastingStoppedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallHLSBroadcastingStoppedEventBuilder b) =>
      b..type = 'call.hls_broadcasting_stopped';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallHLSBroadcastingStoppedEvent> get serializer =>
      _$CallHLSBroadcastingStoppedEventSerializer();
}

class _$CallHLSBroadcastingStoppedEventSerializer
    implements PrimitiveSerializer<CallHLSBroadcastingStoppedEvent> {
  @override
  final Iterable<Type> types = const [
    CallHLSBroadcastingStoppedEvent,
    _$CallHLSBroadcastingStoppedEvent
  ];

  @override
  final String wireName = r'CallHLSBroadcastingStoppedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallHLSBroadcastingStoppedEvent object, {
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallHLSBroadcastingStoppedEvent object, {
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
    required CallHLSBroadcastingStoppedEventBuilder result,
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
  CallHLSBroadcastingStoppedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallHLSBroadcastingStoppedEventBuilder();
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
