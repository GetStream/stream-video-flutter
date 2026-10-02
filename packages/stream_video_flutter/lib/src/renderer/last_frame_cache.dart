import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';

/// The last picture a video track showed before its renderer went away.
@immutable
class LastVideoFrame {
  /// Creates a last video frame.
  const LastVideoFrame({required this.image, this.mirror = false});

  /// The captured picture.
  final ui.Image image;

  /// Whether [image] still has to be mirrored when it is drawn.
  final bool mirror;
}

/// Keeps the last frame of each video track of a call, so a track that is
/// subscribed again can show where it left off instead of a placeholder.
///
/// Holds at most [maxEntries] frames, dropping the least recently used.
class LastVideoFrameCache extends ChangeNotifier {
  /// Creates a last video frame cache.
  LastVideoFrameCache({this.maxEntries = 32});

  static final _perCall = Expando<LastVideoFrameCache>();

  /// The cache belonging to [call].
  // ignore: prefer_constructors_over_static_methods
  static LastVideoFrameCache of(Call call) =>
      _perCall[call] ??= LastVideoFrameCache();

  /// The key a track's frame is stored under.
  static String keyFor(
    CallParticipantState participant,
    SfuTrackTypeVideo trackType,
  ) => '${participant.uniqueParticipantKey}-$trackType';

  /// The most frames kept at once.
  final int maxEntries;

  // Insertion-ordered, so the first key is the least recently used.
  final _frames = <String, LastVideoFrame>{};

  /// The frame stored under [key], if any.
  LastVideoFrame? operator [](String key) {
    final frame = _frames.remove(key);
    if (frame != null) _frames[key] = frame;
    return frame;
  }

  /// Stores [frame] under [key], replacing what was there.
  void put(String key, LastVideoFrame frame) {
    _frames.remove(key)?.image.dispose();
    _frames[key] = frame;
    while (_frames.length > maxEntries) {
      final oldest = _frames.keys.first;
      _frames.remove(oldest)?.image.dispose();
    }
    _notify();
  }

  /// Drops the frame stored under [key].
  void remove(String key) {
    final frame = _frames.remove(key);
    if (frame == null) return;
    frame.image.dispose();
    _notify();
  }

  // Frames are captured as renderers leave the tree, mid-frame; listeners
  // rebuild once that frame is over.
  void _notify() {
    final scheduler = SchedulerBinding.instance;
    if (scheduler.schedulerPhase == SchedulerPhase.idle) {
      notifyListeners();
    } else {
      scheduler.addPostFrameCallback((_) => notifyListeners());
    }
  }

  @override
  void dispose() {
    for (final frame in _frames.values) {
      frame.image.dispose();
    }
    _frames.clear();
    super.dispose();
  }
}

/// Shows the last frame stored under [frameKey] in [cache], or
/// [placeholderBuilder] while there is none.
class LastVideoFrameOrPlaceholder extends StatelessWidget {
  /// Creates a last video frame or placeholder.
  const LastVideoFrameOrPlaceholder({
    super.key,
    required this.cache,
    required this.frameKey,
    required this.placeholderBuilder,
    this.videoFit,
  });

  /// Where the frame is looked up.
  final LastVideoFrameCache cache;

  /// The key the frame is stored under.
  final String frameKey;

  /// Builds what is shown while there is no frame.
  final WidgetBuilder placeholderBuilder;

  /// How the frame fills the space it is given.
  final VideoFit? videoFit;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cache,
      builder: (context, _) {
        final frame = cache[frameKey];
        if (frame == null) return placeholderBuilder(context);

        final image = frame.image;
        final fit = switch (videoFit ?? defaultVideoFit) {
          VideoFit.cover => BoxFit.cover,
          VideoFit.contain => BoxFit.contain,
          VideoFit.adaptive =>
            image.width >= image.height ? BoxFit.cover : BoxFit.contain,
        };

        // RawImage disposes what it is handed, so it gets its own handle.
        return SizedBox.expand(
          child: Transform.flip(
            flipX: frame.mirror,
            child: RawImage(image: image.clone(), fit: fit),
          ),
        );
      },
    );
  }
}
