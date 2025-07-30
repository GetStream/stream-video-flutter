//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'participant_count_by_minute_response.g.dart';

/// ParticipantCountByMinuteResponse
///
/// Properties:
/// * [first]
/// * [last]
/// * [max]
/// * [min]
/// * [startTs]
@BuiltValue()
abstract class ParticipantCountByMinuteResponse
    implements
        Built<ParticipantCountByMinuteResponse,
            ParticipantCountByMinuteResponseBuilder> {
  @BuiltValueField(wireName: r'first')
  int get first;

  @BuiltValueField(wireName: r'last')
  int get last;

  @BuiltValueField(wireName: r'max')
  int get max;

  @BuiltValueField(wireName: r'min')
  int get min;

  @BuiltValueField(wireName: r'start_ts')
  DateTime get startTs;

  ParticipantCountByMinuteResponse._();

  factory ParticipantCountByMinuteResponse(
          [void updates(ParticipantCountByMinuteResponseBuilder b)]) =
      _$ParticipantCountByMinuteResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParticipantCountByMinuteResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParticipantCountByMinuteResponse> get serializer =>
      _$ParticipantCountByMinuteResponseSerializer();
}

class _$ParticipantCountByMinuteResponseSerializer
    implements PrimitiveSerializer<ParticipantCountByMinuteResponse> {
  @override
  final Iterable<Type> types = const [
    ParticipantCountByMinuteResponse,
    _$ParticipantCountByMinuteResponse
  ];

  @override
  final String wireName = r'ParticipantCountByMinuteResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParticipantCountByMinuteResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'first';
    yield serializers.serialize(
      object.first,
      specifiedType: const FullType(int),
    );
    yield r'last';
    yield serializers.serialize(
      object.last,
      specifiedType: const FullType(int),
    );
    yield r'max';
    yield serializers.serialize(
      object.max,
      specifiedType: const FullType(int),
    );
    yield r'min';
    yield serializers.serialize(
      object.min,
      specifiedType: const FullType(int),
    );
    yield r'start_ts';
    yield serializers.serialize(
      object.startTs,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ParticipantCountByMinuteResponse object, {
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
    required ParticipantCountByMinuteResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'first':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.first = valueDes;
          break;
        case r'last':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.last = valueDes;
          break;
        case r'max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.max = valueDes;
          break;
        case r'min':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.min = valueDes;
          break;
        case r'start_ts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startTs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ParticipantCountByMinuteResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParticipantCountByMinuteResponseBuilder();
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
