//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_calls_per_day_report_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calls_per_day_report_response.g.dart';

/// CallsPerDayReportResponse
///
/// Properties:
/// * [daily]
@BuiltValue()
abstract class CallsPerDayReportResponse
    implements
        Built<CallsPerDayReportResponse, CallsPerDayReportResponseBuilder> {
  @BuiltValueField(wireName: r'daily')
  BuiltList<DailyAggregateCallsPerDayReportResponse> get daily;

  CallsPerDayReportResponse._();

  factory CallsPerDayReportResponse(
          [void updates(CallsPerDayReportResponseBuilder b)]) =
      _$CallsPerDayReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallsPerDayReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallsPerDayReportResponse> get serializer =>
      _$CallsPerDayReportResponseSerializer();
}

class _$CallsPerDayReportResponseSerializer
    implements PrimitiveSerializer<CallsPerDayReportResponse> {
  @override
  final Iterable<Type> types = const [
    CallsPerDayReportResponse,
    _$CallsPerDayReportResponse
  ];

  @override
  final String wireName = r'CallsPerDayReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallsPerDayReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(
          BuiltList, [FullType(DailyAggregateCallsPerDayReportResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallsPerDayReportResponse object, {
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
    required CallsPerDayReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'daily':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(DailyAggregateCallsPerDayReportResponse)]),
          ) as BuiltList<DailyAggregateCallsPerDayReportResponse>;
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
  CallsPerDayReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallsPerDayReportResponseBuilder();
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
