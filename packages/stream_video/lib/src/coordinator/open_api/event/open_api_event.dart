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
        final callCreated = open.CallCreated.fromJson(obj);
        return result.copyWith(callCreated: callCreated);
      case EventType.callAccepted:
        final callAccepted = open.CallAccepted.fromJson(obj);
        return result.copyWith(callAccepted: callAccepted);
      case EventType.callRejected:
        final callRejected = open.CallRejected.fromJson(obj);
        return result.copyWith(callRejected: callRejected);
      case EventType.callCancelled:
        final callCancelled = open.CallCancelled.fromJson(obj);
        return result.copyWith(callCancelled: callCancelled);
      case EventType.callUpdated:
        final callUpdated = open.CallUpdated.fromJson(obj);
        return result.copyWith(callUpdated: callUpdated);
      case EventType.callEnded:
        final callEnded = open.CallEnded.fromJson(obj);
        return result.copyWith(callEnded: callEnded);
      case EventType.callPermissionRequest:
        final callPermissionRequest = open.CallPermissionRequest.fromJson(obj);
        return result.copyWith(callPermissionRequest: callPermissionRequest);
      case EventType.callPermissionsUpdated:
        final permissionsUpdated = open.CallPermissionsUpdated.fromJson(obj);
        return result.copyWith(callPermissionsUpdated: permissionsUpdated);

      case EventType.callRecordingStarted:
        final permissionsUpdated = open.CallPermissionsUpdated.fromJson(obj);
        return result.copyWith(callPermissionsUpdated: permissionsUpdated);

      case EventType.callRecordingStopped:
        final permissionsUpdated = open.CallPermissionsUpdated.fromJson(obj);
        return result.copyWith(callPermissionsUpdated: permissionsUpdated);

      case EventType.custom:
        final custom = open.Custom.fromJson(obj);
        return result.copyWith(custom: custom);
      case EventType.unknown:
        return result;
    }
  }

  final EventType type;
  final HealthCheck? healthCheck;
  final open.CallCreated? callCreated;
  final open.CallAccepted? callAccepted;
  final open.CallRejected? callRejected;
  final open.CallCancelled? callCancelled;
  final open.CallUpdated? callUpdated;
  final open.CallEnded? callEnded;
  final open.CallPermissionRequest? callPermissionRequest;
  final open.CallPermissionsUpdated? callPermissionsUpdated;
  final open.CallRecordingStarted? callRecordingStarted;
  final open.CallRecordingStopped? callRecordingStopped;
  final open.Custom? custom;

  OpenApiEvent copyWith({
    EventType? type,
    HealthCheck? healthCheck,
    open.CallCreated? callCreated,
    open.CallAccepted? callAccepted,
    open.CallRejected? callRejected,
    open.CallCancelled? callCancelled,
    open.CallUpdated? callUpdated,
    open.CallEnded? callEnded,
    open.CallPermissionRequest? callPermissionRequest,
    open.CallPermissionsUpdated? callPermissionsUpdated,
    open.CallRecordingStarted? callRecordingStarted,
    open.CallRecordingStopped? callRecordingStopped,
    open.Custom? custom,
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
        callRecordingStopped,
        custom,
      ];
}
