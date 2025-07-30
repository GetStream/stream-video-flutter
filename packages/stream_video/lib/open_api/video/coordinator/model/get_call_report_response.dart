//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/report_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/chat_activity_stats_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/video_reactions_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_call_report_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [chatActivity]
/// * [duration] - Duration of the request in milliseconds
/// * [report]
/// * [sessionId]
/// * [videoReactions]
@BuiltValue()
abstract class GetCallReportResponse
    implements Built<GetCallReportResponse, GetCallReportResponseBuilder> {
  @BuiltValueField(wireName: r'chat_activity')
  ChatActivityStatsResponse? get chatActivity;

  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'report')
  ReportResponse get report;

  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  @BuiltValueField(wireName: r'video_reactions')
  BuiltList<VideoReactionsResponse?>? get videoReactions;

  GetCallReportResponse._();

  factory GetCallReportResponse(
      [void updates(GetCallReportResponseBuilder b)]) = _$GetCallReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCallReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCallReportResponse> get serializer =>
      _$GetCallReportResponseSerializer();
}

class _$GetCallReportResponseSerializer
    implements PrimitiveSerializer<GetCallReportResponse> {
  @override
  final Iterable<Type> types = const [
    GetCallReportResponse,
    _$GetCallReportResponse
  ];

  @override
  final String wireName = r'GetCallReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCallReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.chatActivity != null) {
      yield r'chat_activity';
      yield serializers.serialize(
        object.chatActivity,
        specifiedType: const FullType(ChatActivityStatsResponse),
      );
    }
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'report';
    yield serializers.serialize(
      object.report,
      specifiedType: const FullType(ReportResponse),
    );
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    if (object.videoReactions != null) {
      yield r'video_reactions';
      yield serializers.serialize(
        object.videoReactions,
        specifiedType: const FullType(
            BuiltList, [FullType.nullable(VideoReactionsResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCallReportResponse object, {
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
    required GetCallReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'chat_activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatActivityStatsResponse),
          ) as ChatActivityStatsResponse;
          result.chatActivity.replace(valueDes);
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReportResponse),
          ) as ReportResponse;
          result.report.replace(valueDes);
          break;
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        case r'video_reactions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(VideoReactionsResponse)]),
          ) as BuiltList<VideoReactionsResponse?>;
          result.videoReactions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCallReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCallReportResponseBuilder();
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
