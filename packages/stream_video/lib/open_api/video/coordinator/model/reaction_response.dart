//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reaction_response.g.dart';

/// ReactionResponse
///
/// Properties:
/// * [custom]
/// * [emojiCode]
/// * [type]
/// * [user]
@BuiltValue()
abstract class ReactionResponse
    implements Built<ReactionResponse, ReactionResponseBuilder> {
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'emoji_code')
  String? get emojiCode;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  ReactionResponse._();

  factory ReactionResponse([void updates(ReactionResponseBuilder b)]) =
      _$ReactionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReactionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReactionResponse> get serializer =>
      _$ReactionResponseSerializer();
}

class _$ReactionResponseSerializer
    implements PrimitiveSerializer<ReactionResponse> {
  @override
  final Iterable<Type> types = const [ReactionResponse, _$ReactionResponse];

  @override
  final String wireName = r'ReactionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReactionResponse object, {
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
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReactionResponse object, {
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
    required ReactionResponseBuilder result,
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
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReactionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReactionResponseBuilder();
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
