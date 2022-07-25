///
//  Generated code. Do not modify.
//  source: video_coordinator_rpc/coordinator_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'coordinator_service.pb.dart' as $5;
import 'coordinator_service.pbjson.dart';

export 'coordinator_service.pb.dart';

abstract class CallCoordinatorServiceBase extends $pb.GeneratedService {
  $async.Future<$5.CreateCallResponse> createCall($pb.ServerContext ctx, $5.CreateCallRequest request);
  $async.Future<$5.GetCallResponse> getCall($pb.ServerContext ctx, $5.GetCallRequest request);
  $async.Future<$5.UpdateCallResponse> updateCall($pb.ServerContext ctx, $5.UpdateCallRequest request);
  $async.Future<$5.DeleteCallResponse> deleteCall($pb.ServerContext ctx, $5.DeleteCallRequest request);
  $async.Future<$5.JoinCallResponse> joinCall($pb.ServerContext ctx, $5.JoinCallRequest request);
  $async.Future<$5.SelectEdgeServerResponse> selectEdgeServer($pb.ServerContext ctx, $5.SelectEdgeServerRequest request);
  $async.Future<$5.LeaveCallResponse> leaveCall($pb.ServerContext ctx, $5.LeaveCallRequest request);
  $async.Future<$5.EndCallResponse> endCall($pb.ServerContext ctx, $5.EndCallRequest request);
  $async.Future<$5.AddDeviceResponse> addDevice($pb.ServerContext ctx, $5.AddDeviceRequest request);
  $async.Future<$5.RemoveDeviceResponse> removeDevice($pb.ServerContext ctx, $5.RemoveDeviceRequest request);
  $async.Future<$5.ListDevicesResponse> listDevices($pb.ServerContext ctx, $5.ListDevicesRequest request);
  $async.Future<$5.SendEventResponse> sendEvent($pb.ServerContext ctx, $5.SendEventRequest request);
  $async.Future<$5.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $5.SendCustomEventRequest request);
  $async.Future<$5.CreateOrUpdateCallsResponse> createOrUpdateCalls($pb.ServerContext ctx, $5.CreateOrUpdateCallsRequest request);
  $async.Future<$5.CreateOrUpdateUsersResponse> createOrUpdateUsers($pb.ServerContext ctx, $5.CreateOrUpdateUsersRequest request);
  $async.Future<$5.TranscribeCallResponse> transcribeCall($pb.ServerContext ctx, $5.TranscribeCallRequest request);
  $async.Future<$5.StopTranscribeCallResponse> stopTranscribeCall($pb.ServerContext ctx, $5.StopTranscribeCallRequest request);
  $async.Future<$5.StartBroadcastResponse> startBroadcast($pb.ServerContext ctx, $5.StartBroadcastRequest request);
  $async.Future<$5.StopBroadcastResponse> stopBroadcast($pb.ServerContext ctx, $5.StopBroadcastRequest request);
  $async.Future<$5.StartRecordingResponse> startRecording($pb.ServerContext ctx, $5.StartRecordingRequest request);
  $async.Future<$5.StopRecordingResponse> stopRecording($pb.ServerContext ctx, $5.StopRecordingRequest request);
  $async.Future<$5.GetRecordingsResponse> getRecordings($pb.ServerContext ctx, $5.GetRecordingsRequest request);
  $async.Future<$5.CreateUserResponse> createUser($pb.ServerContext ctx, $5.CreateUserRequest request);
  $async.Future<$5.DeleteUserResponse> deleteUser($pb.ServerContext ctx, $5.DeleteUserRequest request);
  $async.Future<$5.ExportUserResponse> exportUser($pb.ServerContext ctx, $5.ExportUserRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $5.CreateCallRequest();
      case 'GetCall': return $5.GetCallRequest();
      case 'UpdateCall': return $5.UpdateCallRequest();
      case 'DeleteCall': return $5.DeleteCallRequest();
      case 'JoinCall': return $5.JoinCallRequest();
      case 'SelectEdgeServer': return $5.SelectEdgeServerRequest();
      case 'LeaveCall': return $5.LeaveCallRequest();
      case 'EndCall': return $5.EndCallRequest();
      case 'AddDevice': return $5.AddDeviceRequest();
      case 'RemoveDevice': return $5.RemoveDeviceRequest();
      case 'ListDevices': return $5.ListDevicesRequest();
      case 'SendEvent': return $5.SendEventRequest();
      case 'SendCustomEvent': return $5.SendCustomEventRequest();
      case 'CreateOrUpdateCalls': return $5.CreateOrUpdateCallsRequest();
      case 'CreateOrUpdateUsers': return $5.CreateOrUpdateUsersRequest();
      case 'TranscribeCall': return $5.TranscribeCallRequest();
      case 'StopTranscribeCall': return $5.StopTranscribeCallRequest();
      case 'StartBroadcast': return $5.StartBroadcastRequest();
      case 'StopBroadcast': return $5.StopBroadcastRequest();
      case 'StartRecording': return $5.StartRecordingRequest();
      case 'StopRecording': return $5.StopRecordingRequest();
      case 'GetRecordings': return $5.GetRecordingsRequest();
      case 'CreateUser': return $5.CreateUserRequest();
      case 'DeleteUser': return $5.DeleteUserRequest();
      case 'ExportUser': return $5.ExportUserRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $5.CreateCallRequest);
      case 'GetCall': return this.getCall(ctx, request as $5.GetCallRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $5.UpdateCallRequest);
      case 'DeleteCall': return this.deleteCall(ctx, request as $5.DeleteCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $5.JoinCallRequest);
      case 'SelectEdgeServer': return this.selectEdgeServer(ctx, request as $5.SelectEdgeServerRequest);
      case 'LeaveCall': return this.leaveCall(ctx, request as $5.LeaveCallRequest);
      case 'EndCall': return this.endCall(ctx, request as $5.EndCallRequest);
      case 'AddDevice': return this.addDevice(ctx, request as $5.AddDeviceRequest);
      case 'RemoveDevice': return this.removeDevice(ctx, request as $5.RemoveDeviceRequest);
      case 'ListDevices': return this.listDevices(ctx, request as $5.ListDevicesRequest);
      case 'SendEvent': return this.sendEvent(ctx, request as $5.SendEventRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $5.SendCustomEventRequest);
      case 'CreateOrUpdateCalls': return this.createOrUpdateCalls(ctx, request as $5.CreateOrUpdateCallsRequest);
      case 'CreateOrUpdateUsers': return this.createOrUpdateUsers(ctx, request as $5.CreateOrUpdateUsersRequest);
      case 'TranscribeCall': return this.transcribeCall(ctx, request as $5.TranscribeCallRequest);
      case 'StopTranscribeCall': return this.stopTranscribeCall(ctx, request as $5.StopTranscribeCallRequest);
      case 'StartBroadcast': return this.startBroadcast(ctx, request as $5.StartBroadcastRequest);
      case 'StopBroadcast': return this.stopBroadcast(ctx, request as $5.StopBroadcastRequest);
      case 'StartRecording': return this.startRecording(ctx, request as $5.StartRecordingRequest);
      case 'StopRecording': return this.stopRecording(ctx, request as $5.StopRecordingRequest);
      case 'GetRecordings': return this.getRecordings(ctx, request as $5.GetRecordingsRequest);
      case 'CreateUser': return this.createUser(ctx, request as $5.CreateUserRequest);
      case 'DeleteUser': return this.deleteUser(ctx, request as $5.DeleteUserRequest);
      case 'ExportUser': return this.exportUser(ctx, request as $5.ExportUserRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => CallCoordinatorServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => CallCoordinatorServiceBase$messageJson;
}

