//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_call_participant_count_report_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_participant_count_report_response.g.dart';

/// CallParticipantCountReportResponse
///
/// Properties:
/// * [daily]
@BuiltValue()
abstract class CallParticipantCountReportResponse
    implements
        Built<CallParticipantCountReportResponse,
            CallParticipantCountReportResponseBuilder> {
  @BuiltValueField(wireName: r'daily')
  BuiltList<DailyAggregateCallParticipantCountReportResponse> get daily;

  CallParticipantCountReportResponse._();

  factory CallParticipantCountReportResponse(
          [void updates(CallParticipantCountReportResponseBuilder b)]) =
      _$CallParticipantCountReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallParticipantCountReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallParticipantCountReportResponse> get serializer =>
      _$CallParticipantCountReportResponseSerializer();
}

class _$CallParticipantCountReportResponseSerializer
    implements PrimitiveSerializer<CallParticipantCountReportResponse> {
  @override
  final Iterable<Type> types = const [
    CallParticipantCountReportResponse,
    _$CallParticipantCountReportResponse
  ];

  @override
  final String wireName = r'CallParticipantCountReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallParticipantCountReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(BuiltList,
          [FullType(DailyAggregateCallParticipantCountReportResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallParticipantCountReportResponse object, {
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
    required CallParticipantCountReportResponseBuilder result,
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
                [FullType(DailyAggregateCallParticipantCountReportResponse)]),
          ) as BuiltList<DailyAggregateCallParticipantCountReportResponse>;
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
  CallParticipantCountReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallParticipantCountReportResponseBuilder();
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
