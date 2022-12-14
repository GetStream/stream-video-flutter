import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu_models;
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/types/other.dart';

import 'types/video_dimensions.dart';

extension StreamCallEventX<T> on Iterable<EventEmitter<T>?> {
  void emit(T event) {
    for (final emitter in this) {
      emitter?.emit(event);
    }
  }
}

extension ConnectionQualityX on sfu_models.ConnectionQuality {
  ConnectionQuality toStreamConnectionQuality() {
    switch (this) {
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_UNSPECIFIED:
        return ConnectionQuality.unknown;
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_BAD_UNSPECIFIED:
        return ConnectionQuality.poor;
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_POOR:
        return ConnectionQuality.good;
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_GOOD:
        return ConnectionQuality.excellent;
    }
    return ConnectionQuality.unknown;
  }
}

extension VideoQualityX on sfu_models.VideoQuality {
  VideoDimension? toVideoDimension() {
    switch (this) {
      case sfu_models.VideoQuality.VIDEO_QUALITY_HIGH:
        return VideoDimensionPresets.h540_169;
      case sfu_models.VideoQuality.VIDEO_QUALITY_MID:
        return VideoDimensionPresets.h360_169;
      case sfu_models.VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED:
        return VideoDimensionPresets.h180_169;
      default:
        return null;
    }
  }
}
