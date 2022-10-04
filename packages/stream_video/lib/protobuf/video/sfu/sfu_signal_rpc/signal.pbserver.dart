///
//  Generated code. Do not modify.
//  source: video/sfu/sfu_signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'signal.pb.dart' as $2;
import 'signal.pbjson.dart';

export 'signal.pb.dart';

abstract class SignalServerServiceBase extends $pb.GeneratedService {
  $async.Future<$2.JoinResponse> join($pb.ServerContext ctx, $2.JoinRequest request);
  $async.Future<$2.SetPublisherResponse> setPublisher($pb.ServerContext ctx, $2.SetPublisherRequest request);
  $async.Future<$2.SendAnswerResponse> sendAnswer($pb.ServerContext ctx, $2.SendAnswerRequest request);
  $async.Future<$2.IceCandidateResponse> sendIceCandidate($pb.ServerContext ctx, $2.IceCandidateRequest request);
  $async.Future<$2.UpdateSubscriptionsResponse> updateSubscriptions($pb.ServerContext ctx, $2.UpdateSubscriptionsRequest request);
  $async.Future<$2.UpdateMuteStateResponse> updateMuteState($pb.ServerContext ctx, $2.UpdateMuteStateRequest request);
  $async.Future<$2.UpdateVideoQualityResponse> requestVideoQuality($pb.ServerContext ctx, $2.UpdateVideoQualityRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Join': return $2.JoinRequest();
      case 'SetPublisher': return $2.SetPublisherRequest();
      case 'SendAnswer': return $2.SendAnswerRequest();
      case 'SendIceCandidate': return $2.IceCandidateRequest();
      case 'UpdateSubscriptions': return $2.UpdateSubscriptionsRequest();
      case 'UpdateMuteState': return $2.UpdateMuteStateRequest();
      case 'RequestVideoQuality': return $2.UpdateVideoQualityRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Join': return this.join(ctx, request as $2.JoinRequest);
      case 'SetPublisher': return this.setPublisher(ctx, request as $2.SetPublisherRequest);
      case 'SendAnswer': return this.sendAnswer(ctx, request as $2.SendAnswerRequest);
      case 'SendIceCandidate': return this.sendIceCandidate(ctx, request as $2.IceCandidateRequest);
      case 'UpdateSubscriptions': return this.updateSubscriptions(ctx, request as $2.UpdateSubscriptionsRequest);
      case 'UpdateMuteState': return this.updateMuteState(ctx, request as $2.UpdateMuteStateRequest);
      case 'RequestVideoQuality': return this.requestVideoQuality(ctx, request as $2.UpdateVideoQualityRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SignalServerServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SignalServerServiceBase$messageJson;
}

