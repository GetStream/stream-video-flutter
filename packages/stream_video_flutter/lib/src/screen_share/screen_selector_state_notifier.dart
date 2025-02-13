import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'screen_share_logger.dart';

class ScreenSelectorStateNotifier extends ValueNotifier<ScreenSelectorState> {
  ScreenSelectorStateNotifier() : super(const ScreenSelectorState._()) {
    Future.delayed(const Duration(milliseconds: 100), _getSources);
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
  }

  final List<StreamSubscription<DesktopCapturerSource>> _subscriptions = [];
  Timer? _timer;

  void setSourceType(List<SourceType> sourceTypes) {
    if (listEquals(sourceTypes, value.sourceTypes)) return;

    value = value._copyWith(sources: {}, sourceTypes: sourceTypes);
    _getSources();
  }

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
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    this.sourceTypes = const [SourceType.Screen],
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
