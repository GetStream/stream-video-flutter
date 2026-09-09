// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// A feature of this sample app that not every platform can run.
///
/// The SDK widgets behind these are available everywhere; what is not is the
/// native pipeline they drive. Rather than let a control appear and then fail
/// when tapped, the app asks here first and leaves it out.
///
/// This lives in the sample rather than in the SDK on purpose: which features
/// an app offers, and what it does where they are unavailable — hide the
/// control, disable it, explain why — is the app's decision.
///
/// {@tool snippet}
///
/// ```dart
/// if (AppFeature.backgroundBlur.isSupported)
///   BlurToggle(effects: effectsManager),
/// ```
/// {@end-tool}
enum AppFeature {
  /// Blurring whatever is behind the user, in the lobby preview and in the
  /// call.
  ///
  /// `stream_video_filters` drives the platform's own segmentation pipeline,
  /// and only Android and iOS ship one — on desktop and web the filter is
  /// accepted and then does nothing.
  backgroundBlur({PlatformType.android, PlatformType.ios});

  const AppFeature(this.supportedPlatforms);

  /// The platforms that can run this feature.
  final Set<PlatformType> supportedPlatforms;

  /// Whether the platform the app is running on is one of them.
  bool get isSupported => supportedPlatforms.contains(CurrentPlatform.type);
}
