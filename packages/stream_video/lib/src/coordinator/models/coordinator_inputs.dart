import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../call_permission.dart';
import '../../models/call_cid.dart';

@immutable
abstract class CoordinatorInput with EquatableMixin {
  const CoordinatorInput();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => const [];
}

class CreateDeviceInput extends CoordinatorInput {
  const CreateDeviceInput({
    required this.pushToken,
    required this.pushProviderId,
  });

  final String pushToken;
  final String pushProviderId;

  @override
  List<Object?> get props => [pushProviderId, pushToken];
}

class DeleteDeviceInput extends CoordinatorInput {
  const DeleteDeviceInput({
    required this.pushToken,
  });

  final String pushToken;

  @override
  List<Object?> get props => [pushToken];
}

class CreateCallInput extends CoordinatorInput {
  const CreateCallInput({
    required this.callCid,
    this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final Iterable<MemberInput>? members;
  final bool? ringing;

  @override
  List<Object?> get props => [callCid, ringing, members];
}

class GetOrCreateCallInput extends CoordinatorInput {
  const GetOrCreateCallInput({
    required this.callCid,
    this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final Iterable<MemberInput>? members;
  final bool? ringing;

  @override
  List<Object?> get props => [callCid, ringing, members];
}

class JoinCallInput extends CoordinatorInput {
  const JoinCallInput({
    required this.callCid,
    this.datacenterId,
    this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final String? datacenterId;
  final Iterable<MemberInput>? members;
  final bool? ringing;

  @override
  List<Object?> get props => [datacenterId, callCid, ringing, members];
}

class RequestPermissionsInput extends CoordinatorInput {
  const RequestPermissionsInput({
    required this.callCid,
    required this.permissions,
  });

  final StreamCallCid callCid;
  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [callCid, permissions];
}

class UpdateUserPermissionsInput extends CoordinatorInput {
  const UpdateUserPermissionsInput({
    required this.callCid,
    required this.userId,
    required this.grantPermissions,
    required this.revokePermissions,
  });

  final StreamCallCid callCid;
  final String userId;
  final List<CallPermission> grantPermissions;
  final List<CallPermission> revokePermissions;

  @override
  List<Object?> get props => [
        callCid,
        userId,
        grantPermissions,
        revokePermissions,
      ];
}

class UpsertCallMembersInput extends CoordinatorInput {
  const UpsertCallMembersInput({
    required this.callCid,
    required this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final Iterable<MemberInput> members;
  final bool? ringing;

  @override
  List<Object?> get props => [callCid, ringing, members];
}

class MemberInput extends CoordinatorInput {
  const MemberInput({
    required this.userId,
    this.role,
    this.custom,
    this.userInput,
  });

  final String userId;
  final String? role;
  final String? custom;
  final UserInput? userInput;

  @override
  List<Object?> get props => [userId, role, userInput, custom];
}

class UserInput extends CoordinatorInput {
  const UserInput({
    required this.id,
    this.name,
    this.role,
    this.imageUrl,
    this.teams,
    this.custom = const {},
  });

  final String id;
  final String? name;
  final String? role;
  final String? imageUrl;
  final List<String>? teams;
  final Map<String, Object> custom;

  @override
  List<Object?> get props => [id, name, role, teams, imageUrl, custom];
}

class EventInput extends CoordinatorInput {
  const EventInput({
    required this.callCid,
    required this.eventType,
  });

  final StreamCallCid callCid;
  final EventTypeInput eventType;

  @override
  List<Object?> get props => [callCid, eventType];
}

class CustomEventInput extends CoordinatorInput {
  const CustomEventInput({
    required this.callCid,
    required this.eventType,
    this.custom = const {},
  });

  final StreamCallCid callCid;
  final String eventType;
  final Map<String, Object> custom;

  @override
  List<Object?> get props => [callCid, eventType, custom];
}

class ReactionInput extends CoordinatorInput {
  const ReactionInput({
    required this.callCid,
    required this.reactionType,
    this.emojiCode,
    this.custom = const {},
  });

  final StreamCallCid callCid;
  final String reactionType;
  final String? emojiCode;
  final Map<String, Object> custom;

  @override
  List<Object?> get props => [callCid, reactionType, emojiCode, custom];
}

class QueryUsersInput extends CoordinatorInput {
  const QueryUsersInput({
    required this.callCid,
    required this.mqJson,
    this.sorts,
    this.limit,
  });

  final StreamCallCid callCid;
  final Map<String, Object> mqJson;
  final List<SortInput>? sorts;
  final int? limit;

  @override
  List<Object?> get props => [callCid, mqJson, limit, sorts];
}

class SortInput extends CoordinatorInput {
  const SortInput({
    required this.field,
    required this.direction,
  });

  final String field;
  final DirectionInput direction;

  @override
  List<Object?> get props => [field, direction];
}

enum EventTypeInput {
  accepted('call.accepted'),
  rejected('call.rejected'),
  cancelled('call.cancelled');

  const EventTypeInput(this.alias);

  final String alias;

  @override
  String toString() => name;
}

enum DirectionInput {
  asc('direction.asc'),
  desc('direction.desc'),
  undefined('direction.undefined');

  const DirectionInput(this.alias);

  final String alias;

  @override
  String toString() => name;
}
