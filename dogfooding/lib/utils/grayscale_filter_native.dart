import 'package:stream_video_filters/stream_video_filters.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../dogfooding_app_channel.dart';

/// A custom effect, to try that path out: a grayscale frame processor the
/// app registers natively.
final VideoFilter grayscaleFilter = CustomVideoFilter(
  'grayscale',
  onRegister: () => DogfoodingAppChannel().registerGreyscaleEffect(),
);
