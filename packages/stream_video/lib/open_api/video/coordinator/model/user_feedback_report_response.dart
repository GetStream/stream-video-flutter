//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/daily_aggregate_user_feedback_report_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_feedback_report_response.g.dart';

/// UserFeedbackReportResponse
///
/// Properties:
/// * [daily]
@BuiltValue()
abstract class UserFeedbackReportResponse
    implements
        Built<UserFeedbackReportResponse, UserFeedbackReportResponseBuilder> {
  @BuiltValueField(wireName: r'daily')
  BuiltList<DailyAggregateUserFeedbackReportResponse> get daily;

  UserFeedbackReportResponse._();

  factory UserFeedbackReportResponse(
          [void updates(UserFeedbackReportResponseBuilder b)]) =
      _$UserFeedbackReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserFeedbackReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserFeedbackReportResponse> get serializer =>
      _$UserFeedbackReportResponseSerializer();
}

class _$UserFeedbackReportResponseSerializer
    implements PrimitiveSerializer<UserFeedbackReportResponse> {
  @override
  final Iterable<Type> types = const [
    UserFeedbackReportResponse,
    _$UserFeedbackReportResponse
  ];

  @override
  final String wireName = r'UserFeedbackReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserFeedbackReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(
          BuiltList, [FullType(DailyAggregateUserFeedbackReportResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserFeedbackReportResponse object, {
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
    required UserFeedbackReportResponseBuilder result,
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
                [FullType(DailyAggregateUserFeedbackReportResponse)]),
          ) as BuiltList<DailyAggregateUserFeedbackReportResponse>;
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
  UserFeedbackReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserFeedbackReportResponseBuilder();
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
