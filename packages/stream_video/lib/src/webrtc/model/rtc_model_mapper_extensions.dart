import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import 'rtc_video_dimension.dart';

extension SfuVideoDimensionMapper on RtcVideoDimension {
  sfu_models.VideoDimension toDTO() {
    return sfu_models.VideoDimension(
      width: width,
      height: height,
    );
  }
}
