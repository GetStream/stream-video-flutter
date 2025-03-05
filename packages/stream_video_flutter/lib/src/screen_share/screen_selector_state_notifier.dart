import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'desktop_screen_selector.dart';
import 'screen_share_logger.dart';

/// The [ScreenSelectorStateNotifier] is used to keep track of the available screens and windows to share.
/// This is used by [showDefaultScreenSelectionDialog], but can be used directly if you want to build a custom widget.
/// Can be used in combination with a [ValueListenableBuilder] to get stateful updates.
class ScreenSelectorStateNotifier extends ValueNotifier<ScreenSelectorState> {
  /// Constructor of the [ScreenSelectorStateNotifier]. The [sourceTypes] can be used to set which source types are loaded first.
  ScreenSelectorStateNotifier({
    List<SourceType> sourceTypes = const [SourceType.Screen],
  }) : super(ScreenSelectorState._(sourceTypes: sourceTypes)) {
    _subscriptions.add(
      desktopCapturer.onAdded.stream.listen((source) {
        final map = Map<String, DesktopCapturerSource>.from(value.sources);
        map[source.id] = source;
        value = value._copyWith(sources: UnmodifiableMapView(map));
      }),
    );

    _subscriptions.add(
      desktopCapturer.onRemoved.stream.listen((source) {
        final map = Map<String, DesktopCapturerSource>.from(value.sources);
        map.remove(source.id);
        value = value._copyWith(sources: UnmodifiableMapView(map));
      }),
    );

    _subscriptions.add(
      desktopCapturer.onThumbnailChanged.stream.listen((source) {
        value = value._copyWith();
      }),
    );

    _getSources();
  }

  final List<StreamSubscription<DesktopCapturerSource>> _subscriptions = [];
  Timer? _timer;

  /// Update the sourceTypes. It's recommended to only show [SourceType.Screen] or
  /// [SourceType.Window], but it is possible to show both.
  void setSourceType(List<SourceType> sourceTypes) {
    if (listEquals(sourceTypes, value.sourceTypes)) return;

    value = value._copyWith(sources: {}, sourceTypes: sourceTypes);
    _getSources();
  }

  /// Updates the current selected source. Has no real effect other than the
  /// option to show the selection in the UI.
  void setSelectedSource(DesktopCapturerSource source) {
    value = value._copyWith(selectedSource: source);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  Future<void> _getSources() async {
    try {
      _timer?.cancel();
      final capturerSources =
          await desktopCapturer.getSources(types: value.sourceTypes);
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        desktopCapturer.updateSources(types: value.sourceTypes);
      });
      final sources = <String, DesktopCapturerSource>{};
      for (final capturerSource in capturerSources) {
        sources[capturerSource.id] = capturerSource;
      }

      value = value._copyWith(sources: sources);
    } catch (e) {
      screenShareLogger.e(() => '[_getSources] failed: $e');
    }
  }
}

@immutable
class ScreenSelectorState {
  const ScreenSelectorState._({
    this.sources = const {},
    required this.sourceTypes,
    this.selectedSource,
  });
  final Map<String, DesktopCapturerSource> sources;
  final List<SourceType> sourceTypes;
  final DesktopCapturerSource? selectedSource;

  ScreenSelectorState _copyWith({
    Map<String, DesktopCapturerSource>? sources,
    List<SourceType>? sourceTypes,
    DesktopCapturerSource? selectedSource,
  }) {
    return ScreenSelectorState._(
      sources: sources ?? this.sources,
      sourceTypes: sourceTypes ?? this.sourceTypes,
      selectedSource: selectedSource ?? this.selectedSource,
    );
  }
}
