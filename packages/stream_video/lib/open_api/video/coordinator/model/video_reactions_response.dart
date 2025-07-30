//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/video_reaction_over_time_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_reactions_response.g.dart';

/// VideoReactionsResponse
///
/// Properties:
/// * [countOverTime]
/// * [reaction]
@BuiltValue()
abstract class VideoReactionsResponse
    implements Built<VideoReactionsResponse, VideoReactionsResponseBuilder> {
  @BuiltValueField(wireName: r'count_over_time')
  VideoReactionOverTimeResponse? get countOverTime;

  @BuiltValueField(wireName: r'reaction')
  String get reaction;

  VideoReactionsResponse._();

  factory VideoReactionsResponse(
          [void updates(VideoReactionsResponseBuilder b)]) =
      _$VideoReactionsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoReactionsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoReactionsResponse> get serializer =>
      _$VideoReactionsResponseSerializer();
}

class _$VideoReactionsResponseSerializer
    implements PrimitiveSerializer<VideoReactionsResponse> {
  @override
  final Iterable<Type> types = const [
    VideoReactionsResponse,
    _$VideoReactionsResponse
  ];

  @override
  final String wireName = r'VideoReactionsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoReactionsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.countOverTime != null) {
      yield r'count_over_time';
      yield serializers.serialize(
        object.countOverTime,
        specifiedType: const FullType(VideoReactionOverTimeResponse),
      );
    }
    yield r'reaction';
    yield serializers.serialize(
      object.reaction,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoReactionsResponse object, {
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
    required VideoReactionsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count_over_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VideoReactionOverTimeResponse),
          ) as VideoReactionOverTimeResponse;
          result.countOverTime.replace(valueDes);
          break;
        case r'reaction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reaction = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoReactionsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoReactionsResponseBuilder();
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
