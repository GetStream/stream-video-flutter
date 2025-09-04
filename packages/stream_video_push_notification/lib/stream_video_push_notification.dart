/// Stream Video push notifications for incoming-call ringing.
///
/// Provides APIs to initialize and interact with platform-specific incoming
/// call notifications used by the Stream Video SDK.
/// - iOS: CallKit-based ringing UI and behavior.
/// - Android: full-screen/custom ringing notifications and background handling.
///
/// Use this package to configure push params, customize caller info, and ensure
/// required permissions (e.g. Android full-screen intent) for a reliable
/// ringing experience.
library stream_video_push_notification;

export 'package:flutter_callkit_incoming/entities/entities.dart'
    show IOSParams, AndroidParams, NotificationParams;

export 'src/stream_video_push_notification.dart'
    hide StreamTokenProvider, StreamCallKit;
export 'src/stream_video_push_params.dart';
