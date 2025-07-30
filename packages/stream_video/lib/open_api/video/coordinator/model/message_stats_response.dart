//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/count_by_minute_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'message_stats_response.g.dart';

/// MessageStatsResponse
///
/// Properties:
/// * [countOverTime]
@BuiltValue()
abstract class MessageStatsResponse
    implements Built<MessageStatsResponse, MessageStatsResponseBuilder> {
  @BuiltValueField(wireName: r'count_over_time')
  BuiltList<CountByMinuteResponse?>? get countOverTime;

  MessageStatsResponse._();

  factory MessageStatsResponse([void updates(MessageStatsResponseBuilder b)]) =
      _$MessageStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MessageStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MessageStatsResponse> get serializer =>
      _$MessageStatsResponseSerializer();
}

class _$MessageStatsResponseSerializer
    implements PrimitiveSerializer<MessageStatsResponse> {
  @override
  final Iterable<Type> types = const [
    MessageStatsResponse,
    _$MessageStatsResponse
  ];

  @override
  final String wireName = r'MessageStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MessageStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.countOverTime != null) {
      yield r'count_over_time';
      yield serializers.serialize(
        object.countOverTime,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(CountByMinuteResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MessageStatsResponse object, {
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
    required MessageStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count_over_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(CountByMinuteResponse)]),
          ) as BuiltList<CountByMinuteResponse?>;
          result.countOverTime.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MessageStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessageStatsResponseBuilder();
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
