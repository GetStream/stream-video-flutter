// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealItemResponse _$AppealItemResponseFromJson(Map<String, dynamic> json) =>
    AppealItemResponse(
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => ActionLogResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiTextSeverity: json['ai_text_severity'] as String?,
      appealReason: json['appeal_reason'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      channelCid: json['channel_cid'] as String?,
      configKey: json['config_key'] as String?,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      decisionReason: json['decision_reason'] as String?,
      entityContent: json['entity_content'] == null
          ? null
          : ModerationPayload.fromJson(
              json['entity_content'] as Map<String, dynamic>,
            ),
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
      flagLabels: (json['flag_labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      flagTypes: (json['flag_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      flags: (json['flags'] as List<dynamic>?)
          ?.map(
            (e) => ModerationFlagResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      id: json['id'] as String,
      moderationAction: json['moderation_action'] == null
          ? null
          : ActionLogResponse.fromJson(
              json['moderation_action'] as Map<String, dynamic>,
            ),
      originalModerationAction: json['original_moderation_action'] == null
          ? null
          : ActionLogResponse.fromJson(
              json['original_moderation_action'] as Map<String, dynamic>,
            ),
      recommendedAction: json['recommended_action'] as String?,
      reviewQueueItemId: json['review_queue_item_id'] as String?,
      severity: (json['severity'] as num?)?.toInt(),
      status: json['status'] as String,
      updatedAt: const EpochDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppealItemResponseToJson(AppealItemResponse instance) =>
    <String, dynamic>{
      'actions': instance.actions,
      'ai_text_severity': instance.aiTextSeverity,
      'appeal_reason': instance.appealReason,
      'attachments': instance.attachments,
      'channel_cid': instance.channelCid,
      'config_key': instance.configKey,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'decision_reason': instance.decisionReason,
      'entity_content': instance.entityContent,
      'entity_id': instance.entityId,
      'entity_type': instance.entityType,
      'flag_labels': instance.flagLabels,
      'flag_types': instance.flagTypes,
      'flags': instance.flags,
      'id': instance.id,
      'moderation_action': instance.moderationAction,
      'original_moderation_action': instance.originalModerationAction,
      'recommended_action': instance.recommendedAction,
      'review_queue_item_id': instance.reviewQueueItemId,
      'severity': instance.severity,
      'status': instance.status,
      'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
      'user': instance.user,
    };
