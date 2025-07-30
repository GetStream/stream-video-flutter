//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/participant_report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_rating_report_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_response.g.dart';

/// ReportResponse
///
/// Properties:
/// * [call]
/// * [participants]
/// * [userRatings]
@BuiltValue()
abstract class ReportResponse
    implements Built<ReportResponse, ReportResponseBuilder> {
  @BuiltValueField(wireName: r'call')
  CallReportResponse get call;

  @BuiltValueField(wireName: r'participants')
  ParticipantReportResponse get participants;

  @BuiltValueField(wireName: r'user_ratings')
  UserRatingReportResponse get userRatings;

  ReportResponse._();

  factory ReportResponse([void updates(ReportResponseBuilder b)]) =
      _$ReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportResponse> get serializer =>
      _$ReportResponseSerializer();
}

class _$ReportResponseSerializer
    implements PrimitiveSerializer<ReportResponse> {
  @override
  final Iterable<Type> types = const [ReportResponse, _$ReportResponse];

  @override
  final String wireName = r'ReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallReportResponse),
    );
    yield r'participants';
    yield serializers.serialize(
      object.participants,
      specifiedType: const FullType(ParticipantReportResponse),
    );
    yield r'user_ratings';
    yield serializers.serialize(
      object.userRatings,
      specifiedType: const FullType(UserRatingReportResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReportResponse object, {
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
    required ReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallReportResponse),
          ) as CallReportResponse;
          result.call.replace(valueDes);
          break;
        case r'participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ParticipantReportResponse),
          ) as ParticipantReportResponse;
          result.participants.replace(valueDes);
          break;
        case r'user_ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserRatingReportResponse),
          ) as UserRatingReportResponse;
          result.userRatings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportResponseBuilder();
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
