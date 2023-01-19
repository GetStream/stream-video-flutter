import 'dart:async';

import '../action/user_action.dart';
import '../call_state.dart';
import '../state_emitter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../webrtc/rtc_track.dart';
import 'call_settings.dart';

/// Represents a [CallV2] in which you can connect to.
abstract class CallV2 {
  String get callCid;

  StateEmitter<CallStateV2> get state;

  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  });

  Future<Result<None>> disconnect();

  RtcTrack? getTrack(String trackId);

  Future<Result<None>> apply(UserAction action);
}
