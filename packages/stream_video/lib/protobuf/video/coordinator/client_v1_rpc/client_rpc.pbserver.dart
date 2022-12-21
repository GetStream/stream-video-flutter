///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'client_rpc.pb.dart' as $12;
import 'client_rpc.pbjson.dart';

export 'client_rpc.pb.dart';

abstract class ClientRPCServiceBase extends $pb.GeneratedService {
  $async.Future<$12.CreateCallResponse> createCall($pb.ServerContext ctx, $12.CreateCallRequest request);
  $async.Future<$12.GetOrCreateCallResponse> getOrCreateCall($pb.ServerContext ctx, $12.GetOrCreateCallRequest request);
  $async.Future<$12.JoinCallResponse> joinCall($pb.ServerContext ctx, $12.JoinCallRequest request);
  $async.Future<$12.GetCallEdgeServerResponse> getCallEdgeServer($pb.ServerContext ctx, $12.GetCallEdgeServerRequest request);
  $async.Future<$12.UpdateCallResponse> updateCall($pb.ServerContext ctx, $12.UpdateCallRequest request);
  $async.Future<$12.UpdateCallPermissionsResponse> updateCallPermissions($pb.ServerContext ctx, $12.UpdateCallPermissionsRequest request);
  $async.Future<$12.EndCallResponse> endCall($pb.ServerContext ctx, $12.EndCallRequest request);
  $async.Future<$12.QueryCallsResponse> queryCalls($pb.ServerContext ctx, $12.QueryCallsRequest request);
  $async.Future<$12.QueryMembersResponse> queryMembers($pb.ServerContext ctx, $12.QueryMembersRequest request);
  $async.Future<$12.CreateDeviceResponse> createDevice($pb.ServerContext ctx, $12.CreateDeviceRequest request);
  $async.Future<$12.DeleteDeviceResponse> deleteDevice($pb.ServerContext ctx, $12.DeleteDeviceRequest request);
  $async.Future<$12.QueryDevicesResponse> queryDevices($pb.ServerContext ctx, $12.QueryDevicesRequest request);
  $async.Future<$12.StartTranscriptionResponse> startTranscription($pb.ServerContext ctx, $12.StartTranscriptionRequest request);
  $async.Future<$12.StopTranscriptionResponse> stopTranscription($pb.ServerContext ctx, $12.StopTranscriptionRequest request);
  $async.Future<$12.StartClosedCaptionResponse> startClosedCaption($pb.ServerContext ctx, $12.StartClosedCaptionRequest request);
  $async.Future<$12.StopClosedCaptionResponse> stopClosedCaption($pb.ServerContext ctx, $12.StopClosedCaptionRequest request);
  $async.Future<$12.StartBroadcastResponse> startBroadcast($pb.ServerContext ctx, $12.StartBroadcastRequest request);
  $async.Future<$12.StopBroadcastResponse> stopBroadcast($pb.ServerContext ctx, $12.StopBroadcastRequest request);
  $async.Future<$12.StartRecordingResponse> startRecording($pb.ServerContext ctx, $12.StartRecordingRequest request);
  $async.Future<$12.StopRecordingResponse> stopRecording($pb.ServerContext ctx, $12.StopRecordingRequest request);
  $async.Future<$12.UpsertCallMembersResponse> upsertCallMembers($pb.ServerContext ctx, $12.UpsertCallMembersRequest request);
  $async.Future<$12.DeleteCallMembersResponse> deleteCallMembers($pb.ServerContext ctx, $12.DeleteCallMembersRequest request);
  $async.Future<$12.SendEventResponse> sendEvent($pb.ServerContext ctx, $12.SendEventRequest request);
  $async.Future<$12.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $12.SendCustomEventRequest request);
  $async.Future<$12.QueryUsersResponse> queryUsers($pb.ServerContext ctx, $12.QueryUsersRequest request);
  $async.Future<$12.UpsertUsersResponse> upsertUsers($pb.ServerContext ctx, $12.UpsertUsersRequest request);
  $async.Future<$12.ReportCallStatsResponse> reportCallStats($pb.ServerContext ctx, $12.ReportCallStatsRequest request);
  $async.Future<$12.ReportCallStatEventResponse> reportCallStatEvent($pb.ServerContext ctx, $12.ReportCallStatEventRequest request);
  $async.Future<$12.ReviewCallResponse> reviewCall($pb.ServerContext ctx, $12.ReviewCallRequest request);
  $async.Future<$12.ReportIssueResponse> reportIssue($pb.ServerContext ctx, $12.ReportIssueRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $12.CreateCallRequest();
      case 'GetOrCreateCall': return $12.GetOrCreateCallRequest();
      case 'JoinCall': return $12.JoinCallRequest();
      case 'GetCallEdgeServer': return $12.GetCallEdgeServerRequest();
      case 'UpdateCall': return $12.UpdateCallRequest();
      case 'UpdateCallPermissions': return $12.UpdateCallPermissionsRequest();
      case 'EndCall': return $12.EndCallRequest();
      case 'QueryCalls': return $12.QueryCallsRequest();
      case 'QueryMembers': return $12.QueryMembersRequest();
      case 'CreateDevice': return $12.CreateDeviceRequest();
      case 'DeleteDevice': return $12.DeleteDeviceRequest();
      case 'QueryDevices': return $12.QueryDevicesRequest();
      case 'StartTranscription': return $12.StartTranscriptionRequest();
      case 'StopTranscription': return $12.StopTranscriptionRequest();
      case 'StartClosedCaption': return $12.StartClosedCaptionRequest();
      case 'StopClosedCaption': return $12.StopClosedCaptionRequest();
      case 'StartBroadcast': return $12.StartBroadcastRequest();
      case 'StopBroadcast': return $12.StopBroadcastRequest();
      case 'StartRecording': return $12.StartRecordingRequest();
      case 'StopRecording': return $12.StopRecordingRequest();
      case 'UpsertCallMembers': return $12.UpsertCallMembersRequest();
      case 'DeleteCallMembers': return $12.DeleteCallMembersRequest();
      case 'SendEvent': return $12.SendEventRequest();
      case 'SendCustomEvent': return $12.SendCustomEventRequest();
      case 'QueryUsers': return $12.QueryUsersRequest();
      case 'UpsertUsers': return $12.UpsertUsersRequest();
      case 'ReportCallStats': return $12.ReportCallStatsRequest();
      case 'ReportCallStatEvent': return $12.ReportCallStatEventRequest();
      case 'ReviewCall': return $12.ReviewCallRequest();
      case 'ReportIssue': return $12.ReportIssueRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $12.CreateCallRequest);
      case 'GetOrCreateCall': return this.getOrCreateCall(ctx, request as $12.GetOrCreateCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $12.JoinCallRequest);
      case 'GetCallEdgeServer': return this.getCallEdgeServer(ctx, request as $12.GetCallEdgeServerRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $12.UpdateCallRequest);
      case 'UpdateCallPermissions': return this.updateCallPermissions(ctx, request as $12.UpdateCallPermissionsRequest);
      case 'EndCall': return this.endCall(ctx, request as $12.EndCallRequest);
      case 'QueryCalls': return this.queryCalls(ctx, request as $12.QueryCallsRequest);
      case 'QueryMembers': return this.queryMembers(ctx, request as $12.QueryMembersRequest);
      case 'CreateDevice': return this.createDevice(ctx, request as $12.CreateDeviceRequest);
      case 'DeleteDevice': return this.deleteDevice(ctx, request as $12.DeleteDeviceRequest);
      case 'QueryDevices': return this.queryDevices(ctx, request as $12.QueryDevicesRequest);
      case 'StartTranscription': return this.startTranscription(ctx, request as $12.StartTranscriptionRequest);
      case 'StopTranscription': return this.stopTranscription(ctx, request as $12.StopTranscriptionRequest);
      case 'StartClosedCaption': return this.startClosedCaption(ctx, request as $12.StartClosedCaptionRequest);
      case 'StopClosedCaption': return this.stopClosedCaption(ctx, request as $12.StopClosedCaptionRequest);
      case 'StartBroadcast': return this.startBroadcast(ctx, request as $12.StartBroadcastRequest);
      case 'StopBroadcast': return this.stopBroadcast(ctx, request as $12.StopBroadcastRequest);
      case 'StartRecording': return this.startRecording(ctx, request as $12.StartRecordingRequest);
      case 'StopRecording': return this.stopRecording(ctx, request as $12.StopRecordingRequest);
      case 'UpsertCallMembers': return this.upsertCallMembers(ctx, request as $12.UpsertCallMembersRequest);
      case 'DeleteCallMembers': return this.deleteCallMembers(ctx, request as $12.DeleteCallMembersRequest);
      case 'SendEvent': return this.sendEvent(ctx, request as $12.SendEventRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $12.SendCustomEventRequest);
      case 'QueryUsers': return this.queryUsers(ctx, request as $12.QueryUsersRequest);
      case 'UpsertUsers': return this.upsertUsers(ctx, request as $12.UpsertUsersRequest);
      case 'ReportCallStats': return this.reportCallStats(ctx, request as $12.ReportCallStatsRequest);
      case 'ReportCallStatEvent': return this.reportCallStatEvent(ctx, request as $12.ReportCallStatEventRequest);
      case 'ReviewCall': return this.reviewCall(ctx, request as $12.ReviewCallRequest);
      case 'ReportIssue': return this.reportIssue(ctx, request as $12.ReportIssueRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClientRPCServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ClientRPCServiceBase$messageJson;
}

