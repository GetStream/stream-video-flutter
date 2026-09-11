import 'dart:async';
import 'dart:convert';

import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// A [DesktopCapturer] that hands back the sources it was built with and
/// counts what was asked of it.
///
/// The real one is a global reached through `desktopCapturer`, which is why
/// [ScreenShareSourceController] takes one.
///
/// Models how the platform actually delivers bitmaps: macOS leaves them out
/// of the `getSources` result and posts them as events instead. A source built
/// with a bitmap of its own stands for the platforms that do return them
/// inline; one listed in [pendingThumbnails] only gets its bitmap once an
/// update asks for it.
class FakeDesktopCapturer extends DesktopCapturer {
  FakeDesktopCapturer({
    this.sources = const [],
    this.pendingThumbnails = const {},
  });

  /// What the next [getSources] resolves to.
  List<DesktopCapturerSource> sources;

  /// Bitmaps the platform hands over only on an update, by source id.
  Map<String, Uint8List> pendingThumbnails;

  /// The `types` of every [getSources] call, in order.
  final List<List<SourceType>> getSourcesCalls = [];

  /// The `thumbnailSize` of every [getSources] call, in order.
  final List<ThumbnailSize?> requestedThumbnailSizes = [];

  /// How many times [updateSources] was called.
  int updateSourcesCallCount = 0;

  @override
  final StreamController<DesktopCapturerSource> onAdded =
      StreamController.broadcast(sync: true);

  @override
  final StreamController<DesktopCapturerSource> onThumbnailChanged =
      StreamController.broadcast(sync: true);

  @override
  Future<List<DesktopCapturerSource>> getSources({
    required List<SourceType> types,
    ThumbnailSize? thumbnailSize,
  }) async {
    getSourcesCalls.add(types);
    requestedThumbnailSizes.add(thumbnailSize);
    return sources;
  }

  @override
  Future<bool> updateSources({required List<SourceType> types}) async {
    updateSourcesCallCount++;
    for (final source in sources) {
      final pending = pendingThumbnails[source.id];
      if (pending != null && source is FakeDesktopCapturerSource) {
        source.thumbnail = pending;
      }
      if (source.thumbnail != null) onThumbnailChanged.add(source);
    }
    return true;
  }

  /// Releases the event controllers.
  Future<void> close() async {
    await onAdded.close();
    await onThumbnailChanged.close();
  }
}

/// A [DesktopCapturerSource] with fixed values and, like the native one, a
/// bitmap the platform can fill in later.
class FakeDesktopCapturerSource extends DesktopCapturerSource {
  FakeDesktopCapturerSource({
    required this.id,
    required this.name,
    required this.type,
    this.thumbnail,
  });

  @override
  final String id;

  @override
  final String name;

  @override
  final SourceType type;

  @override
  Uint8List? thumbnail;

  @override
  ThumbnailSize get thumbnailSize => ThumbnailSize(480, 300);
}

/// A 2x2 PNG in the design's accent blue.
final Uint8List blueThumbnail = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAAD0lEQVR4nGNgiP8PQhAKACJaBXnC'
  '+/yRAAAAAElFTkSuQmCC',
);

/// A 2x2 PNG in a neutral grey.
final Uint8List greyThumbnail = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAAEElEQVR4nGPIKG4FIgYIBQAmGgWB'
  '3tA7ugAAAABJRU5ErkJggg==',
);
