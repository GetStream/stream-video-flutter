import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' show CompositeSubscription;

import '../call/call.dart';
import '../call/call_ringing_state.dart';
import '../call/call_type.dart';
import '../models/call_metadata.dart';
import '../models/call_preferences.dart';
import '../push_notification/push_notification_manager.dart';
import '../utils/result.dart';

/// Handles ringing calls: the incoming ring from the coordinator, the native
/// call screen's accept, decline and end, the ringing pushes, and the
/// timer that rejects an unanswered incoming call.
///
/// Reached through `StreamVideo.ringing`. Implemented only by the SDK.
@sealed
abstract interface class RingingCallCoordinator {
  /// Listens to the ringing events of type [T] the push notification manager
  /// reports, or returns `null` when there is no manager.
  StreamSubscription<T>? onRingingEvent<T extends RingingEvent>(
    void Function(T event)? onEvent,
  );

  /// Accepts the call the user answered on the app's own notification while
  /// the app was not running, and answers whether it did.
  ///
  /// Connects first, and leaves joining to [onCallAccepted].
  Future<bool> consumeAndAcceptActiveCall({
    void Function(Call)? onCallAccepted,
    CallPreferences? callPreferences,
  });

  /// Helper method to observe core ringing events.
  /// Should be used as soon as the app is launched when handling incoming calls.
  CompositeSubscription observeCoreRingingEvents({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  });

  /// Helper method to observe core ringing events for background.
  /// Should be used in the background handler when handling incoming calls.
  CompositeSubscription observeCoreRingingEventsForBackground();

  /// Accepts the ringing call when the user accepts it on the native call
  /// screen, then joins it. [onCallAccepted] gets the accepted call.
  StreamSubscription<ActionCallAccept>? observeCallAcceptRingingEvent({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  });

  /// Checks that an incoming call the native call screen shows is still
  /// ringing, ending it there if not, and starts its auto-reject timer.
  StreamSubscription<ActionCallIncoming>? observeCallIncomingRingingEvent();

  /// Rejects the ringing call when the user declines it on the native call
  /// screen.
  StreamSubscription<ActionCallDecline>? observeCallDeclinedRingingEvent();

  /// Leaves or rejects the call when the user ends it on the native call
  /// screen.
  StreamSubscription<ActionCallEnded>? observeCallEndedRingingEvent();

  /// Checks incoming calls currently shown by the OS.
  ///
  /// On iOS, CallKit may show the incoming call UI before Dart code runs,
  /// so ringing events can be missed. This inspects all displayed calls:
  /// - Still-ringing calls are verified so dismissed flows are ended.
  /// - Calls already answered but not picked up by the app are accepted and
  ///   joined. **iOS only** - on Android a call answered from the app's own
  ///   notification is picked up by [consumeAndAcceptActiveCall] instead.
  ///
  /// Called automatically by [observeCoreRingingEvents], which passes its own
  /// [onCallAccepted] and [acceptCallPreferences] on.
  Future<void> verifyDisplayedIncomingCalls({
    void Function(Call)? onCallAccepted,
    CallPreferences? acceptCallPreferences,
  });

  /// Whether the call with [cid] was accepted on this device.
  bool isCallAcceptedOnThisDevice(String cid);

  /// This method is used to handle incoming call notifications.
  /// It will show an incoming call notification if the call is ringing.
  /// It will show a missed call notification if the call is missed.
  ///
  /// Returns `true` if the notification was handled, `false` otherwise.
  Future<bool> handleRingingFlowNotifications(
    Map<String, dynamic> payload, {
    bool handleMissedCall = true,
  });

  /// Reads the call's ringing state for the current user: still ringing,
  /// accepted, rejected or ended. It does not ring the call.
  ///
  /// A call that can't be read counts as [CallRingingState.ended].
  Future<CallRingingState> getCallRingingState({
    required StreamCallType callType,
    required String id,
  });

  /// Returns the [Call] for an incoming VoIP call. A [Call] already built for
  /// the same ringing flow is reused, with [preferences] applied to it.
  ///
  /// Pass [metadata] when the caller already fetched the call state to avoid
  /// requesting it a second time.
  Future<Result<Call>> consumeIncomingCall({
    required String uuid,
    required String cid,
    CallPreferences? preferences,
    CallMetadata? metadata,
  });
}
