//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/calls_per_day_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_aggregate_calls_per_day_report_response.g.dart';

/// DailyAggregateCallsPerDayReportResponse
///
/// Properties:
/// * [date]
/// * [report]
@BuiltValue()
abstract class DailyAggregateCallsPerDayReportResponse
    implements
        Built<DailyAggregateCallsPerDayReportResponse,
            DailyAggregateCallsPerDayReportResponseBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'report')
  CallsPerDayReport get report;

  DailyAggregateCallsPerDayReportResponse._();

  factory DailyAggregateCallsPerDayReportResponse(
          [void updates(DailyAggregateCallsPerDayReportResponseBuilder b)]) =
      _$DailyAggregateCallsPerDayReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyAggregateCallsPerDayReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyAggregateCallsPerDayReportResponse> get serializer =>
      _$DailyAggregateCallsPerDayReportResponseSerializer();
}

class _$DailyAggregateCallsPerDayReportResponseSerializer
    implements PrimitiveSerializer<DailyAggregateCallsPerDayReportResponse> {
  @override
  final Iterable<Type> types = const [
    DailyAggregateCallsPerDayReportResponse,
    _$DailyAggregateCallsPerDayReportResponse
  ];

  @override
  final String wireName = r'DailyAggregateCallsPerDayReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyAggregateCallsPerDayReportResponse object, {
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
      specifiedType: const FullType(CallsPerDayReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyAggregateCallsPerDayReportResponse object, {
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
    required DailyAggregateCallsPerDayReportResponseBuilder result,
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
            specifiedType: const FullType(CallsPerDayReport),
          ) as CallsPerDayReport;
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
  DailyAggregateCallsPerDayReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyAggregateCallsPerDayReportResponseBuilder();
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
