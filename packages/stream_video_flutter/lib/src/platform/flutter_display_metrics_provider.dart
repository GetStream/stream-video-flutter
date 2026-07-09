import 'package:flutter/widgets.dart';
import 'package:stream_video/stream_video.dart';

/// [DisplayMetricsProvider] backed by [WidgetsBinding], matching the native
/// SDK's existing screen-share sizing behavior.
class FlutterDisplayMetricsProvider implements DisplayMetricsProvider {
  const FlutterDisplayMetricsProvider();

  @override
  StreamDisplaySize? get physicalScreenSize {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return null;
    final size = views.first.physicalSize;
    return StreamDisplaySize(size.width, size.height);
  }
}
