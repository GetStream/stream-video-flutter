//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_feedback_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_aggregate_user_feedback_report_response.g.dart';

/// DailyAggregateUserFeedbackReportResponse
///
/// Properties:
/// * [date]
/// * [report]
@BuiltValue()
abstract class DailyAggregateUserFeedbackReportResponse
    implements
        Built<DailyAggregateUserFeedbackReportResponse,
            DailyAggregateUserFeedbackReportResponseBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'report')
  UserFeedbackReport get report;

  DailyAggregateUserFeedbackReportResponse._();

  factory DailyAggregateUserFeedbackReportResponse(
          [void updates(DailyAggregateUserFeedbackReportResponseBuilder b)]) =
      _$DailyAggregateUserFeedbackReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyAggregateUserFeedbackReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyAggregateUserFeedbackReportResponse> get serializer =>
      _$DailyAggregateUserFeedbackReportResponseSerializer();
}

class _$DailyAggregateUserFeedbackReportResponseSerializer
    implements PrimitiveSerializer<DailyAggregateUserFeedbackReportResponse> {
  @override
  final Iterable<Type> types = const [
    DailyAggregateUserFeedbackReportResponse,
    _$DailyAggregateUserFeedbackReportResponse
  ];

  @override
  final String wireName = r'DailyAggregateUserFeedbackReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyAggregateUserFeedbackReportResponse object, {
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
      specifiedType: const FullType(UserFeedbackReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyAggregateUserFeedbackReportResponse object, {
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
    required DailyAggregateUserFeedbackReportResponseBuilder result,
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
            specifiedType: const FullType(UserFeedbackReport),
          ) as UserFeedbackReport;
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
  DailyAggregateUserFeedbackReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyAggregateUserFeedbackReportResponseBuilder();
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
