//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_quality_score_report_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quality_score_report_response.g.dart';

/// QualityScoreReportResponse
///
/// Properties:
/// * [daily]
@BuiltValue()
abstract class QualityScoreReportResponse
    implements
        Built<QualityScoreReportResponse, QualityScoreReportResponseBuilder> {
  @BuiltValueField(wireName: r'daily')
  BuiltList<DailyAggregateQualityScoreReportResponse> get daily;

  QualityScoreReportResponse._();

  factory QualityScoreReportResponse(
          [void updates(QualityScoreReportResponseBuilder b)]) =
      _$QualityScoreReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QualityScoreReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QualityScoreReportResponse> get serializer =>
      _$QualityScoreReportResponseSerializer();
}

class _$QualityScoreReportResponseSerializer
    implements PrimitiveSerializer<QualityScoreReportResponse> {
  @override
  final Iterable<Type> types = const [
    QualityScoreReportResponse,
    _$QualityScoreReportResponse
  ];

  @override
  final String wireName = r'QualityScoreReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QualityScoreReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(
          BuiltList, [FullType(DailyAggregateQualityScoreReportResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QualityScoreReportResponse object, {
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
    required QualityScoreReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'daily':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(DailyAggregateQualityScoreReportResponse)]),
          ) as BuiltList<DailyAggregateQualityScoreReportResponse>;
          result.daily.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QualityScoreReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QualityScoreReportResponseBuilder();
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
