import 'dart:async';

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
/// The platform enumerates every screen and window and captures a bitmap of
/// each one on every load, which is expensive enough to be visible, so the
/// list is a snapshot: it is read on construction and again on [refresh], and
/// never on a timer. A source opened after the load appears once the user asks
/// for it.
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
    unawaited(refresh());
  }

  /// The resolution asked of the platform for each thumbnail.
  ///
  /// The platform captures and encodes one bitmap per screen and window at
  /// this size, and a picker decodes all of them, so this is the main cost of
  /// opening one.
  static const defaultThumbnailSize = Size(480, 300);

  final DesktopCapturer _capturer;
  final Size _thumbnailSize;
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
  /// Does nothing while a load is already running. A selection that is no
  /// longer on offer is dropped.
  Future<void> refresh() async {
    if (value.isLoading) return;
    value = value.copyWith(isLoading: true, error: null);

    try {
      final sources = await _capturer.getSources(
        types: const [SourceType.Screen, SourceType.Window],
        thumbnailSize: ThumbnailSize(
          _thumbnailSize.width.round(),
          _thumbnailSize.height.round(),
        ),
      );

      if (_disposed) return;
      value = value.copyWith(
        sources: List.unmodifiable(sources),
        isLoading: false,
      );
    } catch (e, stk) {
      screenShareLogger.e(() => '[refresh] failed: $e, $stk');
      if (_disposed) return;
      value = value.copyWith(isLoading: false, error: e);
    }
  }

  @override
  void dispose() {
    _disposed = true;
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
    this.selectedSourceId,
    this.isLoading = false,
    this.error,
  });

  /// Every screen and window the last load found, in the order the platform
  /// reported them.
  final List<DesktopCapturerSource> sources;

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

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// [error] is cleared by passing null explicitly; the other nullable fields
  /// are left alone when omitted.
  ScreenShareSourceState copyWith({
    List<DesktopCapturerSource>? sources,
    SourceType? sourceType,
    String? selectedSourceId,
    bool? isLoading,
    Object? error = _unchanged,
  }) {
    return ScreenShareSourceState(
      sources: sources ?? this.sources,
      sourceType: sourceType ?? this.sourceType,
      selectedSourceId: selectedSourceId ?? this.selectedSourceId,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unchanged) ? this.error : error,
    );
  }

  static const _unchanged = Object();
}
