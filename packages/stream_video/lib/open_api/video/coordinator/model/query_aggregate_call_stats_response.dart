//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/quality_score_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_participant_count_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_duration_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/calls_per_day_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/network_metrics_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/sdk_usage_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_feedback_report_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_aggregate_call_stats_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [callDurationReport]
/// * [callParticipantCountReport]
/// * [callsPerDayReport]
/// * [duration] - Duration of the request in milliseconds
/// * [networkMetricsReport]
/// * [qualityScoreReport]
/// * [sdkUsageReport]
/// * [userFeedbackReport]
@BuiltValue()
abstract class QueryAggregateCallStatsResponse
    implements
        Built<QueryAggregateCallStatsResponse,
            QueryAggregateCallStatsResponseBuilder> {
  @BuiltValueField(wireName: r'call_duration_report')
  CallDurationReportResponse? get callDurationReport;

  @BuiltValueField(wireName: r'call_participant_count_report')
  CallParticipantCountReportResponse? get callParticipantCountReport;

  @BuiltValueField(wireName: r'calls_per_day_report')
  CallsPerDayReportResponse? get callsPerDayReport;

  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'network_metrics_report')
  NetworkMetricsReportResponse? get networkMetricsReport;

  @BuiltValueField(wireName: r'quality_score_report')
  QualityScoreReportResponse? get qualityScoreReport;

  @BuiltValueField(wireName: r'sdk_usage_report')
  SDKUsageReportResponse? get sdkUsageReport;

  @BuiltValueField(wireName: r'user_feedback_report')
  UserFeedbackReportResponse? get userFeedbackReport;

  QueryAggregateCallStatsResponse._();

  factory QueryAggregateCallStatsResponse(
          [void updates(QueryAggregateCallStatsResponseBuilder b)]) =
      _$QueryAggregateCallStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryAggregateCallStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryAggregateCallStatsResponse> get serializer =>
      _$QueryAggregateCallStatsResponseSerializer();
}

class _$QueryAggregateCallStatsResponseSerializer
    implements PrimitiveSerializer<QueryAggregateCallStatsResponse> {
  @override
  final Iterable<Type> types = const [
    QueryAggregateCallStatsResponse,
    _$QueryAggregateCallStatsResponse
  ];

  @override
  final String wireName = r'QueryAggregateCallStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryAggregateCallStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.callDurationReport != null) {
      yield r'call_duration_report';
      yield serializers.serialize(
        object.callDurationReport,
        specifiedType: const FullType(CallDurationReportResponse),
      );
    }
    if (object.callParticipantCountReport != null) {
      yield r'call_participant_count_report';
      yield serializers.serialize(
        object.callParticipantCountReport,
        specifiedType: const FullType(CallParticipantCountReportResponse),
      );
    }
    if (object.callsPerDayReport != null) {
      yield r'calls_per_day_report';
      yield serializers.serialize(
        object.callsPerDayReport,
        specifiedType: const FullType(CallsPerDayReportResponse),
      );
    }
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    if (object.networkMetricsReport != null) {
      yield r'network_metrics_report';
      yield serializers.serialize(
        object.networkMetricsReport,
        specifiedType: const FullType(NetworkMetricsReportResponse),
      );
    }
    if (object.qualityScoreReport != null) {
      yield r'quality_score_report';
      yield serializers.serialize(
        object.qualityScoreReport,
        specifiedType: const FullType(QualityScoreReportResponse),
      );
    }
    if (object.sdkUsageReport != null) {
      yield r'sdk_usage_report';
      yield serializers.serialize(
        object.sdkUsageReport,
        specifiedType: const FullType(SDKUsageReportResponse),
      );
    }
    if (object.userFeedbackReport != null) {
      yield r'user_feedback_report';
      yield serializers.serialize(
        object.userFeedbackReport,
        specifiedType: const FullType(UserFeedbackReportResponse),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryAggregateCallStatsResponse object, {
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
    required QueryAggregateCallStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call_duration_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallDurationReportResponse),
          ) as CallDurationReportResponse;
          result.callDurationReport.replace(valueDes);
          break;
        case r'call_participant_count_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallParticipantCountReportResponse),
          ) as CallParticipantCountReportResponse;
          result.callParticipantCountReport.replace(valueDes);
          break;
        case r'calls_per_day_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallsPerDayReportResponse),
          ) as CallsPerDayReportResponse;
          result.callsPerDayReport.replace(valueDes);
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'network_metrics_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NetworkMetricsReportResponse),
          ) as NetworkMetricsReportResponse;
          result.networkMetricsReport.replace(valueDes);
          break;
        case r'quality_score_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QualityScoreReportResponse),
          ) as QualityScoreReportResponse;
          result.qualityScoreReport.replace(valueDes);
          break;
        case r'sdk_usage_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SDKUsageReportResponse),
          ) as SDKUsageReportResponse;
          result.sdkUsageReport.replace(valueDes);
          break;
        case r'user_feedback_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserFeedbackReportResponse),
          ) as UserFeedbackReportResponse;
          result.userFeedbackReport.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryAggregateCallStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryAggregateCallStatsResponseBuilder();
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
