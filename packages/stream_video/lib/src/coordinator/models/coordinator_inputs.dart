import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  final List<String> permissions;

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
  final List<String> grantPermissions;
  final List<String> revokePermissions;

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
    this.customJson,
    this.userInput,
  });

  final String userId;
  final String? role;
  final String? customJson;
  final UserInput? userInput;

  @override
  List<Object?> get props => [userId, role, userInput, customJson];
}

class UserInput extends CoordinatorInput {
  const UserInput({
    required this.id,
    this.name,
    this.role,
    this.imageUrl,
    this.teams,
    this.customJson,
  });

  final String id;
  final String? name;
  final String? role;
  final String? imageUrl;
  final List<String>? teams;
  final Map<String, dynamic>? customJson;

  @override
  List<Object?> get props => [id, name, role, teams, imageUrl, customJson];
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
    required this.dataJson,
  });

  final StreamCallCid callCid;
  final String eventType;
  final Map<String, Object> dataJson;

  @override
  List<Object?> get props => [callCid, eventType, dataJson];
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
  accepted,
  rejected,
  cancelled;

  @override
  String toString() {
    return name;
  }

  String get alias {
    switch (this) {
      case EventTypeInput.accepted:
        return 'call.accepted';
      case EventTypeInput.rejected:
        return 'call.rejected';
      case EventTypeInput.cancelled:
        return 'call.cancelled';
    }
  }
}

enum DirectionInput {
  asc,
  desc,
  undefined;

  @override
  String toString() {
    return name;
  }

  String get alias {
    switch (this) {
      case DirectionInput.asc:
        return 'direction.asc';
      case DirectionInput.desc:
        return 'direction.desc';
      case DirectionInput.undefined:
        return 'direction.undefined';
    }
  }
}
