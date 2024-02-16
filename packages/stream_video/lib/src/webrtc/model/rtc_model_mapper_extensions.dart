import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';

extension SfuVideoDimensionMapper on RtcVideoDimension {
  sfu_models.VideoDimension toDTO() {
    return sfu_models.VideoDimension(
      width: width,
      height: height,
    );
  }
}
