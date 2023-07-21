///
//  Generated code. Do not modify.
//  source: video/sfu/signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'signal.pb.dart' as $1;
import '../models/models.pb.dart' as $0;
import 'signal.pbjson.dart';

export 'signal.pb.dart';

abstract class SignalServerServiceBase extends $pb.GeneratedService {
  $async.Future<$1.SetPublisherResponse> setPublisher($pb.ServerContext ctx, $1.SetPublisherRequest request);
  $async.Future<$1.SendAnswerResponse> sendAnswer($pb.ServerContext ctx, $1.SendAnswerRequest request);
  $async.Future<$1.ICETrickleResponse> iceTrickle($pb.ServerContext ctx, $0.ICETrickle request);
  $async.Future<$1.UpdateSubscriptionsResponse> updateSubscriptions($pb.ServerContext ctx, $1.UpdateSubscriptionsRequest request);
  $async.Future<$1.UpdateMuteStatesResponse> updateMuteStates($pb.ServerContext ctx, $1.UpdateMuteStatesRequest request);
  $async.Future<$1.ICERestartResponse> iceRestart($pb.ServerContext ctx, $1.ICERestartRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'SetPublisher': return $1.SetPublisherRequest();
      case 'SendAnswer': return $1.SendAnswerRequest();
      case 'IceTrickle': return $0.ICETrickle();
      case 'UpdateSubscriptions': return $1.UpdateSubscriptionsRequest();
      case 'UpdateMuteStates': return $1.UpdateMuteStatesRequest();
      case 'IceRestart': return $1.ICERestartRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'SetPublisher': return this.setPublisher(ctx, request as $1.SetPublisherRequest);
      case 'SendAnswer': return this.sendAnswer(ctx, request as $1.SendAnswerRequest);
      case 'IceTrickle': return this.iceTrickle(ctx, request as $0.ICETrickle);
      case 'UpdateSubscriptions': return this.updateSubscriptions(ctx, request as $1.UpdateSubscriptionsRequest);
      case 'UpdateMuteStates': return this.updateMuteStates(ctx, request as $1.UpdateMuteStatesRequest);
      case 'IceRestart': return this.iceRestart(ctx, request as $1.ICERestartRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SignalServerServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SignalServerServiceBase$messageJson;
}

