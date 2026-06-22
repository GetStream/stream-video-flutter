// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCallReportResponse _$GetCallReportResponseFromJson(
  Map<String, dynamic> json,
) => GetCallReportResponse(
  chatActivity: json['chat_activity'] == null
      ? null
      : ChatActivityStatsResponse.fromJson(
          json['chat_activity'] as Map<String, dynamic>,
        ),
  duration: json['duration'] as String,
  report: ReportResponse.fromJson(json['report'] as Map<String, dynamic>),
  session: json['session'] == null
      ? null
      : CallSessionResponse.fromJson(json['session'] as Map<String, dynamic>),
  sessionId: json['session_id'] as String,
  videoReactions: (json['video_reactions'] as List<dynamic>?)
      ?.map((e) => VideoReactionsResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetCallReportResponseToJson(
  GetCallReportResponse instance,
) => <String, dynamic>{
  'chat_activity': instance.chatActivity,
  'duration': instance.duration,
  'report': instance.report,
  'session': instance.session,
  'session_id': instance.sessionId,
  'video_reactions': instance.videoReactions,
};
