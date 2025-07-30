//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'count_by_minute_response.g.dart';

/// CountByMinuteResponse
///
/// Properties:
/// * [count]
/// * [startTs]
@BuiltValue()
abstract class CountByMinuteResponse
    implements Built<CountByMinuteResponse, CountByMinuteResponseBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'start_ts')
  DateTime get startTs;

  CountByMinuteResponse._();

  factory CountByMinuteResponse(
      [void updates(CountByMinuteResponseBuilder b)]) = _$CountByMinuteResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CountByMinuteResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CountByMinuteResponse> get serializer =>
      _$CountByMinuteResponseSerializer();
}

class _$CountByMinuteResponseSerializer
    implements PrimitiveSerializer<CountByMinuteResponse> {
  @override
  final Iterable<Type> types = const [
    CountByMinuteResponse,
    _$CountByMinuteResponse
  ];

  @override
  final String wireName = r'CountByMinuteResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CountByMinuteResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
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
    CountByMinuteResponse object, {
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
    required CountByMinuteResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
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
  CountByMinuteResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CountByMinuteResponseBuilder();
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
