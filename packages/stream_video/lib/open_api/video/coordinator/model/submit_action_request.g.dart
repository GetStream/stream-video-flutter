// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_action_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitActionRequest _$SubmitActionRequestFromJson(
  Map<String, dynamic> json,
) => SubmitActionRequest(
  actionType: $enumDecode(
    _$SubmitActionRequestActionTypeEnumMap,
    json['action_type'],
    unknownValue: SubmitActionRequestActionType.unknown,
  ),
  appealId: json['appeal_id'] as String?,
  ban: json['ban'] == null
      ? null
      : BanActionRequestPayload.fromJson(json['ban'] as Map<String, dynamic>),
  block: json['block'] == null
      ? null
      : BlockActionRequestPayload.fromJson(
          json['block'] as Map<String, dynamic>,
        ),
  bypass: json['bypass'] == null
      ? null
      : BypassActionRequest.fromJson(json['bypass'] as Map<String, dynamic>),
  custom: json['custom'] == null
      ? null
      : CustomActionRequestPayload.fromJson(
          json['custom'] as Map<String, dynamic>,
        ),
  deleteActivity: json['delete_activity'] == null
      ? null
      : DeleteActivityRequestPayload.fromJson(
          json['delete_activity'] as Map<String, dynamic>,
        ),
  deleteComment: json['delete_comment'] == null
      ? null
      : DeleteCommentRequestPayload.fromJson(
          json['delete_comment'] as Map<String, dynamic>,
        ),
  deleteMessage: json['delete_message'] == null
      ? null
      : DeleteMessageRequestPayload.fromJson(
          json['delete_message'] as Map<String, dynamic>,
        ),
  deleteReaction: json['delete_reaction'] == null
      ? null
      : DeleteReactionRequestPayload.fromJson(
          json['delete_reaction'] as Map<String, dynamic>,
        ),
  deleteUser: json['delete_user'] == null
      ? null
      : DeleteUserRequestPayload.fromJson(
          json['delete_user'] as Map<String, dynamic>,
        ),
  escalate: json['escalate'] == null
      ? null
      : EscalatePayload.fromJson(json['escalate'] as Map<String, dynamic>),
  flag: json['flag'] == null
      ? null
      : FlagRequest.fromJson(json['flag'] as Map<String, dynamic>),
  itemId: json['item_id'] as String?,
  markReviewed: json['mark_reviewed'] == null
      ? null
      : MarkReviewedRequestPayload.fromJson(
          json['mark_reviewed'] as Map<String, dynamic>,
        ),
  rejectAppeal: json['reject_appeal'] == null
      ? null
      : RejectAppealRequestPayload.fromJson(
          json['reject_appeal'] as Map<String, dynamic>,
        ),
  restore: json['restore'] == null
      ? null
      : RestoreActionRequestPayload.fromJson(
          json['restore'] as Map<String, dynamic>,
        ),
  shadowBlock: json['shadow_block'] == null
      ? null
      : ShadowBlockActionRequestPayload.fromJson(
          json['shadow_block'] as Map<String, dynamic>,
        ),
  unban: json['unban'] == null
      ? null
      : UnbanActionRequestPayload.fromJson(
          json['unban'] as Map<String, dynamic>,
        ),
  unblock: json['unblock'] == null
      ? null
      : UnblockActionRequestPayload.fromJson(
          json['unblock'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SubmitActionRequestToJson(
  SubmitActionRequest instance,
) => <String, dynamic>{
  'action_type': _$SubmitActionRequestActionTypeEnumMap[instance.actionType]!,
  'appeal_id': instance.appealId,
  'ban': instance.ban,
  'block': instance.block,
  'bypass': instance.bypass,
  'custom': instance.custom,
  'delete_activity': instance.deleteActivity,
  'delete_comment': instance.deleteComment,
  'delete_message': instance.deleteMessage,
  'delete_reaction': instance.deleteReaction,
  'delete_user': instance.deleteUser,
  'escalate': instance.escalate,
  'flag': instance.flag,
  'item_id': instance.itemId,
  'mark_reviewed': instance.markReviewed,
  'reject_appeal': instance.rejectAppeal,
  'restore': instance.restore,
  'shadow_block': instance.shadowBlock,
  'unban': instance.unban,
  'unblock': instance.unblock,
};

const _$SubmitActionRequestActionTypeEnumMap = {
  SubmitActionRequestActionType.ban: 'ban',
  SubmitActionRequestActionType.block: 'block',
  SubmitActionRequestActionType.bypass: 'bypass',
  SubmitActionRequestActionType.custom: 'custom',
  SubmitActionRequestActionType.deEscalate: 'de_escalate',
  SubmitActionRequestActionType.deleteActivity: 'delete_activity',
  SubmitActionRequestActionType.deleteComment: 'delete_comment',
  SubmitActionRequestActionType.deleteMessage: 'delete_message',
  SubmitActionRequestActionType.deleteReaction: 'delete_reaction',
  SubmitActionRequestActionType.deleteUser: 'delete_user',
  SubmitActionRequestActionType.endCall: 'end_call',
  SubmitActionRequestActionType.escalate: 'escalate',
  SubmitActionRequestActionType.flag: 'flag',
  SubmitActionRequestActionType.kickUser: 'kick_user',
  SubmitActionRequestActionType.markReviewed: 'mark_reviewed',
  SubmitActionRequestActionType.rejectAppeal: 'reject_appeal',
  SubmitActionRequestActionType.restore: 'restore',
  SubmitActionRequestActionType.shadowBlock: 'shadow_block',
  SubmitActionRequestActionType.unban: 'unban',
  SubmitActionRequestActionType.unblock: 'unblock',
  SubmitActionRequestActionType.unmask: 'unmask',
  SubmitActionRequestActionType.unknown: '_unknown',
};
