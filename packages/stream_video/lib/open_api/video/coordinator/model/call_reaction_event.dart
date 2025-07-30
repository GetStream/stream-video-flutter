//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/reaction_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_reaction_event.g.dart';

/// This event is sent when a reaction is sent in a call, clients should use this to show the reaction in the call screen
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [reaction]
/// * [type] - The type of event: \"call.reaction_new\" in this case
@BuiltValue()
abstract class CallReactionEvent
    implements Built<CallReactionEvent, CallReactionEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'reaction')
  ReactionResponse get reaction;

  /// The type of event: \"call.reaction_new\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallReactionEvent._();

  factory CallReactionEvent([void updates(CallReactionEventBuilder b)]) =
      _$CallReactionEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallReactionEventBuilder b) =>
      b..type = 'call.reaction_new';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallReactionEvent> get serializer =>
      _$CallReactionEventSerializer();
}

class _$CallReactionEventSerializer
    implements PrimitiveSerializer<CallReactionEvent> {
  @override
  final Iterable<Type> types = const [CallReactionEvent, _$CallReactionEvent];

  @override
  final String wireName = r'CallReactionEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallReactionEvent object, {
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
    yield r'reaction';
    yield serializers.serialize(
      object.reaction,
      specifiedType: const FullType(ReactionResponse),
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
    CallReactionEvent object, {
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
    required CallReactionEventBuilder result,
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
        case r'reaction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReactionResponse),
          ) as ReactionResponse;
          result.reaction.replace(valueDes);
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
  CallReactionEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallReactionEventBuilder();
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
