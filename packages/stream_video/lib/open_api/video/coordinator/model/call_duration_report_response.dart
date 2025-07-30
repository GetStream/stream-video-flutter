//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_call_duration_report_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_duration_report_response.g.dart';

/// CallDurationReportResponse
///
/// Properties:
/// * [daily]
@BuiltValue()
abstract class CallDurationReportResponse
    implements
        Built<CallDurationReportResponse, CallDurationReportResponseBuilder> {
  @BuiltValueField(wireName: r'daily')
  BuiltList<DailyAggregateCallDurationReportResponse> get daily;

  CallDurationReportResponse._();

  factory CallDurationReportResponse(
          [void updates(CallDurationReportResponseBuilder b)]) =
      _$CallDurationReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallDurationReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallDurationReportResponse> get serializer =>
      _$CallDurationReportResponseSerializer();
}

class _$CallDurationReportResponseSerializer
    implements PrimitiveSerializer<CallDurationReportResponse> {
  @override
  final Iterable<Type> types = const [
    CallDurationReportResponse,
    _$CallDurationReportResponse
  ];

  @override
  final String wireName = r'CallDurationReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallDurationReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(
          BuiltList, [FullType(DailyAggregateCallDurationReportResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallDurationReportResponse object, {
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
    required CallDurationReportResponseBuilder result,
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
                [FullType(DailyAggregateCallDurationReportResponse)]),
          ) as BuiltList<DailyAggregateCallDurationReportResponse>;
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
  CallDurationReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallDurationReportResponseBuilder();
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
