//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/participant_count_by_minute_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'participant_count_over_time_response.g.dart';

/// ParticipantCountOverTimeResponse
///
/// Properties:
/// * [byMinute]
@BuiltValue()
abstract class ParticipantCountOverTimeResponse
    implements
        Built<ParticipantCountOverTimeResponse,
            ParticipantCountOverTimeResponseBuilder> {
  @BuiltValueField(wireName: r'by_minute')
  BuiltList<ParticipantCountByMinuteResponse?>? get byMinute;

  ParticipantCountOverTimeResponse._();

  factory ParticipantCountOverTimeResponse(
          [void updates(ParticipantCountOverTimeResponseBuilder b)]) =
      _$ParticipantCountOverTimeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParticipantCountOverTimeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParticipantCountOverTimeResponse> get serializer =>
      _$ParticipantCountOverTimeResponseSerializer();
}

class _$ParticipantCountOverTimeResponseSerializer
    implements PrimitiveSerializer<ParticipantCountOverTimeResponse> {
  @override
  final Iterable<Type> types = const [
    ParticipantCountOverTimeResponse,
    _$ParticipantCountOverTimeResponse
  ];

  @override
  final String wireName = r'ParticipantCountOverTimeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParticipantCountOverTimeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.byMinute != null) {
      yield r'by_minute';
      yield serializers.serialize(
        object.byMinute,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(ParticipantCountByMinuteResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ParticipantCountOverTimeResponse object, {
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
    required ParticipantCountOverTimeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_minute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType.nullable(ParticipantCountByMinuteResponse)]),
          ) as BuiltList<ParticipantCountByMinuteResponse?>;
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
  ParticipantCountOverTimeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParticipantCountOverTimeResponseBuilder();
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
