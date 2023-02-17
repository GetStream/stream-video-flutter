import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/call_cid.dart';

@immutable
abstract class CoordinatorInputV2 with EquatableMixin {
  const CoordinatorInputV2();

  @override
  List<Object?> get props => const [];
}

class CreateDeviceInput extends CoordinatorInputV2 {
  const CreateDeviceInput({
    required this.pushToken,
    required this.pushProviderId,
  });

  final String pushToken;
  final String pushProviderId;
}

class DeleteDeviceInput extends CoordinatorInputV2 {
  const DeleteDeviceInput({
    required this.pushToken,
  });

  final String pushToken;
}

class CreateCallInput extends CoordinatorInputV2 {
  const CreateCallInput({
    required this.callCid,
    this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final Iterable<MemberInput>? members;
  final bool? ringing;
}

class GetOrCreateCallInput {
  const GetOrCreateCallInput({
    required this.callCid,
    this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final Iterable<MemberInput>? members;
  final bool? ringing;
}

class JoinCallInput {
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
}

class UpsertCallMembersInput {
  const UpsertCallMembersInput({
    required this.callCid,
    required this.members,
    this.ringing,
  });

  final StreamCallCid callCid;
  final Iterable<MemberInput> members;
  final bool? ringing;
}

class MemberInput extends CoordinatorInputV2 {
  const MemberInput({
    this.userId,
    this.role,
    this.customJson,
    this.userInput,
  });

  final String? userId;
  final String? role;
  final String? customJson;
  final UserInput? userInput;
}

class UserInput extends CoordinatorInputV2 {
  const UserInput({
    this.id,
    this.name,
    this.role,
    this.imageUrl,
    this.teams,
    this.customJson,
  });

  final String? id;
  final String? name;
  final String? role;
  final String? imageUrl;
  final List<String>? teams;
  final Map<String, dynamic>? customJson;
}

class EventInput extends CoordinatorInputV2 {
  const EventInput({
    required this.callCid,
    required this.eventType,
  });

  final StreamCallCid callCid;
  final EventTypeInput eventType;
}

class CustomEventInput extends CoordinatorInputV2 {
  const CustomEventInput({
    required this.callCid,
    required this.eventType,
    required this.dataJson,
  });

  final StreamCallCid callCid;
  final String eventType;
  final Map<String, dynamic> dataJson;
}

class QueryUsersInput extends CoordinatorInputV2 {
  const QueryUsersInput({
    required this.mqJson,
    this.sorts,
    this.limit,
  });

  final Map<String, dynamic> mqJson;
  final List<SortInput>? sorts;
  final int? limit;
}

class SortInput extends CoordinatorInputV2 {
  const SortInput({
    required this.field,
    required this.direction,
  });

  final String field;
  final DirectionInput direction;
}

enum EventTypeInput {
  accepted,
  rejected,
  cancelled,
}

enum DirectionInput {
  asc,
  desc,
  undefined,
}
