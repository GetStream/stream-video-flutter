// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCallResponse _$DeleteCallResponseFromJson(Map<String, dynamic> json) =>
    DeleteCallResponse(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      duration: json['duration'] as String,
      taskId: json['task_id'] as String?,
    );

Map<String, dynamic> _$DeleteCallResponseToJson(DeleteCallResponse instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'duration': instance.duration,
      'task_id': instance.taskId,
    };
