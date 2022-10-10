///
//  Generated code. Do not modify.
//  source: video/sfu/signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'signal.pb.dart' as $3;
import 'signal.pbjson.dart';

export 'signal.pb.dart';

abstract class SignalServerServiceBase extends $pb.GeneratedService {
  $async.Future<$3.JoinResponse> join($pb.ServerContext ctx, $3.JoinRequest request);
  $async.Future<$3.SetPublisherResponse> setPublisher($pb.ServerContext ctx, $3.SetPublisherRequest request);
  $async.Future<$3.SendAnswerResponse> sendAnswer($pb.ServerContext ctx, $3.SendAnswerRequest request);
  $async.Future<$3.IceCandidateResponse> sendIceCandidate($pb.ServerContext ctx, $3.IceCandidateRequest request);
  $async.Future<$3.UpdateSubscriptionsResponse> updateSubscriptions($pb.ServerContext ctx, $3.UpdateSubscriptionsRequest request);
  $async.Future<$3.UpdateMuteStateResponse> updateMuteState($pb.ServerContext ctx, $3.UpdateMuteStateRequest request);
  $async.Future<$3.UpdateVideoQualityResponse> requestVideoQuality($pb.ServerContext ctx, $3.UpdateVideoQualityRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Join': return $3.JoinRequest();
      case 'SetPublisher': return $3.SetPublisherRequest();
      case 'SendAnswer': return $3.SendAnswerRequest();
      case 'SendIceCandidate': return $3.IceCandidateRequest();
      case 'UpdateSubscriptions': return $3.UpdateSubscriptionsRequest();
      case 'UpdateMuteState': return $3.UpdateMuteStateRequest();
      case 'RequestVideoQuality': return $3.UpdateVideoQualityRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Join': return this.join(ctx, request as $3.JoinRequest);
      case 'SetPublisher': return this.setPublisher(ctx, request as $3.SetPublisherRequest);
      case 'SendAnswer': return this.sendAnswer(ctx, request as $3.SendAnswerRequest);
      case 'SendIceCandidate': return this.sendIceCandidate(ctx, request as $3.IceCandidateRequest);
      case 'UpdateSubscriptions': return this.updateSubscriptions(ctx, request as $3.UpdateSubscriptionsRequest);
      case 'UpdateMuteState': return this.updateMuteState(ctx, request as $3.UpdateMuteStateRequest);
      case 'RequestVideoQuality': return this.requestVideoQuality(ctx, request as $3.UpdateVideoQualityRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SignalServerServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SignalServerServiceBase$messageJson;
}

