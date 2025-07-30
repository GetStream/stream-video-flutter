//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_duration_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_aggregate_call_duration_report_response.g.dart';

/// DailyAggregateCallDurationReportResponse
///
/// Properties:
/// * [date]
/// * [report]
@BuiltValue()
abstract class DailyAggregateCallDurationReportResponse
    implements
        Built<DailyAggregateCallDurationReportResponse,
            DailyAggregateCallDurationReportResponseBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'report')
  CallDurationReport get report;

  DailyAggregateCallDurationReportResponse._();

  factory DailyAggregateCallDurationReportResponse(
          [void updates(DailyAggregateCallDurationReportResponseBuilder b)]) =
      _$DailyAggregateCallDurationReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyAggregateCallDurationReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyAggregateCallDurationReportResponse> get serializer =>
      _$DailyAggregateCallDurationReportResponseSerializer();
}

class _$DailyAggregateCallDurationReportResponseSerializer
    implements PrimitiveSerializer<DailyAggregateCallDurationReportResponse> {
  @override
  final Iterable<Type> types = const [
    DailyAggregateCallDurationReportResponse,
    _$DailyAggregateCallDurationReportResponse
  ];

  @override
  final String wireName = r'DailyAggregateCallDurationReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyAggregateCallDurationReportResponse object, {
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
      specifiedType: const FullType(CallDurationReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyAggregateCallDurationReportResponse object, {
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
    required DailyAggregateCallDurationReportResponseBuilder result,
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
            specifiedType: const FullType(CallDurationReport),
          ) as CallDurationReport;
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
  DailyAggregateCallDurationReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyAggregateCallDurationReportResponseBuilder();
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
