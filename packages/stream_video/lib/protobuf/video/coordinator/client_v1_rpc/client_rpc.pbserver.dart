///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'client_rpc.pb.dart' as $8;
import 'client_rpc.pbjson.dart';

export 'client_rpc.pb.dart';

abstract class ClientRPCServiceBase extends $pb.GeneratedService {
  $async.Future<$8.CreateCallResponse> createCall($pb.ServerContext ctx, $8.CreateCallRequest request);
  $async.Future<$8.GetOrCreateCallResponse> getOrCreateCall($pb.ServerContext ctx, $8.GetOrCreateCallRequest request);
  $async.Future<$8.JoinCallResponse> joinCall($pb.ServerContext ctx, $8.JoinCallRequest request);
  $async.Future<$8.GetCallEdgeServerResponse> getCallEdgeServer($pb.ServerContext ctx, $8.GetCallEdgeServerRequest request);
  $async.Future<$8.UpdateCallResponse> updateCall($pb.ServerContext ctx, $8.UpdateCallRequest request);
  $async.Future<$8.QueryCallsResponse> queryCalls($pb.ServerContext ctx, $8.QueryCallsRequest request);
  $async.Future<$8.QueryMembersResponse> queryMembers($pb.ServerContext ctx, $8.QueryMembersRequest request);
  $async.Future<$8.CreateDeviceResponse> createDevice($pb.ServerContext ctx, $8.CreateDeviceRequest request);
  $async.Future<$8.DeleteDeviceResponse> deleteDevice($pb.ServerContext ctx, $8.DeleteDeviceRequest request);
  $async.Future<$8.QueryDevicesResponse> queryDevices($pb.ServerContext ctx, $8.QueryDevicesRequest request);
  $async.Future<$8.UpdateCallMembersResponse> updateCallMembers($pb.ServerContext ctx, $8.UpdateCallMembersRequest request);
  $async.Future<$8.DeleteCallMembersResponse> deleteCallMembers($pb.ServerContext ctx, $8.DeleteCallMembersRequest request);
  $async.Future<$8.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $8.SendCustomEventRequest request);
  $async.Future<$8.ReportCallStatsResponse> reportCallStats($pb.ServerContext ctx, $8.ReportCallStatsRequest request);
  $async.Future<$8.ReviewCallResponse> reviewCall($pb.ServerContext ctx, $8.ReviewCallRequest request);
  $async.Future<$8.ReportIssueResponse> reportIssue($pb.ServerContext ctx, $8.ReportIssueRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $8.CreateCallRequest();
      case 'GetOrCreateCall': return $8.GetOrCreateCallRequest();
      case 'JoinCall': return $8.JoinCallRequest();
      case 'GetCallEdgeServer': return $8.GetCallEdgeServerRequest();
      case 'UpdateCall': return $8.UpdateCallRequest();
      case 'QueryCalls': return $8.QueryCallsRequest();
      case 'QueryMembers': return $8.QueryMembersRequest();
      case 'CreateDevice': return $8.CreateDeviceRequest();
      case 'DeleteDevice': return $8.DeleteDeviceRequest();
      case 'QueryDevices': return $8.QueryDevicesRequest();
      case 'UpdateCallMembers': return $8.UpdateCallMembersRequest();
      case 'DeleteCallMembers': return $8.DeleteCallMembersRequest();
      case 'SendCustomEvent': return $8.SendCustomEventRequest();
      case 'ReportCallStats': return $8.ReportCallStatsRequest();
      case 'ReviewCall': return $8.ReviewCallRequest();
      case 'ReportIssue': return $8.ReportIssueRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $8.CreateCallRequest);
      case 'GetOrCreateCall': return this.getOrCreateCall(ctx, request as $8.GetOrCreateCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $8.JoinCallRequest);
      case 'GetCallEdgeServer': return this.getCallEdgeServer(ctx, request as $8.GetCallEdgeServerRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $8.UpdateCallRequest);
      case 'QueryCalls': return this.queryCalls(ctx, request as $8.QueryCallsRequest);
      case 'QueryMembers': return this.queryMembers(ctx, request as $8.QueryMembersRequest);
      case 'CreateDevice': return this.createDevice(ctx, request as $8.CreateDeviceRequest);
      case 'DeleteDevice': return this.deleteDevice(ctx, request as $8.DeleteDeviceRequest);
      case 'QueryDevices': return this.queryDevices(ctx, request as $8.QueryDevicesRequest);
      case 'UpdateCallMembers': return this.updateCallMembers(ctx, request as $8.UpdateCallMembersRequest);
      case 'DeleteCallMembers': return this.deleteCallMembers(ctx, request as $8.DeleteCallMembersRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $8.SendCustomEventRequest);
      case 'ReportCallStats': return this.reportCallStats(ctx, request as $8.ReportCallStatsRequest);
      case 'ReviewCall': return this.reviewCall(ctx, request as $8.ReviewCallRequest);
      case 'ReportIssue': return this.reportIssue(ctx, request as $8.ReportIssueRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClientRPCServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ClientRPCServiceBase$messageJson;
}

