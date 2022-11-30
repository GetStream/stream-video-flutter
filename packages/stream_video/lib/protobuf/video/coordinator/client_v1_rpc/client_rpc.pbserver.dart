///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'client_rpc.pb.dart' as $10;
import 'client_rpc.pbjson.dart';

export 'client_rpc.pb.dart';

abstract class ClientRPCServiceBase extends $pb.GeneratedService {
  $async.Future<$10.CreateCallResponse> createCall($pb.ServerContext ctx, $10.CreateCallRequest request);
  $async.Future<$10.GetOrCreateCallResponse> getOrCreateCall($pb.ServerContext ctx, $10.GetOrCreateCallRequest request);
  $async.Future<$10.JoinCallResponse> joinCall($pb.ServerContext ctx, $10.JoinCallRequest request);
  $async.Future<$10.GetCallEdgeServerResponse> getCallEdgeServer($pb.ServerContext ctx, $10.GetCallEdgeServerRequest request);
  $async.Future<$10.UpdateCallResponse> updateCall($pb.ServerContext ctx, $10.UpdateCallRequest request);
  $async.Future<$10.UpdateCallPermissionsResponse> updateCallPermissions($pb.ServerContext ctx, $10.UpdateCallPermissionsRequest request);
  $async.Future<$10.EndCallResponse> endCall($pb.ServerContext ctx, $10.EndCallRequest request);
  $async.Future<$10.QueryCallsResponse> queryCalls($pb.ServerContext ctx, $10.QueryCallsRequest request);
  $async.Future<$10.QueryMembersResponse> queryMembers($pb.ServerContext ctx, $10.QueryMembersRequest request);
  $async.Future<$10.CreateDeviceResponse> createDevice($pb.ServerContext ctx, $10.CreateDeviceRequest request);
  $async.Future<$10.DeleteDeviceResponse> deleteDevice($pb.ServerContext ctx, $10.DeleteDeviceRequest request);
  $async.Future<$10.QueryDevicesResponse> queryDevices($pb.ServerContext ctx, $10.QueryDevicesRequest request);
  $async.Future<$10.StartBroadcastResponse> startBroadcast($pb.ServerContext ctx, $10.StartBroadcastRequest request);
  $async.Future<$10.StopBroadcastResponse> stopBroadcast($pb.ServerContext ctx, $10.StopBroadcastRequest request);
  $async.Future<$10.StartRecordingResponse> startRecording($pb.ServerContext ctx, $10.StartRecordingRequest request);
  $async.Future<$10.StopRecordingResponse> stopRecording($pb.ServerContext ctx, $10.StopRecordingRequest request);
  $async.Future<$10.UpsertCallMembersResponse> upsertCallMembers($pb.ServerContext ctx, $10.UpsertCallMembersRequest request);
  $async.Future<$10.DeleteCallMembersResponse> deleteCallMembers($pb.ServerContext ctx, $10.DeleteCallMembersRequest request);
  $async.Future<$10.SendEventResponse> sendEvent($pb.ServerContext ctx, $10.SendEventRequest request);
  $async.Future<$10.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $10.SendCustomEventRequest request);
  $async.Future<$10.ReportCallStatsResponse> reportCallStats($pb.ServerContext ctx, $10.ReportCallStatsRequest request);
  $async.Future<$10.ReportCallStatEventResponse> reportCallStatEvent($pb.ServerContext ctx, $10.ReportCallStatEventRequest request);
  $async.Future<$10.ReviewCallResponse> reviewCall($pb.ServerContext ctx, $10.ReviewCallRequest request);
  $async.Future<$10.ReportIssueResponse> reportIssue($pb.ServerContext ctx, $10.ReportIssueRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $10.CreateCallRequest();
      case 'GetOrCreateCall': return $10.GetOrCreateCallRequest();
      case 'JoinCall': return $10.JoinCallRequest();
      case 'GetCallEdgeServer': return $10.GetCallEdgeServerRequest();
      case 'UpdateCall': return $10.UpdateCallRequest();
      case 'UpdateCallPermissions': return $10.UpdateCallPermissionsRequest();
      case 'EndCall': return $10.EndCallRequest();
      case 'QueryCalls': return $10.QueryCallsRequest();
      case 'QueryMembers': return $10.QueryMembersRequest();
      case 'CreateDevice': return $10.CreateDeviceRequest();
      case 'DeleteDevice': return $10.DeleteDeviceRequest();
      case 'QueryDevices': return $10.QueryDevicesRequest();
      case 'StartBroadcast': return $10.StartBroadcastRequest();
      case 'StopBroadcast': return $10.StopBroadcastRequest();
      case 'StartRecording': return $10.StartRecordingRequest();
      case 'StopRecording': return $10.StopRecordingRequest();
      case 'UpsertCallMembers': return $10.UpsertCallMembersRequest();
      case 'DeleteCallMembers': return $10.DeleteCallMembersRequest();
      case 'SendEvent': return $10.SendEventRequest();
      case 'SendCustomEvent': return $10.SendCustomEventRequest();
      case 'ReportCallStats': return $10.ReportCallStatsRequest();
      case 'ReportCallStatEvent': return $10.ReportCallStatEventRequest();
      case 'ReviewCall': return $10.ReviewCallRequest();
      case 'ReportIssue': return $10.ReportIssueRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $10.CreateCallRequest);
      case 'GetOrCreateCall': return this.getOrCreateCall(ctx, request as $10.GetOrCreateCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $10.JoinCallRequest);
      case 'GetCallEdgeServer': return this.getCallEdgeServer(ctx, request as $10.GetCallEdgeServerRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $10.UpdateCallRequest);
      case 'UpdateCallPermissions': return this.updateCallPermissions(ctx, request as $10.UpdateCallPermissionsRequest);
      case 'EndCall': return this.endCall(ctx, request as $10.EndCallRequest);
      case 'QueryCalls': return this.queryCalls(ctx, request as $10.QueryCallsRequest);
      case 'QueryMembers': return this.queryMembers(ctx, request as $10.QueryMembersRequest);
      case 'CreateDevice': return this.createDevice(ctx, request as $10.CreateDeviceRequest);
      case 'DeleteDevice': return this.deleteDevice(ctx, request as $10.DeleteDeviceRequest);
      case 'QueryDevices': return this.queryDevices(ctx, request as $10.QueryDevicesRequest);
      case 'StartBroadcast': return this.startBroadcast(ctx, request as $10.StartBroadcastRequest);
      case 'StopBroadcast': return this.stopBroadcast(ctx, request as $10.StopBroadcastRequest);
      case 'StartRecording': return this.startRecording(ctx, request as $10.StartRecordingRequest);
      case 'StopRecording': return this.stopRecording(ctx, request as $10.StopRecordingRequest);
      case 'UpsertCallMembers': return this.upsertCallMembers(ctx, request as $10.UpsertCallMembersRequest);
      case 'DeleteCallMembers': return this.deleteCallMembers(ctx, request as $10.DeleteCallMembersRequest);
      case 'SendEvent': return this.sendEvent(ctx, request as $10.SendEventRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $10.SendCustomEventRequest);
      case 'ReportCallStats': return this.reportCallStats(ctx, request as $10.ReportCallStatsRequest);
      case 'ReportCallStatEvent': return this.reportCallStatEvent(ctx, request as $10.ReportCallStatEventRequest);
      case 'ReviewCall': return this.reviewCall(ctx, request as $10.ReviewCallRequest);
      case 'ReportIssue': return this.reportIssue(ctx, request as $10.ReportIssueRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClientRPCServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ClientRPCServiceBase$messageJson;
}

