import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import 'package:stream_video/src/v2/utils/result.dart';

abstract class SfuClient {
  Future<Result<sfu.SendAnswerResponse>> sendAnswer(
    sfu.SendAnswerRequest request,
  );

  Future<Result<sfu.ICETrickleResponse>> sendIceCandidate(
    sfu_models.ICETrickle request,
  );

  Future<Result<sfu.SetPublisherResponse>> setPublisher(
    sfu.SetPublisherRequest request,
  );

  Future<Result<sfu.UpdateSubscriptionsResponse>> updateSubscriptions(
    sfu.UpdateSubscriptionsRequest request,
  );

  Future<Result<sfu.UpdateMuteStatesResponse>> updateMuteState(
    sfu.UpdateMuteStatesRequest request,
  );
}
