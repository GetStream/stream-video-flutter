//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_transcription_stopped_event.g.dart';

/// This event is sent when call transcription has stopped
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [egressId]
/// * [type] - The type of event: \"call.transcription_stopped\" in this case
@BuiltValue()
abstract class CallTranscriptionStoppedEvent
    implements
        Built<CallTranscriptionStoppedEvent,
            CallTranscriptionStoppedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'egress_id')
  String get egressId;

  /// The type of event: \"call.transcription_stopped\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallTranscriptionStoppedEvent._();

  factory CallTranscriptionStoppedEvent(
          [void updates(CallTranscriptionStoppedEventBuilder b)]) =
      _$CallTranscriptionStoppedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallTranscriptionStoppedEventBuilder b) =>
      b..type = 'call.transcription_stopped';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallTranscriptionStoppedEvent> get serializer =>
      _$CallTranscriptionStoppedEventSerializer();
}

class _$CallTranscriptionStoppedEventSerializer
    implements PrimitiveSerializer<CallTranscriptionStoppedEvent> {
  @override
  final Iterable<Type> types = const [
    CallTranscriptionStoppedEvent,
    _$CallTranscriptionStoppedEvent
  ];

  @override
  final String wireName = r'CallTranscriptionStoppedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallTranscriptionStoppedEvent object, {
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
    CallTranscriptionStoppedEvent object, {
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
    required CallTranscriptionStoppedEventBuilder result,
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
  CallTranscriptionStoppedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallTranscriptionStoppedEventBuilder();
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
