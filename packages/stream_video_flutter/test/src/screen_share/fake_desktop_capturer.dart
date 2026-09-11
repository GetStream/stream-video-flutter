import 'dart:convert';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// A [DesktopCapturer] that hands back the sources it was built with and
/// counts what was asked of it.
///
/// The real one is a global reached through `desktopCapturer`, which is why
/// [ScreenShareSourceController] takes one.
class FakeDesktopCapturer extends DesktopCapturer {
  FakeDesktopCapturer({this.sources = const []});

  /// What the next [getSources] resolves to.
  List<DesktopCapturerSource> sources;

  /// The `types` of every [getSources] call, in order.
  final List<List<SourceType>> getSourcesCalls = [];

  /// The `thumbnailSize` of every [getSources] call, in order.
  final List<ThumbnailSize?> requestedThumbnailSizes = [];

  /// How many times [updateSources] was called.
  int updateSourcesCallCount = 0;

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
    return true;
  }
}

/// A [DesktopCapturerSource] with fixed values.
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
  final Uint8List? thumbnail;

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
