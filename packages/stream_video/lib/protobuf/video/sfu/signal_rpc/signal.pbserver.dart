//
//  Generated code. Do not modify.
//  source: video/sfu/signal_rpc/signal.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;
import 'signal.pb.dart' as $1;
import 'signal.pbjson.dart';

export 'signal.pb.dart';

abstract class SignalServerServiceBase extends $pb.GeneratedService {
  $async.Future<$1.SetPublisherResponse> setPublisher($pb.ServerContext ctx, $1.SetPublisherRequest request);
  $async.Future<$1.SendAnswerResponse> sendAnswer($pb.ServerContext ctx, $1.SendAnswerRequest request);
  $async.Future<$1.ICETrickleResponse> iceTrickle($pb.ServerContext ctx, $0.ICETrickle request);
  $async.Future<$1.UpdateSubscriptionsResponse> updateSubscriptions($pb.ServerContext ctx, $1.UpdateSubscriptionsRequest request);
  $async.Future<$1.UpdateMuteStatesResponse> updateMuteStates($pb.ServerContext ctx, $1.UpdateMuteStatesRequest request);
  $async.Future<$1.ICERestartResponse> iceRestart($pb.ServerContext ctx, $1.ICERestartRequest request);
  $async.Future<$1.SendStatsResponse> sendStats($pb.ServerContext ctx, $1.SendStatsRequest request);
  $async.Future<$1.StartNoiseCancellationResponse> startNoiseCancellation($pb.ServerContext ctx, $1.StartNoiseCancellationRequest request);
  $async.Future<$1.StopNoiseCancellationResponse> stopNoiseCancellation($pb.ServerContext ctx, $1.StopNoiseCancellationRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SetPublisher': return $1.SetPublisherRequest();
      case 'SendAnswer': return $1.SendAnswerRequest();
      case 'IceTrickle': return $0.ICETrickle();
      case 'UpdateSubscriptions': return $1.UpdateSubscriptionsRequest();
      case 'UpdateMuteStates': return $1.UpdateMuteStatesRequest();
      case 'IceRestart': return $1.ICERestartRequest();
      case 'SendStats': return $1.SendStatsRequest();
      case 'StartNoiseCancellation': return $1.StartNoiseCancellationRequest();
      case 'StopNoiseCancellation': return $1.StopNoiseCancellationRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SetPublisher': return this.setPublisher(ctx, request as $1.SetPublisherRequest);
      case 'SendAnswer': return this.sendAnswer(ctx, request as $1.SendAnswerRequest);
      case 'IceTrickle': return this.iceTrickle(ctx, request as $0.ICETrickle);
      case 'UpdateSubscriptions': return this.updateSubscriptions(ctx, request as $1.UpdateSubscriptionsRequest);
      case 'UpdateMuteStates': return this.updateMuteStates(ctx, request as $1.UpdateMuteStatesRequest);
      case 'IceRestart': return this.iceRestart(ctx, request as $1.ICERestartRequest);
      case 'SendStats': return this.sendStats(ctx, request as $1.SendStatsRequest);
      case 'StartNoiseCancellation': return this.startNoiseCancellation(ctx, request as $1.StartNoiseCancellationRequest);
      case 'StopNoiseCancellation': return this.stopNoiseCancellation(ctx, request as $1.StopNoiseCancellationRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SignalServerServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SignalServerServiceBase$messageJson;
}

