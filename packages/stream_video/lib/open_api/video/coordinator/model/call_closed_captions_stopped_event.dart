//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_closed_captions_stopped_event.g.dart';

/// This event is sent when call closed captions has stopped
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [type] - The type of event: \"call.transcription_stopped\" in this case
@BuiltValue()
abstract class CallClosedCaptionsStoppedEvent
    implements
        Built<CallClosedCaptionsStoppedEvent,
            CallClosedCaptionsStoppedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.transcription_stopped\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallClosedCaptionsStoppedEvent._();

  factory CallClosedCaptionsStoppedEvent(
          [void updates(CallClosedCaptionsStoppedEventBuilder b)]) =
      _$CallClosedCaptionsStoppedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallClosedCaptionsStoppedEventBuilder b) =>
      b..type = 'call.closed_captions_stopped';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallClosedCaptionsStoppedEvent> get serializer =>
      _$CallClosedCaptionsStoppedEventSerializer();
}

class _$CallClosedCaptionsStoppedEventSerializer
    implements PrimitiveSerializer<CallClosedCaptionsStoppedEvent> {
  @override
  final Iterable<Type> types = const [
    CallClosedCaptionsStoppedEvent,
    _$CallClosedCaptionsStoppedEvent
  ];

  @override
  final String wireName = r'CallClosedCaptionsStoppedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallClosedCaptionsStoppedEvent object, {
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
    CallClosedCaptionsStoppedEvent object, {
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
    required CallClosedCaptionsStoppedEventBuilder result,
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
  CallClosedCaptionsStoppedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallClosedCaptionsStoppedEventBuilder();
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
