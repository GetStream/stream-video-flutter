///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'client_rpc.pb.dart' as $13;
import 'client_rpc.pbjson.dart';

export 'client_rpc.pb.dart';

abstract class ClientRPCServiceBase extends $pb.GeneratedService {
  $async.Future<$13.CreateCallResponse> createCall($pb.ServerContext ctx, $13.CreateCallRequest request);
  $async.Future<$13.GetOrCreateCallResponse> getOrCreateCall($pb.ServerContext ctx, $13.GetOrCreateCallRequest request);
  $async.Future<$13.JoinCallResponse> joinCall($pb.ServerContext ctx, $13.JoinCallRequest request);
  $async.Future<$13.GetCallEdgeServerResponse> getCallEdgeServer($pb.ServerContext ctx, $13.GetCallEdgeServerRequest request);
  $async.Future<$13.UpdateCallResponse> updateCall($pb.ServerContext ctx, $13.UpdateCallRequest request);
  $async.Future<$13.UpdateCallPermissionsResponse> updateCallPermissions($pb.ServerContext ctx, $13.UpdateCallPermissionsRequest request);
  $async.Future<$13.EndCallResponse> endCall($pb.ServerContext ctx, $13.EndCallRequest request);
  $async.Future<$13.QueryCallsResponse> queryCalls($pb.ServerContext ctx, $13.QueryCallsRequest request);
  $async.Future<$13.QueryMembersResponse> queryMembers($pb.ServerContext ctx, $13.QueryMembersRequest request);
  $async.Future<$13.CreateDeviceResponse> createDevice($pb.ServerContext ctx, $13.CreateDeviceRequest request);
  $async.Future<$13.DeleteDeviceResponse> deleteDevice($pb.ServerContext ctx, $13.DeleteDeviceRequest request);
  $async.Future<$13.QueryDevicesResponse> queryDevices($pb.ServerContext ctx, $13.QueryDevicesRequest request);
  $async.Future<$13.StartTranscriptionResponse> startTranscription($pb.ServerContext ctx, $13.StartTranscriptionRequest request);
  $async.Future<$13.StopTranscriptionResponse> stopTranscription($pb.ServerContext ctx, $13.StopTranscriptionRequest request);
  $async.Future<$13.StartClosedCaptionResponse> startClosedCaption($pb.ServerContext ctx, $13.StartClosedCaptionRequest request);
  $async.Future<$13.StopClosedCaptionResponse> stopClosedCaption($pb.ServerContext ctx, $13.StopClosedCaptionRequest request);
  $async.Future<$13.StartBroadcastResponse> startBroadcast($pb.ServerContext ctx, $13.StartBroadcastRequest request);
  $async.Future<$13.StopBroadcastResponse> stopBroadcast($pb.ServerContext ctx, $13.StopBroadcastRequest request);
  $async.Future<$13.StartRecordingResponse> startRecording($pb.ServerContext ctx, $13.StartRecordingRequest request);
  $async.Future<$13.StopRecordingResponse> stopRecording($pb.ServerContext ctx, $13.StopRecordingRequest request);
  $async.Future<$13.UpsertCallMembersResponse> upsertCallMembers($pb.ServerContext ctx, $13.UpsertCallMembersRequest request);
  $async.Future<$13.DeleteCallMembersResponse> deleteCallMembers($pb.ServerContext ctx, $13.DeleteCallMembersRequest request);
  $async.Future<$13.SendEventResponse> sendEvent($pb.ServerContext ctx, $13.SendEventRequest request);
  $async.Future<$13.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $13.SendCustomEventRequest request);
  $async.Future<$13.QueryUsersResponse> queryUsers($pb.ServerContext ctx, $13.QueryUsersRequest request);
  $async.Future<$13.UpsertUsersResponse> upsertUsers($pb.ServerContext ctx, $13.UpsertUsersRequest request);
  $async.Future<$13.ReportCallStatsResponse> reportCallStats($pb.ServerContext ctx, $13.ReportCallStatsRequest request);
  $async.Future<$13.ReportCallStatEventResponse> reportCallStatEvent($pb.ServerContext ctx, $13.ReportCallStatEventRequest request);
  $async.Future<$13.ReviewCallResponse> reviewCall($pb.ServerContext ctx, $13.ReviewCallRequest request);
  $async.Future<$13.ReportIssueResponse> reportIssue($pb.ServerContext ctx, $13.ReportIssueRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $13.CreateCallRequest();
      case 'GetOrCreateCall': return $13.GetOrCreateCallRequest();
      case 'JoinCall': return $13.JoinCallRequest();
      case 'GetCallEdgeServer': return $13.GetCallEdgeServerRequest();
      case 'UpdateCall': return $13.UpdateCallRequest();
      case 'UpdateCallPermissions': return $13.UpdateCallPermissionsRequest();
      case 'EndCall': return $13.EndCallRequest();
      case 'QueryCalls': return $13.QueryCallsRequest();
      case 'QueryMembers': return $13.QueryMembersRequest();
      case 'CreateDevice': return $13.CreateDeviceRequest();
      case 'DeleteDevice': return $13.DeleteDeviceRequest();
      case 'QueryDevices': return $13.QueryDevicesRequest();
      case 'StartTranscription': return $13.StartTranscriptionRequest();
      case 'StopTranscription': return $13.StopTranscriptionRequest();
      case 'StartClosedCaption': return $13.StartClosedCaptionRequest();
      case 'StopClosedCaption': return $13.StopClosedCaptionRequest();
      case 'StartBroadcast': return $13.StartBroadcastRequest();
      case 'StopBroadcast': return $13.StopBroadcastRequest();
      case 'StartRecording': return $13.StartRecordingRequest();
      case 'StopRecording': return $13.StopRecordingRequest();
      case 'UpsertCallMembers': return $13.UpsertCallMembersRequest();
      case 'DeleteCallMembers': return $13.DeleteCallMembersRequest();
      case 'SendEvent': return $13.SendEventRequest();
      case 'SendCustomEvent': return $13.SendCustomEventRequest();
      case 'QueryUsers': return $13.QueryUsersRequest();
      case 'UpsertUsers': return $13.UpsertUsersRequest();
      case 'ReportCallStats': return $13.ReportCallStatsRequest();
      case 'ReportCallStatEvent': return $13.ReportCallStatEventRequest();
      case 'ReviewCall': return $13.ReviewCallRequest();
      case 'ReportIssue': return $13.ReportIssueRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $13.CreateCallRequest);
      case 'GetOrCreateCall': return this.getOrCreateCall(ctx, request as $13.GetOrCreateCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $13.JoinCallRequest);
      case 'GetCallEdgeServer': return this.getCallEdgeServer(ctx, request as $13.GetCallEdgeServerRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $13.UpdateCallRequest);
      case 'UpdateCallPermissions': return this.updateCallPermissions(ctx, request as $13.UpdateCallPermissionsRequest);
      case 'EndCall': return this.endCall(ctx, request as $13.EndCallRequest);
      case 'QueryCalls': return this.queryCalls(ctx, request as $13.QueryCallsRequest);
      case 'QueryMembers': return this.queryMembers(ctx, request as $13.QueryMembersRequest);
      case 'CreateDevice': return this.createDevice(ctx, request as $13.CreateDeviceRequest);
      case 'DeleteDevice': return this.deleteDevice(ctx, request as $13.DeleteDeviceRequest);
      case 'QueryDevices': return this.queryDevices(ctx, request as $13.QueryDevicesRequest);
      case 'StartTranscription': return this.startTranscription(ctx, request as $13.StartTranscriptionRequest);
      case 'StopTranscription': return this.stopTranscription(ctx, request as $13.StopTranscriptionRequest);
      case 'StartClosedCaption': return this.startClosedCaption(ctx, request as $13.StartClosedCaptionRequest);
      case 'StopClosedCaption': return this.stopClosedCaption(ctx, request as $13.StopClosedCaptionRequest);
      case 'StartBroadcast': return this.startBroadcast(ctx, request as $13.StartBroadcastRequest);
      case 'StopBroadcast': return this.stopBroadcast(ctx, request as $13.StopBroadcastRequest);
      case 'StartRecording': return this.startRecording(ctx, request as $13.StartRecordingRequest);
      case 'StopRecording': return this.stopRecording(ctx, request as $13.StopRecordingRequest);
      case 'UpsertCallMembers': return this.upsertCallMembers(ctx, request as $13.UpsertCallMembersRequest);
      case 'DeleteCallMembers': return this.deleteCallMembers(ctx, request as $13.DeleteCallMembersRequest);
      case 'SendEvent': return this.sendEvent(ctx, request as $13.SendEventRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $13.SendCustomEventRequest);
      case 'QueryUsers': return this.queryUsers(ctx, request as $13.QueryUsersRequest);
      case 'UpsertUsers': return this.upsertUsers(ctx, request as $13.UpsertUsersRequest);
      case 'ReportCallStats': return this.reportCallStats(ctx, request as $13.ReportCallStatsRequest);
      case 'ReportCallStatEvent': return this.reportCallStatEvent(ctx, request as $13.ReportCallStatEventRequest);
      case 'ReviewCall': return this.reviewCall(ctx, request as $13.ReviewCallRequest);
      case 'ReportIssue': return this.reportIssue(ctx, request as $13.ReportIssueRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClientRPCServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ClientRPCServiceBase$messageJson;
}

