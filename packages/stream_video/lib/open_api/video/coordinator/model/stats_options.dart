//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_options.g.dart';

/// StatsOptions
///
/// Properties:
/// * [enableRtcStats]
/// * [reportingIntervalMs]
@BuiltValue()
abstract class StatsOptions
    implements Built<StatsOptions, StatsOptionsBuilder> {
  @BuiltValueField(wireName: r'enable_rtc_stats')
  bool get enableRtcStats;

  @BuiltValueField(wireName: r'reporting_interval_ms')
  int get reportingIntervalMs;

  StatsOptions._();

  factory StatsOptions([void updates(StatsOptionsBuilder b)]) = _$StatsOptions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatsOptionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatsOptions> get serializer => _$StatsOptionsSerializer();
}

class _$StatsOptionsSerializer implements PrimitiveSerializer<StatsOptions> {
  @override
  final Iterable<Type> types = const [StatsOptions, _$StatsOptions];

  @override
  final String wireName = r'StatsOptions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatsOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enable_rtc_stats';
    yield serializers.serialize(
      object.enableRtcStats,
      specifiedType: const FullType(bool),
    );
    yield r'reporting_interval_ms';
    yield serializers.serialize(
      object.reportingIntervalMs,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatsOptions object, {
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
    required StatsOptionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enable_rtc_stats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enableRtcStats = valueDes;
          break;
        case r'reporting_interval_ms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reportingIntervalMs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatsOptions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatsOptionsBuilder();
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
