///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'client_rpc.pb.dart' as $9;
import 'client_rpc.pbjson.dart';

export 'client_rpc.pb.dart';

abstract class ClientRPCServiceBase extends $pb.GeneratedService {
  $async.Future<$9.CreateCallResponse> createCall($pb.ServerContext ctx, $9.CreateCallRequest request);
  $async.Future<$9.GetOrCreateCallResponse> getOrCreateCall($pb.ServerContext ctx, $9.GetOrCreateCallRequest request);
  $async.Future<$9.JoinCallResponse> joinCall($pb.ServerContext ctx, $9.JoinCallRequest request);
  $async.Future<$9.GetCallEdgeServerResponse> getCallEdgeServer($pb.ServerContext ctx, $9.GetCallEdgeServerRequest request);
  $async.Future<$9.UpdateCallResponse> updateCall($pb.ServerContext ctx, $9.UpdateCallRequest request);
  $async.Future<$9.QueryCallsResponse> queryCalls($pb.ServerContext ctx, $9.QueryCallsRequest request);
  $async.Future<$9.QueryMembersResponse> queryMembers($pb.ServerContext ctx, $9.QueryMembersRequest request);
  $async.Future<$9.CreateDeviceResponse> createDevice($pb.ServerContext ctx, $9.CreateDeviceRequest request);
  $async.Future<$9.DeleteDeviceResponse> deleteDevice($pb.ServerContext ctx, $9.DeleteDeviceRequest request);
  $async.Future<$9.QueryDevicesResponse> queryDevices($pb.ServerContext ctx, $9.QueryDevicesRequest request);
  $async.Future<$9.UpdateCallMembersResponse> updateCallMembers($pb.ServerContext ctx, $9.UpdateCallMembersRequest request);
  $async.Future<$9.DeleteCallMembersResponse> deleteCallMembers($pb.ServerContext ctx, $9.DeleteCallMembersRequest request);
  $async.Future<$9.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $9.SendCustomEventRequest request);
  $async.Future<$9.ReportCallStatsResponse> reportCallStats($pb.ServerContext ctx, $9.ReportCallStatsRequest request);
  $async.Future<$9.ReviewCallResponse> reviewCall($pb.ServerContext ctx, $9.ReviewCallRequest request);
  $async.Future<$9.ReportIssueResponse> reportIssue($pb.ServerContext ctx, $9.ReportIssueRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $9.CreateCallRequest();
      case 'GetOrCreateCall': return $9.GetOrCreateCallRequest();
      case 'JoinCall': return $9.JoinCallRequest();
      case 'GetCallEdgeServer': return $9.GetCallEdgeServerRequest();
      case 'UpdateCall': return $9.UpdateCallRequest();
      case 'QueryCalls': return $9.QueryCallsRequest();
      case 'QueryMembers': return $9.QueryMembersRequest();
      case 'CreateDevice': return $9.CreateDeviceRequest();
      case 'DeleteDevice': return $9.DeleteDeviceRequest();
      case 'QueryDevices': return $9.QueryDevicesRequest();
      case 'UpdateCallMembers': return $9.UpdateCallMembersRequest();
      case 'DeleteCallMembers': return $9.DeleteCallMembersRequest();
      case 'SendCustomEvent': return $9.SendCustomEventRequest();
      case 'ReportCallStats': return $9.ReportCallStatsRequest();
      case 'ReviewCall': return $9.ReviewCallRequest();
      case 'ReportIssue': return $9.ReportIssueRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $9.CreateCallRequest);
      case 'GetOrCreateCall': return this.getOrCreateCall(ctx, request as $9.GetOrCreateCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $9.JoinCallRequest);
      case 'GetCallEdgeServer': return this.getCallEdgeServer(ctx, request as $9.GetCallEdgeServerRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $9.UpdateCallRequest);
      case 'QueryCalls': return this.queryCalls(ctx, request as $9.QueryCallsRequest);
      case 'QueryMembers': return this.queryMembers(ctx, request as $9.QueryMembersRequest);
      case 'CreateDevice': return this.createDevice(ctx, request as $9.CreateDeviceRequest);
      case 'DeleteDevice': return this.deleteDevice(ctx, request as $9.DeleteDeviceRequest);
      case 'QueryDevices': return this.queryDevices(ctx, request as $9.QueryDevicesRequest);
      case 'UpdateCallMembers': return this.updateCallMembers(ctx, request as $9.UpdateCallMembersRequest);
      case 'DeleteCallMembers': return this.deleteCallMembers(ctx, request as $9.DeleteCallMembersRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $9.SendCustomEventRequest);
      case 'ReportCallStats': return this.reportCallStats(ctx, request as $9.ReportCallStatsRequest);
      case 'ReviewCall': return this.reviewCall(ctx, request as $9.ReviewCallRequest);
      case 'ReportIssue': return this.reportIssue(ctx, request as $9.ReportIssueRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClientRPCServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ClientRPCServiceBase$messageJson;
}

