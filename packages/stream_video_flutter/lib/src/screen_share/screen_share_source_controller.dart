import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'screen_share_logger.dart';

/// The screens and windows a desktop user can share, loaded once and held
/// until asked to reload.
///
/// Used by `showDefaultScreenSelectionDialog`, and directly by a custom
/// picker. Pair it with a [ValueListenableBuilder] to rebuild as the load
/// finishes.
///
/// A load makes the platform enumerate every screen and window and capture a
/// bitmap of each, which is expensive enough to be visible, so the list is a
/// snapshot: it is read on construction and again on [refresh], and never on a
/// timer. A source opened afterwards appears once the user asks for it.
class ScreenShareSourceController
    extends ValueNotifier<ScreenShareSourceState> {
  /// Creates a controller and starts loading.
  ///
  /// [sourceType] is the type shown first. Both types are loaded either way,
  /// so switching between them costs nothing.
  ScreenShareSourceController({
    DesktopCapturer? capturer,
    SourceType sourceType = SourceType.Screen,
    Size thumbnailSize = defaultThumbnailSize,
  }) : _capturer = capturer ?? desktopCapturer,
       _thumbnailSize = thumbnailSize,
       super(ScreenShareSourceState(sourceType: sourceType)) {
    // Subscribed before the first load, because the enumeration raises its
    // events while it runs. These getters have no implementation to fall back
    // on in the platform interface, so a capturer that reports its bitmaps
    // inline and raises no events need not provide them. Taken one at a time,
    // so a capturer offering one stream and not the other still has the one it
    // offers cancelled on dispose.
    void listenIfOffered(
      StreamController<DesktopCapturerSource> Function() stream,
      String name,
    ) {
      try {
        _events.add(stream().stream.listen(_onThumbnail));
        // The platform interface reports "this capturer has no such stream" by
        // throwing from the getter, so there is nothing else to catch here.
        // ignore: avoid_catching_errors
      } on UnimplementedError catch (e) {
        screenShareLogger.w(() => '[init] capturer posts no $name: $e');
      }
    }

    listenIfOffered(() => _capturer.onAdded, 'onAdded');
    listenIfOffered(() => _capturer.onThumbnailChanged, 'onThumbnailChanged');

    unawaited(refresh());
  }

  /// The resolution asked of the platform for each thumbnail.
  ///
  /// Honoured where the platform offers a choice; macOS captures at its own
  /// fixed size whatever this says.
  static const defaultThumbnailSize = Size(480, 300);

  static const _types = [SourceType.Screen, SourceType.Window];

  final DesktopCapturer _capturer;
  final Size _thumbnailSize;
  final List<StreamSubscription<DesktopCapturerSource>> _events = [];
  bool _disposed = false;

  /// Shows the sources of [sourceType], leaving the loaded list alone.
  ///
  /// Both types are already in [ScreenShareSourceState.sources], so this is a
  /// filter rather than a reload.
  void setSourceType(SourceType sourceType) {
    if (sourceType == value.sourceType) return;
    value = value.copyWith(sourceType: sourceType);
  }

  /// Marks [source] as the one to share.
  void setSelectedSource(DesktopCapturerSource source) {
    value = value.copyWith(selectedSourceId: source.id);
  }

  /// Re-reads the screens and windows from the platform.
  ///
  /// Does nothing while a load is already running — the capture pass that
  /// fills in the missing bitmaps counts as part of it. A selection that is no
  /// longer on offer is dropped.
  Future<void> refresh() async {
    if (value.isLoading) return;
    value = value.copyWith(isLoading: true, error: null);

    try {
      final sources = await _capturer.getSources(
        types: _types,
        thumbnailSize: ThumbnailSize(
          _thumbnailSize.width.round(),
          _thumbnailSize.height.round(),
        ),
      );

      if (_disposed) return;
      value = value._withSources(List.unmodifiable(sources));

      // Not every platform puts the bitmaps in the `getSources` result —
      // macOS leaves them out and reports them through the events the
      // enumeration raises, which is what the subscriptions above are for.
      // Only if something is still missing is it worth asking for a capture
      // pass, since that recaptures every screen and window.
      if (value.sources.any((it) => value.thumbnailFor(it) == null)) {
        await _capturer.updateSources(types: _types);
      }
    } catch (e, stk) {
      screenShareLogger.e(() => '[refresh] failed: $e, $stk');
      if (_disposed) return;
      value = value.copyWith(error: e);
    } finally {
      // Cleared once the capture pass is done rather than with the sources, so
      // that the whole load sits behind the guard above and behind whatever the
      // caller disables while it runs.
      if (!_disposed) value = value.copyWith(isLoading: false);
    }
  }

  void _onThumbnail(DesktopCapturerSource source) {
    final thumbnail = source.thumbnail;
    if (_disposed || thumbnail == null) return;

    value = value.copyWith(
      thumbnails: {...value.thumbnails, source.id: thumbnail},
    );
  }

  @override
  void dispose() {
    _disposed = true;
    for (final subscription in _events) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }
}

/// The state a [ScreenShareSourceController] holds.
@immutable
class ScreenShareSourceState {
  /// Creates a screen share source state.
  const ScreenShareSourceState({
    required this.sourceType,
    this.sources = const [],
    this.thumbnails = const {},
    this.selectedSourceId,
    this.isLoading = false,
    this.error,
  });

  /// Every screen and window the last load found, in the order the platform
  /// reported them.
  final List<DesktopCapturerSource> sources;

  /// The bitmap of each source that has reported one, by source id.
  ///
  /// Held here rather than read off the source because the platform delivers
  /// thumbnails after the source list, and a reload replaces the source
  /// objects.
  final Map<String, Uint8List> thumbnails;

  /// The type of source being shown.
  final SourceType sourceType;

  /// The id of the source the user picked, if any.
  final String? selectedSourceId;

  /// Whether a load is running.
  final bool isLoading;

  /// What the last load failed with, if it did.
  final Object? error;

  /// The sources of [sourceType].
  List<DesktopCapturerSource> get visibleSources => [
    for (final source in sources)
      if (source.type == sourceType) source,
  ];

  /// The source the user picked, or null when nothing is picked or the pick is
  /// no longer on offer.
  DesktopCapturerSource? get selectedSource {
    for (final source in sources) {
      if (source.id == selectedSourceId) return source;
    }
    return null;
  }

  /// The bitmap to draw for [source], if there is one yet.
  Uint8List? thumbnailFor(DesktopCapturerSource source) =>
      thumbnails[source.id] ?? source.thumbnail;

  /// A copy holding [sources], with the selection and the thumbnails of
  /// sources that are no longer on offer dropped. The load is left running,
  /// since the capture pass that fills in the missing bitmaps still has to
  /// follow.
  ScreenShareSourceState _withSources(List<DesktopCapturerSource> sources) {
    final ids = {for (final source in sources) source.id};

    return ScreenShareSourceState(
      sources: sources,
      thumbnails: {
        for (final entry in thumbnails.entries)
          if (ids.contains(entry.key)) entry.key: entry.value,
      },
      sourceType: sourceType,
      selectedSourceId: ids.contains(selectedSourceId)
          ? selectedSourceId
          : null,
      isLoading: isLoading,
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// [error] is cleared by passing null explicitly; the other nullable fields
  /// are left alone when omitted.
  ScreenShareSourceState copyWith({
    List<DesktopCapturerSource>? sources,
    Map<String, Uint8List>? thumbnails,
    SourceType? sourceType,
    String? selectedSourceId,
    bool? isLoading,
    Object? error = _unchanged,
  }) {
    return ScreenShareSourceState(
      sources: sources ?? this.sources,
      thumbnails: thumbnails ?? this.thumbnails,
      sourceType: sourceType ?? this.sourceType,
      selectedSourceId: selectedSourceId ?? this.selectedSourceId,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unchanged) ? this.error : error,
    );
  }

  static const _unchanged = Object();
}
