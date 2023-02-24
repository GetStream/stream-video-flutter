import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import 'event_type.dart';
import 'health_check.dart';

class OpenApiEvent with EquatableMixin {
  OpenApiEvent({
    this.type,
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
    if (type == EventType.healthCheck) {
      result.healthCheck = HealthCheck.fromJson(obj);
    } else if (type == EventType.callCreated) {
      result.callCreated = open.CallCreated.fromJson(obj);
    } else if (type == EventType.callAccepted) {
      result.callAccepted = open.CallAccepted.fromJson(obj);
    } else if (type == EventType.callRejected) {
      result.callRejected = open.CallRejected.fromJson(obj);
    } else if (type == EventType.callCancelled) {
      result.callCancelled = open.CallCancelled.fromJson(obj);
    } else if (type == EventType.callUpdated) {
      result.callUpdated = open.CallUpdated.fromJson(obj);
    } else if (type == EventType.callEnded) {
      result.callEnded = open.CallEnded.fromJson(obj);
    } else if (type == EventType.callPermissionRequest) {
      result.callPermissionRequest = open.CallPermissionRequest.fromJson(obj);
    } else if (type == EventType.callPermissionsUpdated) {
      result.callPermissionsUpdated = open.CallPermissionsUpdated.fromJson(obj);
    } else if (type == EventType.custom) {
      result.custom = open.Custom.fromJson(obj);
    }
    return result;
  }

  EventType? type;
  HealthCheck? healthCheck;
  open.CallCreated? callCreated;
  open.CallAccepted? callAccepted;
  open.CallRejected? callRejected;
  open.CallCancelled? callCancelled;
  open.CallUpdated? callUpdated;
  open.CallEnded? callEnded;
  open.CallPermissionRequest? callPermissionRequest;
  open.CallPermissionsUpdated? callPermissionsUpdated;
  open.Custom? custom;

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
