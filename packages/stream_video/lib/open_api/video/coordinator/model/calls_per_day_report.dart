//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calls_per_day_report.g.dart';

/// CallsPerDayReport
///
/// Properties:
/// * [count]
@BuiltValue()
abstract class CallsPerDayReport
    implements Built<CallsPerDayReport, CallsPerDayReportBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  CallsPerDayReport._();

  factory CallsPerDayReport([void updates(CallsPerDayReportBuilder b)]) =
      _$CallsPerDayReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallsPerDayReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallsPerDayReport> get serializer =>
      _$CallsPerDayReportSerializer();
}

class _$CallsPerDayReportSerializer
    implements PrimitiveSerializer<CallsPerDayReport> {
  @override
  final Iterable<Type> types = const [CallsPerDayReport, _$CallsPerDayReport];

  @override
  final String wireName = r'CallsPerDayReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallsPerDayReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallsPerDayReport object, {
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
    required CallsPerDayReportBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallsPerDayReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallsPerDayReportBuilder();
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
