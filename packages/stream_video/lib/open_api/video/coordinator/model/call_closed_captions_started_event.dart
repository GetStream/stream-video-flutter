//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_closed_captions_started_event.g.dart';

/// This event is sent when call closed caption has started
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [type] - The type of event: \"call.closed_captions_started\" in this case
@BuiltValue()
abstract class CallClosedCaptionsStartedEvent
    implements
        Built<CallClosedCaptionsStartedEvent,
            CallClosedCaptionsStartedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.closed_captions_started\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallClosedCaptionsStartedEvent._();

  factory CallClosedCaptionsStartedEvent(
          [void updates(CallClosedCaptionsStartedEventBuilder b)]) =
      _$CallClosedCaptionsStartedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallClosedCaptionsStartedEventBuilder b) =>
      b..type = 'call.closed_captions_started';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallClosedCaptionsStartedEvent> get serializer =>
      _$CallClosedCaptionsStartedEventSerializer();
}

class _$CallClosedCaptionsStartedEventSerializer
    implements PrimitiveSerializer<CallClosedCaptionsStartedEvent> {
  @override
  final Iterable<Type> types = const [
    CallClosedCaptionsStartedEvent,
    _$CallClosedCaptionsStartedEvent
  ];

  @override
  final String wireName = r'CallClosedCaptionsStartedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallClosedCaptionsStartedEvent object, {
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
    CallClosedCaptionsStartedEvent object, {
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
    required CallClosedCaptionsStartedEventBuilder result,
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
  CallClosedCaptionsStartedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallClosedCaptionsStartedEventBuilder();
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
