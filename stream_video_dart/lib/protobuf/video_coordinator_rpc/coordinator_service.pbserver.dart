///
//  Generated code. Do not modify.
//  source: video_coordinator_rpc/coordinator_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'coordinator_service.pb.dart' as $3;
import 'coordinator_service.pbjson.dart';

export 'coordinator_service.pb.dart';

abstract class CallCoordinatorServiceBase extends $pb.GeneratedService {
  $async.Future<$3.CreateCallResponse> createCall($pb.ServerContext ctx, $3.CreateCallRequest request);
  $async.Future<$3.GetCallResponse> getCall($pb.ServerContext ctx, $3.GetCallRequest request);
  $async.Future<$3.UpdateCallResponse> updateCall($pb.ServerContext ctx, $3.UpdateCallRequest request);
  $async.Future<$3.DeleteCallResponse> deleteCall($pb.ServerContext ctx, $3.DeleteCallRequest request);
  $async.Future<$3.JoinCallResponse> joinCall($pb.ServerContext ctx, $3.JoinCallRequest request);
  $async.Future<$3.SelectEdgeServerResponse> selectEdgeServer($pb.ServerContext ctx, $3.SelectEdgeServerRequest request);
  $async.Future<$3.LeaveCallResponse> leaveCall($pb.ServerContext ctx, $3.LeaveCallRequest request);
  $async.Future<$3.EndCallResponse> endCall($pb.ServerContext ctx, $3.EndCallRequest request);
  $async.Future<$3.AddDeviceResponse> addDevice($pb.ServerContext ctx, $3.AddDeviceRequest request);
  $async.Future<$3.RemoveDeviceResponse> removeDevice($pb.ServerContext ctx, $3.RemoveDeviceRequest request);
  $async.Future<$3.ListDevicesResponse> listDevices($pb.ServerContext ctx, $3.ListDevicesRequest request);
  $async.Future<$3.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $3.SendCustomEventRequest request);
  $async.Future<$3.CreateOrUpdateCallsResponse> createOrUpdateCalls($pb.ServerContext ctx, $3.CreateOrUpdateCallsRequest request);
  $async.Future<$3.CreateOrUpdateUsersResponse> createOrUpdateUsers($pb.ServerContext ctx, $3.CreateOrUpdateUsersRequest request);
  $async.Future<$3.TranscribeCallResponse> transcribeCall($pb.ServerContext ctx, $3.TranscribeCallRequest request);
  $async.Future<$3.StopTranscribeCallResponse> stopTranscribeCall($pb.ServerContext ctx, $3.StopTranscribeCallRequest request);
  $async.Future<$3.StartBroadcastResponse> startBroadcast($pb.ServerContext ctx, $3.StartBroadcastRequest request);
  $async.Future<$3.StartBroadcastResponse> stopBroadcast($pb.ServerContext ctx, $3.StopBroadcastRequest request);
  $async.Future<$3.CreateUserResponse> createUser($pb.ServerContext ctx, $3.CreateUserRequest request);
  $async.Future<$3.DeleteUserResponse> deleteUser($pb.ServerContext ctx, $3.DeleteUserRequest request);
  $async.Future<$3.ExportUserResponse> exportUser($pb.ServerContext ctx, $3.ExportUserRequest request);
  $async.Future<$3.StartRecordingResponse> startRecording($pb.ServerContext ctx, $3.StartRecordingRequest request);
  $async.Future<$3.StopRecordingResponse> stopRecording($pb.ServerContext ctx, $3.StopRecordingRequest request);
  $async.Future<$3.GetRecordingsResponse> getRecordings($pb.ServerContext ctx, $3.GetRecordingsRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $3.CreateCallRequest();
      case 'GetCall': return $3.GetCallRequest();
      case 'UpdateCall': return $3.UpdateCallRequest();
      case 'DeleteCall': return $3.DeleteCallRequest();
      case 'JoinCall': return $3.JoinCallRequest();
      case 'SelectEdgeServer': return $3.SelectEdgeServerRequest();
      case 'LeaveCall': return $3.LeaveCallRequest();
      case 'EndCall': return $3.EndCallRequest();
      case 'AddDevice': return $3.AddDeviceRequest();
      case 'RemoveDevice': return $3.RemoveDeviceRequest();
      case 'ListDevices': return $3.ListDevicesRequest();
      case 'SendCustomEvent': return $3.SendCustomEventRequest();
      case 'CreateOrUpdateCalls': return $3.CreateOrUpdateCallsRequest();
      case 'CreateOrUpdateUsers': return $3.CreateOrUpdateUsersRequest();
      case 'TranscribeCall': return $3.TranscribeCallRequest();
      case 'StopTranscribeCall': return $3.StopTranscribeCallRequest();
      case 'StartBroadcast': return $3.StartBroadcastRequest();
      case 'StopBroadcast': return $3.StopBroadcastRequest();
      case 'CreateUser': return $3.CreateUserRequest();
      case 'DeleteUser': return $3.DeleteUserRequest();
      case 'ExportUser': return $3.ExportUserRequest();
      case 'StartRecording': return $3.StartRecordingRequest();
      case 'StopRecording': return $3.StopRecordingRequest();
      case 'GetRecordings': return $3.GetRecordingsRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $3.CreateCallRequest);
      case 'GetCall': return this.getCall(ctx, request as $3.GetCallRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $3.UpdateCallRequest);
      case 'DeleteCall': return this.deleteCall(ctx, request as $3.DeleteCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $3.JoinCallRequest);
      case 'SelectEdgeServer': return this.selectEdgeServer(ctx, request as $3.SelectEdgeServerRequest);
      case 'LeaveCall': return this.leaveCall(ctx, request as $3.LeaveCallRequest);
      case 'EndCall': return this.endCall(ctx, request as $3.EndCallRequest);
      case 'AddDevice': return this.addDevice(ctx, request as $3.AddDeviceRequest);
      case 'RemoveDevice': return this.removeDevice(ctx, request as $3.RemoveDeviceRequest);
      case 'ListDevices': return this.listDevices(ctx, request as $3.ListDevicesRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $3.SendCustomEventRequest);
      case 'CreateOrUpdateCalls': return this.createOrUpdateCalls(ctx, request as $3.CreateOrUpdateCallsRequest);
      case 'CreateOrUpdateUsers': return this.createOrUpdateUsers(ctx, request as $3.CreateOrUpdateUsersRequest);
      case 'TranscribeCall': return this.transcribeCall(ctx, request as $3.TranscribeCallRequest);
      case 'StopTranscribeCall': return this.stopTranscribeCall(ctx, request as $3.StopTranscribeCallRequest);
      case 'StartBroadcast': return this.startBroadcast(ctx, request as $3.StartBroadcastRequest);
      case 'StopBroadcast': return this.stopBroadcast(ctx, request as $3.StopBroadcastRequest);
      case 'CreateUser': return this.createUser(ctx, request as $3.CreateUserRequest);
      case 'DeleteUser': return this.deleteUser(ctx, request as $3.DeleteUserRequest);
      case 'ExportUser': return this.exportUser(ctx, request as $3.ExportUserRequest);
      case 'StartRecording': return this.startRecording(ctx, request as $3.StartRecordingRequest);
      case 'StopRecording': return this.stopRecording(ctx, request as $3.StopRecordingRequest);
      case 'GetRecordings': return this.getRecordings(ctx, request as $3.GetRecordingsRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => CallCoordinatorServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => CallCoordinatorServiceBase$messageJson;
}

