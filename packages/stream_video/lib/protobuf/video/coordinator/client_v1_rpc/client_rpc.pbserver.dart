///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'client_rpc.pb.dart' as $11;
import 'client_rpc.pbjson.dart';

export 'client_rpc.pb.dart';

abstract class ClientRPCServiceBase extends $pb.GeneratedService {
  $async.Future<$11.CreateCallResponse> createCall($pb.ServerContext ctx, $11.CreateCallRequest request);
  $async.Future<$11.GetOrCreateCallResponse> getOrCreateCall($pb.ServerContext ctx, $11.GetOrCreateCallRequest request);
  $async.Future<$11.JoinCallResponse> joinCall($pb.ServerContext ctx, $11.JoinCallRequest request);
  $async.Future<$11.GetCallEdgeServerResponse> getCallEdgeServer($pb.ServerContext ctx, $11.GetCallEdgeServerRequest request);
  $async.Future<$11.UpdateCallResponse> updateCall($pb.ServerContext ctx, $11.UpdateCallRequest request);
  $async.Future<$11.QueryCallsResponse> queryCalls($pb.ServerContext ctx, $11.QueryCallsRequest request);
  $async.Future<$11.QueryMembersResponse> queryMembers($pb.ServerContext ctx, $11.QueryMembersRequest request);
  $async.Future<$11.CreateDeviceResponse> createDevice($pb.ServerContext ctx, $11.CreateDeviceRequest request);
  $async.Future<$11.DeleteDeviceResponse> deleteDevice($pb.ServerContext ctx, $11.DeleteDeviceRequest request);
  $async.Future<$11.QueryDevicesResponse> queryDevices($pb.ServerContext ctx, $11.QueryDevicesRequest request);
  $async.Future<$11.UpdateCallMembersResponse> updateCallMembers($pb.ServerContext ctx, $11.UpdateCallMembersRequest request);
  $async.Future<$11.DeleteCallMembersResponse> deleteCallMembers($pb.ServerContext ctx, $11.DeleteCallMembersRequest request);
  $async.Future<$11.QueryCallTimelineEventsResponse> queryCallTimelineEvents($pb.ServerContext ctx, $11.QueryCallTimelineEventsRequest request);
  $async.Future<$11.SendCustomEventResponse> sendCustomEvent($pb.ServerContext ctx, $11.SendCustomEventRequest request);
  $async.Future<$11.ReportCallStatsResponse> reportCallStats($pb.ServerContext ctx, $11.ReportCallStatsRequest request);
  $async.Future<$11.ReviewCallResponse> reviewCall($pb.ServerContext ctx, $11.ReviewCallRequest request);
  $async.Future<$11.ReportIssueResponse> reportIssue($pb.ServerContext ctx, $11.ReportIssueRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'CreateCall': return $11.CreateCallRequest();
      case 'GetOrCreateCall': return $11.GetOrCreateCallRequest();
      case 'JoinCall': return $11.JoinCallRequest();
      case 'GetCallEdgeServer': return $11.GetCallEdgeServerRequest();
      case 'UpdateCall': return $11.UpdateCallRequest();
      case 'QueryCalls': return $11.QueryCallsRequest();
      case 'QueryMembers': return $11.QueryMembersRequest();
      case 'CreateDevice': return $11.CreateDeviceRequest();
      case 'DeleteDevice': return $11.DeleteDeviceRequest();
      case 'QueryDevices': return $11.QueryDevicesRequest();
      case 'UpdateCallMembers': return $11.UpdateCallMembersRequest();
      case 'DeleteCallMembers': return $11.DeleteCallMembersRequest();
      case 'QueryCallTimelineEvents': return $11.QueryCallTimelineEventsRequest();
      case 'SendCustomEvent': return $11.SendCustomEventRequest();
      case 'ReportCallStats': return $11.ReportCallStatsRequest();
      case 'ReviewCall': return $11.ReviewCallRequest();
      case 'ReportIssue': return $11.ReportIssueRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'CreateCall': return this.createCall(ctx, request as $11.CreateCallRequest);
      case 'GetOrCreateCall': return this.getOrCreateCall(ctx, request as $11.GetOrCreateCallRequest);
      case 'JoinCall': return this.joinCall(ctx, request as $11.JoinCallRequest);
      case 'GetCallEdgeServer': return this.getCallEdgeServer(ctx, request as $11.GetCallEdgeServerRequest);
      case 'UpdateCall': return this.updateCall(ctx, request as $11.UpdateCallRequest);
      case 'QueryCalls': return this.queryCalls(ctx, request as $11.QueryCallsRequest);
      case 'QueryMembers': return this.queryMembers(ctx, request as $11.QueryMembersRequest);
      case 'CreateDevice': return this.createDevice(ctx, request as $11.CreateDeviceRequest);
      case 'DeleteDevice': return this.deleteDevice(ctx, request as $11.DeleteDeviceRequest);
      case 'QueryDevices': return this.queryDevices(ctx, request as $11.QueryDevicesRequest);
      case 'UpdateCallMembers': return this.updateCallMembers(ctx, request as $11.UpdateCallMembersRequest);
      case 'DeleteCallMembers': return this.deleteCallMembers(ctx, request as $11.DeleteCallMembersRequest);
      case 'QueryCallTimelineEvents': return this.queryCallTimelineEvents(ctx, request as $11.QueryCallTimelineEventsRequest);
      case 'SendCustomEvent': return this.sendCustomEvent(ctx, request as $11.SendCustomEventRequest);
      case 'ReportCallStats': return this.reportCallStats(ctx, request as $11.ReportCallStatsRequest);
      case 'ReviewCall': return this.reviewCall(ctx, request as $11.ReviewCallRequest);
      case 'ReportIssue': return this.reportIssue(ctx, request as $11.ReportIssueRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClientRPCServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ClientRPCServiceBase$messageJson;
}

