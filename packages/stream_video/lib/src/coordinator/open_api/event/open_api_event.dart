import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import 'event_type.dart';
import 'health_check.dart';

class OpenApiEvent with EquatableMixin {
  const OpenApiEvent({
    required this.type,
    this.healthCheck,
    this.callCreated,
    this.callAccepted,
    this.callRejected,
    this.callCancelled,
    this.callUpdated,
    this.callEnded,
    this.callPermissionRequest,
    this.callPermissionsUpdated,
    this.callUserBlocked,
    this.callUserUnblocked,
    this.callRecordingStarted,
    this.callRecordingStopped,
    this.custom,
  });

  factory OpenApiEvent.fromRawJson(String rawJson) {
    return OpenApiEvent.fromJson(json.decode(rawJson));
  }

  factory OpenApiEvent.fromJson(dynamic obj) {
    final type = EventType.fromAlias(obj['type']);
    final result = OpenApiEvent(type: type);

    switch (type) {
      case EventType.healthCheck:
        final healthCheck = HealthCheck.fromJson(obj);
        return result.copyWith(healthCheck: healthCheck);
      case EventType.callCreated:
        final callCreated = open.CallCreatedEvent.fromJson(obj);
        return result.copyWith(callCreated: callCreated);
      case EventType.callAccepted:
        final callAccepted = open.CallAcceptedEvent.fromJson(obj);
        return result.copyWith(callAccepted: callAccepted);
      case EventType.callRejected:
        final callRejected = open.CallRejectedEvent.fromJson(obj);
        return result.copyWith(callRejected: callRejected);
      case EventType.callCancelled:
        final callCancelled = open.CallCancelledEvent.fromJson(obj);
        return result.copyWith(callCancelled: callCancelled);
      case EventType.callUpdated:
        final callUpdated = open.CallUpdatedEvent.fromJson(obj);
        return result.copyWith(callUpdated: callUpdated);
      case EventType.callEnded:
        final callEnded = open.CallEndedEvent.fromJson(obj);
        return result.copyWith(callEnded: callEnded);
      case EventType.callPermissionRequest:
        final callPermissionRequest = open.PermissionRequestEvent.fromJson(obj);
        return result.copyWith(callPermissionRequest: callPermissionRequest);
      case EventType.callPermissionsUpdated:
        final permissionsUpdated = open.UpdatedCallPermissionsEvent.fromJson(
          obj,
        );
        return result.copyWith(callPermissionsUpdated: permissionsUpdated);
      case EventType.callUserBlocked:
        final userBlocked = open.BlockedUserEvent.fromJson(obj);
        return result.copyWith(callUserBlocked: userBlocked);
      case EventType.callUserUnblocked:
        final userUnblocked = open.UnblockedUserEvent.fromJson(obj);
        return result.copyWith(callUserUnblocked: userUnblocked);
      case EventType.callRecordingStarted:
        final recordingStarted = open.CallRecordingStartedEvent.fromJson(obj);
        return result.copyWith(callRecordingStarted: recordingStarted);
      case EventType.callRecordingStopped:
        final recordingStopped = open.CallRecordingStoppedEvent.fromJson(obj);
        return result.copyWith(callRecordingStopped: recordingStopped);
      case EventType.custom:
        final custom = open.CustomVideoEvent.fromJson(obj);
        return result.copyWith(custom: custom);
      case EventType.unknown:
        return result;
    }
  }

  final EventType type;
  final HealthCheck? healthCheck;
  final open.CallCreatedEvent? callCreated;
  final open.CallAcceptedEvent? callAccepted;
  final open.CallRejectedEvent? callRejected;
  final open.CallCancelledEvent? callCancelled;
  final open.CallUpdatedEvent? callUpdated;
  final open.CallEndedEvent? callEnded;
  final open.PermissionRequestEvent? callPermissionRequest;
  final open.UpdatedCallPermissionsEvent? callPermissionsUpdated;
  final open.BlockedUserEvent? callUserBlocked;
  final open.UnblockedUserEvent? callUserUnblocked;
  final open.CallRecordingStartedEvent? callRecordingStarted;
  final open.CallRecordingStoppedEvent? callRecordingStopped;
  final open.CustomVideoEvent? custom;

  OpenApiEvent copyWith({
    EventType? type,
    HealthCheck? healthCheck,
    open.CallCreatedEvent? callCreated,
    open.CallAcceptedEvent? callAccepted,
    open.CallRejectedEvent? callRejected,
    open.CallCancelledEvent? callCancelled,
    open.CallUpdatedEvent? callUpdated,
    open.CallEndedEvent? callEnded,
    open.PermissionRequestEvent? callPermissionRequest,
    open.UpdatedCallPermissionsEvent? callPermissionsUpdated,
    open.BlockedUserEvent? callUserBlocked,
    open.UnblockedUserEvent? callUserUnblocked,
    open.CallRecordingStartedEvent? callRecordingStarted,
    open.CallRecordingStoppedEvent? callRecordingStopped,
    open.CustomVideoEvent? custom,
  }) {
    return OpenApiEvent(
      type: type ?? this.type,
      healthCheck: healthCheck ?? this.healthCheck,
      callCreated: callCreated ?? this.callCreated,
      callAccepted: callAccepted ?? this.callAccepted,
      callRejected: callRejected ?? this.callRejected,
      callCancelled: callCancelled ?? this.callCancelled,
      callUpdated: callUpdated ?? this.callUpdated,
      callEnded: callEnded ?? this.callEnded,
      callPermissionRequest:
          callPermissionRequest ?? this.callPermissionRequest,
      callPermissionsUpdated:
          callPermissionsUpdated ?? this.callPermissionsUpdated,
      callUserBlocked: callUserBlocked ?? this.callUserBlocked,
      callUserUnblocked: callUserUnblocked ?? this.callUserUnblocked,
      callRecordingStarted: callRecordingStarted ?? this.callRecordingStarted,
      callRecordingStopped: callRecordingStopped ?? this.callRecordingStopped,
      custom: custom ?? this.custom,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        type,
        healthCheck,
        callCreated,
        callAccepted,
        callRejected,
        callCancelled,
        callUpdated,
        callEnded,
        callPermissionRequest,
        callPermissionsUpdated,
        callRecordingStarted,
        callUserBlocked,
        callUserUnblocked,
        callRecordingStopped,
        custom,
      ];
}
