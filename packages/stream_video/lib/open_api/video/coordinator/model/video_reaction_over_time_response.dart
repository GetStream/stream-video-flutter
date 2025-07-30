//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/count_by_minute_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_reaction_over_time_response.g.dart';

/// VideoReactionOverTimeResponse
///
/// Properties:
/// * [byMinute]
@BuiltValue()
abstract class VideoReactionOverTimeResponse
    implements
        Built<VideoReactionOverTimeResponse,
            VideoReactionOverTimeResponseBuilder> {
  @BuiltValueField(wireName: r'by_minute')
  BuiltList<CountByMinuteResponse?>? get byMinute;

  VideoReactionOverTimeResponse._();

  factory VideoReactionOverTimeResponse(
          [void updates(VideoReactionOverTimeResponseBuilder b)]) =
      _$VideoReactionOverTimeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoReactionOverTimeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoReactionOverTimeResponse> get serializer =>
      _$VideoReactionOverTimeResponseSerializer();
}

class _$VideoReactionOverTimeResponseSerializer
    implements PrimitiveSerializer<VideoReactionOverTimeResponse> {
  @override
  final Iterable<Type> types = const [
    VideoReactionOverTimeResponse,
    _$VideoReactionOverTimeResponse
  ];

  @override
  final String wireName = r'VideoReactionOverTimeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoReactionOverTimeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.byMinute != null) {
      yield r'by_minute';
      yield serializers.serialize(
        object.byMinute,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(CountByMinuteResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoReactionOverTimeResponse object, {
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
    required VideoReactionOverTimeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_minute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(CountByMinuteResponse)]),
          ) as BuiltList<CountByMinuteResponse?>;
          result.byMinute.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoReactionOverTimeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoReactionOverTimeResponseBuilder();
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
