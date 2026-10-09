import 'dart:async';

import 'package:meta/meta.dart';

import '../core/client_state.dart';
import '../models/user_info.dart';
import '../push_notification/push_notification_manager.dart';
import '../stream_video.dart' show StreamVideo, StreamVideoOptions;
import '../telemetry/client_event_reporter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'call.dart';

/// What a [Call] needs from the client that made it. [StreamVideo]
/// implements it.
abstract interface class CallHost {
  /// The client's state: its user, and the active, incoming, outgoing and
  /// watched calls.
  ClientState get state;

  /// The user the calls are joined by.
  UserInfo get currentUser;

  StreamVideoOptions get options;

  String get apiKey;

  PushNotificationManager? get pushNotificationManager;

  /// Whether calls set up media. A client that only handles a push in the
  /// background does not.
  bool get setsUpMedia;

  @internal
  ClientEventReporter get clientEventReporter;

  /// Completes once the client has configured WebRTC for the app.
  @internal
  Completer<void> get webrtcInitializationCompleter;

  /// Clears the way for [call] to be accepted. `null` when there is nothing
  /// to clear.
  @internal
  Future<void>? prepareToAccept(Call call);

  @internal
  bool isAudioProcessorConfigured();

  @internal
  Future<Result<None>> setAudioProcessingEnabled(bool enabled);

  Future<Result<bool>> deviceSupportsAdvancedAudioProcessing();
}
