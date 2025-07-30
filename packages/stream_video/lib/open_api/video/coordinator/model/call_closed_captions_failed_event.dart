//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_closed_captions_failed_event.g.dart';

/// This event is sent when call closed captions has failed
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [type] - The type of event: \"call.closed_captions_failed\" in this case
@BuiltValue()
abstract class CallClosedCaptionsFailedEvent
    implements
        Built<CallClosedCaptionsFailedEvent,
            CallClosedCaptionsFailedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.closed_captions_failed\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallClosedCaptionsFailedEvent._();

  factory CallClosedCaptionsFailedEvent(
          [void updates(CallClosedCaptionsFailedEventBuilder b)]) =
      _$CallClosedCaptionsFailedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallClosedCaptionsFailedEventBuilder b) =>
      b..type = 'call.closed_captions_failed';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallClosedCaptionsFailedEvent> get serializer =>
      _$CallClosedCaptionsFailedEventSerializer();
}

class _$CallClosedCaptionsFailedEventSerializer
    implements PrimitiveSerializer<CallClosedCaptionsFailedEvent> {
  @override
  final Iterable<Type> types = const [
    CallClosedCaptionsFailedEvent,
    _$CallClosedCaptionsFailedEvent
  ];

  @override
  final String wireName = r'CallClosedCaptionsFailedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallClosedCaptionsFailedEvent object, {
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
    CallClosedCaptionsFailedEvent object, {
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
    required CallClosedCaptionsFailedEventBuilder result,
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
  CallClosedCaptionsFailedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallClosedCaptionsFailedEventBuilder();
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
