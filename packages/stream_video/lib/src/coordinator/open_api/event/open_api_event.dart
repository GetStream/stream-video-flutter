import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../../logger/stream_log.dart';
import 'event_type.dart';
import 'health_check.dart';

const _tag = 'SV:OpenApiEvent';

class OpenApiEvent with EquatableMixin {
  const OpenApiEvent({
    required this.type,
    this.connected,
    this.healthCheck,
    this.callCreated,
    this.callAccepted,
    this.callRejected,
    this.callUpdated,
    this.callEnded,
    this.callPermissionRequest,
    this.callPermissionsUpdated,
    this.callUserBlocked,
    this.callUserUnblocked,
    this.callRecordingStarted,
    this.callRecordingStopped,
    this.callReaction,
    this.custom,
  });

  static OpenApiEvent? fromRawJson(String rawJson) {
    return OpenApiEvent.fromJson(json.decode(rawJson));
  }

  static OpenApiEvent? fromJson(dynamic jsonObj) {
    final rawType = jsonObj['type'];
    if (rawType == null) {
      return null;
    }
    final type = EventType.fromAlias(rawType);
    streamLog.i(_tag, () => '[fromJson] rawType; $rawType, type: $type');
    final result = OpenApiEvent(type: type);
    switch (type) {
      case EventType.connectionOk:
        final event = open.ConnectedEvent.fromJson(jsonObj);
        return result.copyWith(connected: event);
      case EventType.healthCheck:
        final event = open.HealthCheckEvent.fromJson(jsonObj);
        return result.copyWith(healthCheck: event);
      case EventType.callCreated:
        final event = open.CallCreatedEvent.fromJson(jsonObj);
        return result.copyWith(callCreated: event);
      case EventType.callAccepted:
        final event = open.CallAcceptedEvent.fromJson(jsonObj);
        return result.copyWith(callAccepted: event);
      case EventType.callRejected:
        final event = open.CallRejectedEvent.fromJson(jsonObj);
        return result.copyWith(callRejected: event);
      case EventType.callUpdated:
        final event = open.CallUpdatedEvent.fromJson(jsonObj);
        return result.copyWith(callUpdated: event);
      case EventType.callEnded:
        final event = open.CallEndedEvent.fromJson(jsonObj);
        return result.copyWith(callEnded: event);
      case EventType.callPermissionRequest:
        final event = open.PermissionRequestEvent.fromJson(jsonObj);
        return result.copyWith(callPermissionRequest: event);
      case EventType.callPermissionsUpdated:
        final event = open.UpdatedCallPermissionsEvent.fromJson(jsonObj);
        return result.copyWith(callPermissionsUpdated: event);
      case EventType.callUserBlocked:
        final event = open.BlockedUserEvent.fromJson(jsonObj);
        return result.copyWith(callUserBlocked: event);
      case EventType.callUserUnblocked:
        final event = open.UnblockedUserEvent.fromJson(jsonObj);
        return result.copyWith(callUserUnblocked: event);
      case EventType.callRecordingStarted:
        final event = open.CallRecordingStartedEvent.fromJson(jsonObj);
        return result.copyWith(callRecordingStarted: event);
      case EventType.callRecordingStopped:
        final event = open.CallRecordingStoppedEvent.fromJson(jsonObj);
        return result.copyWith(callRecordingStopped: event);
      case EventType.callReaction:
        final event = open.CallReactionEvent.fromJson(jsonObj);
        return result.copyWith(callReaction: event);
      case EventType.custom:
        /* no-op */
        break;
      case EventType.unknown:
        /* no-op */
        break;
    }
    try {
      final event = open.CustomVideoEvent.fromJson(jsonObj);
      return result.copyWith(type: EventType.custom, custom: event);
    } catch (e, stk) {
      streamLog.e(_tag, () => '[fromJson] failed: $e; $stk');
      return result.copyWith(type: EventType.unknown);
    }
  }

  final EventType type;
  final open.ConnectedEvent? connected;
  final open.HealthCheckEvent? healthCheck;
  final open.CallCreatedEvent? callCreated;
  final open.CallAcceptedEvent? callAccepted;
  final open.CallRejectedEvent? callRejected;
  final open.CallUpdatedEvent? callUpdated;
  final open.CallEndedEvent? callEnded;
  final open.PermissionRequestEvent? callPermissionRequest;
  final open.UpdatedCallPermissionsEvent? callPermissionsUpdated;
  final open.BlockedUserEvent? callUserBlocked;
  final open.UnblockedUserEvent? callUserUnblocked;
  final open.CallRecordingStartedEvent? callRecordingStarted;
  final open.CallRecordingStoppedEvent? callRecordingStopped;
  final open.CallReactionEvent? callReaction;
  final open.CustomVideoEvent? custom;

  OpenApiEvent copyWith({
    EventType? type,
    open.ConnectedEvent? connected,
    open.HealthCheckEvent? healthCheck,
    open.CallCreatedEvent? callCreated,
    open.CallAcceptedEvent? callAccepted,
    open.CallRejectedEvent? callRejected,
    open.CallUpdatedEvent? callUpdated,
    open.CallEndedEvent? callEnded,
    open.PermissionRequestEvent? callPermissionRequest,
    open.UpdatedCallPermissionsEvent? callPermissionsUpdated,
    open.BlockedUserEvent? callUserBlocked,
    open.UnblockedUserEvent? callUserUnblocked,
    open.CallRecordingStartedEvent? callRecordingStarted,
    open.CallRecordingStoppedEvent? callRecordingStopped,
    open.CallReactionEvent? callReaction,
    open.CustomVideoEvent? custom,
  }) {
    return OpenApiEvent(
      type: type ?? this.type,
      connected: connected ?? this.connected,
      healthCheck: healthCheck ?? this.healthCheck,
      callCreated: callCreated ?? this.callCreated,
      callAccepted: callAccepted ?? this.callAccepted,
      callRejected: callRejected ?? this.callRejected,
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
      callReaction: callReaction ?? this.callReaction,
      custom: custom ?? this.custom,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        type,
        connected,
        healthCheck,
        callCreated,
        callAccepted,
        callRejected,
        callUpdated,
        callEnded,
        callPermissionRequest,
        callPermissionsUpdated,
        callRecordingStarted,
        callUserBlocked,
        callUserUnblocked,
        callRecordingStopped,
        callReaction,
        custom,
      ];
}
