import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/sfu_extensions.dart';
import '../../webrtc/rtc_manager.dart';
import '../state/call_state_notifier.dart';
import '../stats/stats_reporter.dart';
import '../stats/trace_tag.dart';
import '../stats/tracer.dart';
import 'session_signaling.dart';
import 'session_track_controller.dart';

/// Routes a session's SFU events, one at a time, to the media handler for
/// the event and then to the call state.
///
/// Events that arrive before [attachManager] is called are held back until
/// it is, then delivered in order.
@internal
class SfuEventRouter {
  SfuEventRouter({
    required this._stateManager,
    required this._rtcManager,
    required this._signaling,
    required this._tracks,
    required this._statsReporter,
    required this._tracer,
    required String logTag,
  }) : _logger = taggedLogger(tag: logTag);

  final CallStateNotifier _stateManager;
  final RtcManager? Function() _rtcManager;
  final SessionSignaling _signaling;
  final SessionTrackController _tracks;
  final StatsReporter? Function() _statsReporter;
  final Tracer _tracer;
  final TaggedLogger _logger;

  /// Handles one event at a time. A subscriber offer holds it while its
  /// answer is sent, so ICE candidates wait behind that request.
  final Lock _sfuEventsLock = Lock();

  BehaviorSubject<RtcManager>? _rtcManagerSubject;
  StreamSubscription<SfuEvent>? _eventsSubscription;

  /// The manager whose subscriber the last join response was applied against.
  RtcManager? _joinedRtcManager;

  /// Whether the manager subject is closed, or was never created.
  bool get isManagerSubjectClosed => _rtcManagerSubject?.isClosed ?? true;

  /// Starts routing [events], holding them back until [attachManager].
  /// Stops routing the events of an earlier call first.
  Future<void> listen(Stream<SfuEvent> events) async {
    await _eventsSubscription?.cancel();
    await _rtcManagerSubject?.close();

    final rtcManagerSubject = _rtcManagerSubject = BehaviorSubject();

    // Buffer sfu events until rtc manager is set
    final bufferedStream = events
        .takeWhile((_) => !rtcManagerSubject.hasValue)
        .buffer(rtcManagerSubject)
        .expand((event) => event);

    // Delay rest of the sfu events until rtc manager is set
    final delayedStream = Rx.combineLatest2(
      rtcManagerSubject,
      events,
      (_, event) => event,
    ).skip(1);

    // Handle buffered events and then listen to sfu events as normal
    _eventsSubscription = bufferedStream
        .mergeWith([delayedStream])
        .listen(onEvent);
  }

  /// Releases the events held back since [listen].
  void attachManager(RtcManager rtcManager) {
    _rtcManagerSubject!.add(rtcManager);
  }

  /// Forgets the manager the last join response was applied against.
  void forgetJoinedManager() => _joinedRtcManager = null;

  /// Stops routing events and closes the manager subject.
  Future<void> dispose() async {
    await _eventsSubscription?.cancel();
    await _rtcManagerSubject?.close();
  }

  /// Hands [event] to its media handler, then to the call state.
  Future<void> onEvent(SfuEvent event) async {
    _logger.log(event.logPriority, () => '[onSfuEvent] event: $event');

    await _sfuEventsLock.synchronized(() async {
      await _handleMedia(event);
      await _forwardToState(event);
    });
  }

  Future<void> _handleMedia(SfuEvent event) async {
    if (event is SfuSubscriberOfferEvent) {
      await _signaling.onSubscriberOffer(event);
    } else if (event is SfuIceTrickleEvent) {
      await _signaling.onRemoteIceCandidate(event);
    } else if (event is SfuParticipantLeftEvent) {
      await _onParticipantLeft(event);
    } else if (event is SfuTrackPublishedEvent) {
      _tracer.trace(TraceTag.trackPublished, event.toJson());
      await _tracks.onTrackPublished(event);
    } else if (event is SfuTrackUnpublishedEvent) {
      _tracer.trace(TraceTag.trackUnpublished, event.toJson());
      await _tracks.onTrackUnpublished(event);
    } else if (event is SfuChangePublishQualityEvent) {
      _tracer.trace(TraceTag.changePublishQuality, event.toJson());
      await _onPublishQualityChanged(event);
    } else if (event is SfuChangePublishOptionsEvent) {
      _tracer.trace(TraceTag.changePublishOptions, event.toJson());
      await _onPublishOptionsChanged(event);
    } else if (event is SfuIceRestartEvent) {
      await _signaling.onIceRestart(event);
    } else if (event is SfuGoAwayEvent) {
      _tracer.trace(TraceTag.goAway, event.toJson());
    } else if (event is SfuErrorEvent) {
      _tracer.trace(TraceTag.error, event.toJson());
    } else if (event is SfuCallEndedEvent) {
      _tracer.trace(TraceTag.callEnded, event.toJson());
    }
  }

  Future<void> _forwardToState(SfuEvent event) async {
    if (event is SfuJoinResponseEvent) {
      await _onJoinResponse(event);
    } else if (event is SfuParticipantJoinedEvent) {
      _stateManager.sfuParticipantJoined(event);
      await _rtcManager()?.flushPendingDecryptors();
    } else if (event is SfuParticipantUpdatedEvent) {
      _stateManager.sfuParticipantUpdated(event);
    } else if (event is SfuTrackPublishedEvent) {
      _stateManager.sfuTrackPublished(event);
      await _rtcManager()?.flushPendingDecryptors();
    } else if (event is SfuParticipantLeftEvent) {
      _stateManager.sfuParticipantLeft(event);
      _rtcManager()?.discardPendingDecryptors(
        event.participant.trackLookupPrefix,
      );
    } else if (event is SfuConnectionQualityChangedEvent) {
      _tracer.trace(TraceTag.connectionQualityChanged, event.toJson());
      _stateManager.sfuConnectionQualityChanged(event);
    } else if (event is SfuAudioLevelChangedEvent) {
      _stateManager.sfuUpdateAudioLevelChanged(event);
    } else if (event is SfuTrackUnpublishedEvent) {
      _stateManager.sfuTrackUnpublished(event);
    } else if (event is SfuDominantSpeakerChangedEvent) {
      _stateManager.sfuDominantSpeakerChanged(event);
    } else if (event is SfuPinsUpdatedEvent) {
      _stateManager.sfuPinsUpdated(event.pins);
    } else if (event is SfuInboundStateNotificationEvent) {
      _tracer.trace(TraceTag.inboundVideoState, event.toJson());
      _stateManager.sfuInboundStateNotification(event);
    }
  }

  /// Applies a join response. The subscriber counts as reused only for a
  /// reconnect on the manager the last join response was applied against.
  Future<void> _onJoinResponse(SfuJoinResponseEvent event) async {
    final manager = _rtcManager();
    _stateManager.sfuJoinResponse(
      event,
      subscriberReused:
          event.isReconnected &&
          manager != null &&
          identical(manager, _joinedRtcManager),
    );
    _joinedRtcManager = manager;
    // The participant list just landed, so tracks that arrived before it
    // can finally resolve a user id and attach their decryptor.
    await _rtcManager()?.flushPendingDecryptors();
  }

  Future<void> _onParticipantLeft(SfuParticipantLeftEvent event) async {
    _logger.v(() => '[onParticipantLeft] event: $event');
    final participant = event.participant;
    final trackIdPrefix = participant.trackLookupPrefix;
    await _rtcManager()?.removeSubscriber(trackIdPrefix);
  }

  Future<void> _onPublishQualityChanged(
    SfuChangePublishQualityEvent event,
  ) async {
    _logger.d(() => '[onPublishQualityChanged] event: $event');

    final usedCodec =
        _statsReporter()?.currentMetrics?.publisher?.videoCodec?.firstOrNull;

    for (final videoSender in event.videoSenders) {
      await _rtcManager()?.onPublishQualityChanged(videoSender, usedCodec);
    }
  }

  Future<void> _onPublishOptionsChanged(
    SfuChangePublishOptionsEvent event,
  ) async {
    _logger.d(() => '[_onPublishOptionsChanged] event: $event');

    return await _rtcManager()?.onPublishOptionsChanged(event.publishOptions);
  }
}
