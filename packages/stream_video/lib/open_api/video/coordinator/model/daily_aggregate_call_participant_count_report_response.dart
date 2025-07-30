//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_participant_count_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_aggregate_call_participant_count_report_response.g.dart';

/// DailyAggregateCallParticipantCountReportResponse
///
/// Properties:
/// * [date]
/// * [report]
@BuiltValue()
abstract class DailyAggregateCallParticipantCountReportResponse
    implements
        Built<DailyAggregateCallParticipantCountReportResponse,
            DailyAggregateCallParticipantCountReportResponseBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'report')
  CallParticipantCountReport get report;

  DailyAggregateCallParticipantCountReportResponse._();

  factory DailyAggregateCallParticipantCountReportResponse(
          [void updates(
              DailyAggregateCallParticipantCountReportResponseBuilder b)]) =
      _$DailyAggregateCallParticipantCountReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          DailyAggregateCallParticipantCountReportResponseBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyAggregateCallParticipantCountReportResponse>
      get serializer =>
          _$DailyAggregateCallParticipantCountReportResponseSerializer();
}

class _$DailyAggregateCallParticipantCountReportResponseSerializer
    implements
        PrimitiveSerializer<DailyAggregateCallParticipantCountReportResponse> {
  @override
  final Iterable<Type> types = const [
    DailyAggregateCallParticipantCountReportResponse,
    _$DailyAggregateCallParticipantCountReportResponse
  ];

  @override
  final String wireName = r'DailyAggregateCallParticipantCountReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyAggregateCallParticipantCountReportResponse object, {
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
      specifiedType: const FullType(CallParticipantCountReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyAggregateCallParticipantCountReportResponse object, {
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
    required DailyAggregateCallParticipantCountReportResponseBuilder result,
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
            specifiedType: const FullType(CallParticipantCountReport),
          ) as CallParticipantCountReport;
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
  DailyAggregateCallParticipantCountReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyAggregateCallParticipantCountReportResponseBuilder();
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
