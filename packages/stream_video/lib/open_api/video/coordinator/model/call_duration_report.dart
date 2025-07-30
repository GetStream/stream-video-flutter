//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/report_by_histogram_bucket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_duration_report.g.dart';

/// CallDurationReport
///
/// Properties:
/// * [histogram]
@BuiltValue()
abstract class CallDurationReport
    implements Built<CallDurationReport, CallDurationReportBuilder> {
  @BuiltValueField(wireName: r'histogram')
  BuiltList<ReportByHistogramBucket> get histogram;

  CallDurationReport._();

  factory CallDurationReport([void updates(CallDurationReportBuilder b)]) =
      _$CallDurationReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallDurationReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallDurationReport> get serializer =>
      _$CallDurationReportSerializer();
}

class _$CallDurationReportSerializer
    implements PrimitiveSerializer<CallDurationReport> {
  @override
  final Iterable<Type> types = const [CallDurationReport, _$CallDurationReport];

  @override
  final String wireName = r'CallDurationReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallDurationReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'histogram';
    yield serializers.serialize(
      object.histogram,
      specifiedType:
          const FullType(BuiltList, [FullType(ReportByHistogramBucket)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallDurationReport object, {
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
    required CallDurationReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'histogram':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(ReportByHistogramBucket)]),
          ) as BuiltList<ReportByHistogramBucket>;
          result.histogram.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallDurationReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallDurationReportBuilder();
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
