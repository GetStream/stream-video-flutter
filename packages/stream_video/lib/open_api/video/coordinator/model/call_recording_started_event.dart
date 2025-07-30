//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_recording_started_event.g.dart';

/// This event is sent when call recording has started
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [egressId]
/// * [type] - The type of event: \"call.recording_started\" in this case
@BuiltValue()
abstract class CallRecordingStartedEvent
    implements
        Built<CallRecordingStartedEvent, CallRecordingStartedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'egress_id')
  String get egressId;

  /// The type of event: \"call.recording_started\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallRecordingStartedEvent._();

  factory CallRecordingStartedEvent(
          [void updates(CallRecordingStartedEventBuilder b)]) =
      _$CallRecordingStartedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRecordingStartedEventBuilder b) =>
      b..type = 'call.recording_started';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRecordingStartedEvent> get serializer =>
      _$CallRecordingStartedEventSerializer();
}

class _$CallRecordingStartedEventSerializer
    implements PrimitiveSerializer<CallRecordingStartedEvent> {
  @override
  final Iterable<Type> types = const [
    CallRecordingStartedEvent,
    _$CallRecordingStartedEvent
  ];

  @override
  final String wireName = r'CallRecordingStartedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRecordingStartedEvent object, {
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
    CallRecordingStartedEvent object, {
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
    required CallRecordingStartedEventBuilder result,
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
  CallRecordingStartedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRecordingStartedEventBuilder();
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
