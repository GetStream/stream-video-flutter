//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_moderation_blur_event.g.dart';

/// CallModerationBlurEvent
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [custom]
/// * [type]
/// * [userId]
@BuiltValue()
abstract class CallModerationBlurEvent
    implements Built<CallModerationBlurEvent, CallModerationBlurEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user_id')
  String get userId;

  CallModerationBlurEvent._();

  factory CallModerationBlurEvent(
          [void updates(CallModerationBlurEventBuilder b)]) =
      _$CallModerationBlurEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallModerationBlurEventBuilder b) =>
      b..type = 'call.moderation_blur';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallModerationBlurEvent> get serializer =>
      _$CallModerationBlurEventSerializer();
}

class _$CallModerationBlurEventSerializer
    implements PrimitiveSerializer<CallModerationBlurEvent> {
  @override
  final Iterable<Type> types = const [
    CallModerationBlurEvent,
    _$CallModerationBlurEvent
  ];

  @override
  final String wireName = r'CallModerationBlurEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallModerationBlurEvent object, {
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
    yield r'custom';
    yield serializers.serialize(
      object.custom,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallModerationBlurEvent object, {
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
    required CallModerationBlurEventBuilder result,
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
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallModerationBlurEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallModerationBlurEventBuilder();
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
