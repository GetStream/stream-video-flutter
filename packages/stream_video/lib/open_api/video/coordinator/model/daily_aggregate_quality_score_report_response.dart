//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/quality_score_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_aggregate_quality_score_report_response.g.dart';

/// DailyAggregateQualityScoreReportResponse
///
/// Properties:
/// * [date]
/// * [report]
@BuiltValue()
abstract class DailyAggregateQualityScoreReportResponse
    implements
        Built<DailyAggregateQualityScoreReportResponse,
            DailyAggregateQualityScoreReportResponseBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'report')
  QualityScoreReport get report;

  DailyAggregateQualityScoreReportResponse._();

  factory DailyAggregateQualityScoreReportResponse(
          [void updates(DailyAggregateQualityScoreReportResponseBuilder b)]) =
      _$DailyAggregateQualityScoreReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyAggregateQualityScoreReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyAggregateQualityScoreReportResponse> get serializer =>
      _$DailyAggregateQualityScoreReportResponseSerializer();
}

class _$DailyAggregateQualityScoreReportResponseSerializer
    implements PrimitiveSerializer<DailyAggregateQualityScoreReportResponse> {
  @override
  final Iterable<Type> types = const [
    DailyAggregateQualityScoreReportResponse,
    _$DailyAggregateQualityScoreReportResponse
  ];

  @override
  final String wireName = r'DailyAggregateQualityScoreReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyAggregateQualityScoreReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'report';
    yield serializers.serialize(
      object.report,
      specifiedType: const FullType(QualityScoreReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyAggregateQualityScoreReportResponse object, {
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
    required DailyAggregateQualityScoreReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QualityScoreReport),
          ) as QualityScoreReport;
          result.report.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DailyAggregateQualityScoreReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyAggregateQualityScoreReportResponseBuilder();
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
