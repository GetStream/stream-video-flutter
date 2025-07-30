//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_recording_stopped_event.g.dart';

/// This event is sent when call recording has stopped
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [egressId]
/// * [type] - The type of event: \"call.recording_stopped\" in this case
@BuiltValue()
abstract class CallRecordingStoppedEvent
    implements
        Built<CallRecordingStoppedEvent, CallRecordingStoppedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'egress_id')
  String get egressId;

  /// The type of event: \"call.recording_stopped\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallRecordingStoppedEvent._();

  factory CallRecordingStoppedEvent(
          [void updates(CallRecordingStoppedEventBuilder b)]) =
      _$CallRecordingStoppedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRecordingStoppedEventBuilder b) =>
      b..type = 'call.recording_stopped';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRecordingStoppedEvent> get serializer =>
      _$CallRecordingStoppedEventSerializer();
}

class _$CallRecordingStoppedEventSerializer
    implements PrimitiveSerializer<CallRecordingStoppedEvent> {
  @override
  final Iterable<Type> types = const [
    CallRecordingStoppedEvent,
    _$CallRecordingStoppedEvent
  ];

  @override
  final String wireName = r'CallRecordingStoppedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRecordingStoppedEvent object, {
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
    yield r'egress_id';
    yield serializers.serialize(
      object.egressId,
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
    CallRecordingStoppedEvent object, {
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
    required CallRecordingStoppedEventBuilder result,
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
        case r'egress_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.egressId = valueDes;
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
  CallRecordingStoppedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRecordingStoppedEventBuilder();
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
