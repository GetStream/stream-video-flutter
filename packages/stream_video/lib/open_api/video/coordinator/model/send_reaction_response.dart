//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/reaction_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_reaction_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
/// * [reaction]
@BuiltValue()
abstract class SendReactionResponse
    implements Built<SendReactionResponse, SendReactionResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'reaction')
  ReactionResponse get reaction;

  SendReactionResponse._();

  factory SendReactionResponse([void updates(SendReactionResponseBuilder b)]) =
      _$SendReactionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendReactionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendReactionResponse> get serializer =>
      _$SendReactionResponseSerializer();
}

class _$SendReactionResponseSerializer
    implements PrimitiveSerializer<SendReactionResponse> {
  @override
  final Iterable<Type> types = const [
    SendReactionResponse,
    _$SendReactionResponse
  ];

  @override
  final String wireName = r'SendReactionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendReactionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'reaction';
    yield serializers.serialize(
      object.reaction,
      specifiedType: const FullType(ReactionResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SendReactionResponse object, {
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
    required SendReactionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'reaction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReactionResponse),
          ) as ReactionResponse;
          result.reaction.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SendReactionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendReactionResponseBuilder();
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
