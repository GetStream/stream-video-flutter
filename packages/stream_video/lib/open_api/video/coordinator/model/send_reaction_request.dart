//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_reaction_request.g.dart';

/// SendReactionRequest
///
/// Properties:
/// * [custom]
/// * [emojiCode]
/// * [type]
@BuiltValue()
abstract class SendReactionRequest
    implements Built<SendReactionRequest, SendReactionRequestBuilder> {
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'emoji_code')
  String? get emojiCode;

  @BuiltValueField(wireName: r'type')
  String get type;

  SendReactionRequest._();

  factory SendReactionRequest([void updates(SendReactionRequestBuilder b)]) =
      _$SendReactionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendReactionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendReactionRequest> get serializer =>
      _$SendReactionRequestSerializer();
}

class _$SendReactionRequestSerializer
    implements PrimitiveSerializer<SendReactionRequest> {
  @override
  final Iterable<Type> types = const [
    SendReactionRequest,
    _$SendReactionRequest
  ];

  @override
  final String wireName = r'SendReactionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendReactionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.custom != null) {
      yield r'custom';
      yield serializers.serialize(
        object.custom,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.emojiCode != null) {
      yield r'emoji_code';
      yield serializers.serialize(
        object.emojiCode,
        specifiedType: const FullType(String),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SendReactionRequest object, {
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
    required SendReactionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'emoji_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.emojiCode = valueDes;
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
  SendReactionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendReactionRequestBuilder();
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
