//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/report_by_histogram_bucket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quality_score_report.g.dart';

/// QualityScoreReport
///
/// Properties:
/// * [histogram]
@BuiltValue()
abstract class QualityScoreReport
    implements Built<QualityScoreReport, QualityScoreReportBuilder> {
  @BuiltValueField(wireName: r'histogram')
  BuiltList<ReportByHistogramBucket> get histogram;

  QualityScoreReport._();

  factory QualityScoreReport([void updates(QualityScoreReportBuilder b)]) =
      _$QualityScoreReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QualityScoreReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QualityScoreReport> get serializer =>
      _$QualityScoreReportSerializer();
}

class _$QualityScoreReportSerializer
    implements PrimitiveSerializer<QualityScoreReport> {
  @override
  final Iterable<Type> types = const [QualityScoreReport, _$QualityScoreReport];

  @override
  final String wireName = r'QualityScoreReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QualityScoreReport object, {
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
    QualityScoreReport object, {
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
    required QualityScoreReportBuilder result,
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
  QualityScoreReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QualityScoreReportBuilder();
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
