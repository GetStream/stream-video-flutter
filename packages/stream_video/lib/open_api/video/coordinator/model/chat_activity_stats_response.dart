//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/message_stats_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_activity_stats_response.g.dart';

/// ChatActivityStatsResponse
///
/// Properties:
/// * [messages]
@BuiltValue()
abstract class ChatActivityStatsResponse
    implements
        Built<ChatActivityStatsResponse, ChatActivityStatsResponseBuilder> {
  @BuiltValueField(wireName: r'Messages')
  MessageStatsResponse? get messages;

  ChatActivityStatsResponse._();

  factory ChatActivityStatsResponse(
          [void updates(ChatActivityStatsResponseBuilder b)]) =
      _$ChatActivityStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatActivityStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatActivityStatsResponse> get serializer =>
      _$ChatActivityStatsResponseSerializer();
}

class _$ChatActivityStatsResponseSerializer
    implements PrimitiveSerializer<ChatActivityStatsResponse> {
  @override
  final Iterable<Type> types = const [
    ChatActivityStatsResponse,
    _$ChatActivityStatsResponse
  ];

  @override
  final String wireName = r'ChatActivityStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatActivityStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.messages != null) {
      yield r'Messages';
      yield serializers.serialize(
        object.messages,
        specifiedType: const FullType(MessageStatsResponse),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatActivityStatsResponse object, {
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
    required ChatActivityStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'Messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MessageStatsResponse),
          ) as MessageStatsResponse;
          result.messages.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatActivityStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatActivityStatsResponseBuilder();
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
