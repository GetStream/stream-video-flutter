//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_stats_report_summary_response.g.dart';

/// CallStatsReportSummaryResponse
///
/// Properties:
/// * [callCid]
/// * [callDurationSeconds]
/// * [callSessionId]
/// * [callStatus]
/// * [createdAt]
/// * [firstStatsTime]
/// * [minUserRating]
/// * [qualityScore]
@BuiltValue()
abstract class CallStatsReportSummaryResponse
    implements
        Built<CallStatsReportSummaryResponse,
            CallStatsReportSummaryResponseBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'call_duration_seconds')
  int get callDurationSeconds;

  @BuiltValueField(wireName: r'call_session_id')
  String get callSessionId;

  @BuiltValueField(wireName: r'call_status')
  String get callStatus;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'first_stats_time')
  DateTime get firstStatsTime;

  @BuiltValueField(wireName: r'min_user_rating')
  int? get minUserRating;

  @BuiltValueField(wireName: r'quality_score')
  int? get qualityScore;

  CallStatsReportSummaryResponse._();

  factory CallStatsReportSummaryResponse(
          [void updates(CallStatsReportSummaryResponseBuilder b)]) =
      _$CallStatsReportSummaryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallStatsReportSummaryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallStatsReportSummaryResponse> get serializer =>
      _$CallStatsReportSummaryResponseSerializer();
}

class _$CallStatsReportSummaryResponseSerializer
    implements PrimitiveSerializer<CallStatsReportSummaryResponse> {
  @override
  final Iterable<Type> types = const [
    CallStatsReportSummaryResponse,
    _$CallStatsReportSummaryResponse
  ];

  @override
  final String wireName = r'CallStatsReportSummaryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallStatsReportSummaryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'call_duration_seconds';
    yield serializers.serialize(
      object.callDurationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'call_session_id';
    yield serializers.serialize(
      object.callSessionId,
      specifiedType: const FullType(String),
    );
    yield r'call_status';
    yield serializers.serialize(
      object.callStatus,
      specifiedType: const FullType(String),
    );
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'first_stats_time';
    yield serializers.serialize(
      object.firstStatsTime,
      specifiedType: const FullType(DateTime),
    );
    if (object.minUserRating != null) {
      yield r'min_user_rating';
      yield serializers.serialize(
        object.minUserRating,
        specifiedType: const FullType(int),
      );
    }
    if (object.qualityScore != null) {
      yield r'quality_score';
      yield serializers.serialize(
        object.qualityScore,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CallStatsReportSummaryResponse object, {
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
    required CallStatsReportSummaryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callCid = valueDes;
          break;
        case r'call_duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.callDurationSeconds = valueDes;
          break;
        case r'call_session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callSessionId = valueDes;
          break;
        case r'call_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callStatus = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'first_stats_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.firstStatsTime = valueDes;
          break;
        case r'min_user_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minUserRating = valueDes;
          break;
        case r'quality_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.qualityScore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallStatsReportSummaryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallStatsReportSummaryResponseBuilder();
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
