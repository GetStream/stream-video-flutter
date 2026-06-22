// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_action_appeals_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkActionAppealsRequest _$BulkActionAppealsRequestFromJson(
  Map<String, dynamic> json,
) => BulkActionAppealsRequest(
  actionType: $enumDecode(
    _$BulkActionAppealsRequestActionTypeEnumMap,
    json['action_type'],
    unknownValue: BulkActionAppealsRequestActionType.unknown,
  ),
  appealIds: (json['appeal_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
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

Map<String, dynamic> _$BulkActionAppealsRequestToJson(
  BulkActionAppealsRequest instance,
) => <String, dynamic>{
  'action_type':
      _$BulkActionAppealsRequestActionTypeEnumMap[instance.actionType]!,
  'appeal_ids': instance.appealIds,
  'mark_reviewed': instance.markReviewed,
  'reject_appeal': instance.rejectAppeal,
  'restore': instance.restore,
  'unban': instance.unban,
  'unblock': instance.unblock,
};

const _$BulkActionAppealsRequestActionTypeEnumMap = {
  BulkActionAppealsRequestActionType.markReviewed: 'mark_reviewed',
  BulkActionAppealsRequestActionType.rejectAppeal: 'reject_appeal',
  BulkActionAppealsRequestActionType.restore: 'restore',
  BulkActionAppealsRequestActionType.unban: 'unban',
  BulkActionAppealsRequestActionType.unblock: 'unblock',
  BulkActionAppealsRequestActionType.unknown: '_unknown',
};
