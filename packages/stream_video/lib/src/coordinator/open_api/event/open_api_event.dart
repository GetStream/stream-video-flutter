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
        return result.copyWith(healthCheck: HealthCheck.fromJson(obj));
      case EventType.callCreated:
        return result.copyWith(callCreated: open.CallCreated.fromJson(obj));
      case EventType.callAccepted:
        return result.copyWith(callAccepted: open.CallAccepted.fromJson(obj));
      case EventType.callRejected:
        return result.copyWith(callRejected: open.CallRejected.fromJson(obj));
      case EventType.callCancelled:
        return result.copyWith(callCancelled: open.CallCancelled.fromJson(obj));
      case EventType.callUpdated:
        return result.copyWith(callUpdated: open.CallUpdated.fromJson(obj));
      case EventType.callEnded:
        return result.copyWith(callEnded: open.CallEnded.fromJson(obj));
      case EventType.callPermissionRequest:
        return result.copyWith(
          callPermissionRequest: open.CallPermissionRequest.fromJson(obj),
        );
      case EventType.callPermissionsUpdated:
        return result.copyWith(
          callPermissionsUpdated: open.CallPermissionsUpdated.fromJson(obj),
        );
      case EventType.custom:
        return result.copyWith(custom: open.Custom.fromJson(obj));
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
        custom,
      ];
}
