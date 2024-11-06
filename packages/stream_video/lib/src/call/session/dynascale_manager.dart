import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../stream_video.dart';
import '../../extensions/call_participant_state_ext.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_subscription_details.dart';
import '../../sfu/sfu_client.dart';
import '../../utils/debounce_buffer.dart';
import '../../webrtc/model/rtc_model_mapper_extensions.dart';
import '../state/call_state_notifier.dart';

class IncomingVideoSettings {
  IncomingVideoSettings({
    required this.enabled,
    required this.preferredResolution,
    required this.participants,
  });

  factory IncomingVideoSettings.default_() => IncomingVideoSettings(
        enabled: null,
        preferredResolution: null,
        participants: {},
      );

  final bool? enabled;
  final RtcVideoDimension? preferredResolution;
  final Map<String, ({bool enabled, RtcVideoDimension? preferredResolution})>
      participants;

  bool isParticipantVideoEnabled(String sessionId) {
    return participants[sessionId]?.enabled ?? enabled ?? true;
  }
}

const _debounceDuration = Duration(milliseconds: 200);

class DynascaleManager {
  DynascaleManager({
    required this.stateManager,
  });

  late final _logger = taggedLogger(tag: 'SV:DynascaleManager');

  final CallStateNotifier stateManager;
  late SfuClient sfuClient;
  late String sessionId;

  final BehaviorSubject<Map<String, SfuSubscriptionDetails>>
      _currentTrackSubscriptionsSubject = BehaviorSubject.seeded({});

  final BehaviorSubject<IncomingVideoSettings?>
      _videoTrackSubscriptionsOverrides = BehaviorSubject.seeded(null);

  IncomingVideoSettings? get incomingVideoSettings =>
      _videoTrackSubscriptionsOverrides.value;

  late final _saBuffer = DebounceBuffer<SubscriptionChange, Result<None>>(
    duration: _debounceDuration,
    onBuffered: updateSubscriptions,
    onCancel: () => Result.error('SubscriptionChange cancelled'),
  );

  void init({
    required SfuClient sfuClient,
    required String sessionId,
  }) {
    this.sfuClient = sfuClient;
    this.sessionId = sessionId;
  }

  Map<String, SfuSubscriptionDetails> getTrackSubscriptions({
    bool ignoreOverride = false,
  }) {
    final subscribtions = <String, SfuSubscriptionDetails>{};

    for (final entry in _currentTrackSubscriptionsSubject.value.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value.trackType == SfuTrackType.video && !ignoreOverride) {
        final enabled = incomingVideoSettings?.participants[key]?.enabled ??
            incomingVideoSettings?.enabled;

        final preferredResolution =
            incomingVideoSettings?.participants[key]?.preferredResolution ??
                incomingVideoSettings?.preferredResolution;

        if (enabled == null) {
          subscribtions[key] = value;
        } else if (enabled) {
          subscribtions[key] = value.copyWith(dimension: preferredResolution);
        }
      } else {
        subscribtions[key] = value;
      }
    }

    return subscribtions;
  }

  Future<Result<None>> setSubscriptions(
    List<SubscriptionChange> subscriptionChanges,
  ) async {
    _logger.d(
      () => '[setSubscriptions] subscriptionChanges: $subscriptionChanges',
    );

    final participants = stateManager.callState.callParticipants;
    final exclude = {SfuTrackType.video, SfuTrackType.screenShare};
    final subscriptions = <String, SfuSubscriptionDetails>{
      ...participants.getSubscriptions(exclude: exclude),
    };

    _logger.v(() => '[setSubscriptions] source: $subscriptions');

    for (final change in subscriptionChanges) {
      final changeSubscriptions = change.getSubscriptions();
      subscriptions.addAll(changeSubscriptions);
    }

    _logger.v(() => '[setSubscriptions] updated: $subscriptions');

    _currentTrackSubscriptionsSubject.add(subscriptions);

    final result = await sfuClient.update(
      sessionId: sessionId,
      subscriptions: getTrackSubscriptions().values,
    );

    _logger.v(() => '[setSubscriptions] result: $result');
    return result;
  }

  Future<Result<None>> updateSubscription(
    SubscriptionChange subscriptionChange,
  ) async {
    _logger.d(
      () => '[updateSubscription] subscriptionChange: $subscriptionChange',
    );

    if (!_saBuffer.isClosed) {
      return _saBuffer.post(subscriptionChange);
    }

    //Ignore the subscription change if the buffer is closed
    return const Result.success(none);
  }

  Future<Result<None>> updateSubscriptions(
    List<SubscriptionChange> changes,
  ) async {
    _logger.d(() => '[updateSubscriptions] changes: $changes');

    final participants = stateManager.callState.callParticipants;
    final subscriptions = <String, SfuSubscriptionDetails>{
      ...participants.getSubscriptions(),
    };

    _logger.v(() => '[updateSubscriptions] source: $subscriptions');

    for (final change in changes) {
      if (change.subscribed) {
        subscriptions[change.trackId!] = change.toSubscription();
      } else if (!change.subscribed) {
        subscriptions.remove(change.trackId);
      }
    }

    _logger.v(() => '[updateSubscriptions] updated: $subscriptions');
    _currentTrackSubscriptionsSubject.add(subscriptions);

    final result = await applyTrackSubscriptions();

    _logger.v(() => '[updateSubscriptions] result: $result');
    return result;
  }

  Future<Result<None>> applyTrackSubscriptions() async {
    final result = await sfuClient.update(
      sessionId: sessionId,
      subscriptions: getTrackSubscriptions().values,
    );

    return result;
  }

  void setVideoTrackSubscriptionOverrides({
    required VideoTrackSubscriptionOverride? override,
    List<String>? sessionIds,
  }) {
    _logger.d(
      () => '[setVideoTrackSubscriptionOverrides] sessionIds: $sessionIds, '
          'override: $override',
    );

    if (sessionIds == null) {
      if (override == null) {
        return _videoTrackSubscriptionsOverrides
            .add(IncomingVideoSettings.default_());
      }

      return _videoTrackSubscriptionsOverrides.add(
        IncomingVideoSettings(
          enabled: override.enabled,
          preferredResolution: override.dimension,
          participants: {},
        ),
      );
    }

    return _videoTrackSubscriptionsOverrides.add(
      IncomingVideoSettings(
        enabled: _videoTrackSubscriptionsOverrides.value?.enabled,
        preferredResolution:
            _videoTrackSubscriptionsOverrides.value?.preferredResolution,
        participants: {
          ...(_videoTrackSubscriptionsOverrides.value?.participants ?? {})
            ..removeWhere(
              (key, _) => override == null && sessionIds.contains(key),
            ),
          if (override != null)
            ...sessionIds.asMap().map(
                  (_, id) => MapEntry(
                    id,
                    (
                      enabled: override.enabled,
                      preferredResolution: override.dimension
                    ),
                  ),
                ),
        },
      ),
    );
  }

  Future<void> dispose() async {
    await _saBuffer.cancel();
    await _currentTrackSubscriptionsSubject.close();
  }
}

extension on SfuClient {
  Future<Result<None>> update({
    required String sessionId,
    required Iterable<SfuSubscriptionDetails> subscriptions,
  }) async {
    final result = await updateSubscriptions(
      sfu.UpdateSubscriptionsRequest(
        sessionId: sessionId,
        tracks: subscriptions.map(
          (it) => sfu.TrackSubscriptionDetails(
            userId: it.userId,
            sessionId: it.sessionId,
            trackType: it.trackType.toDTO(),
            dimension: it.dimension?.toDTO(),
          ),
        ),
      ),
    );

    return result.fold(
      failure: (it) => it,
      success: (it) {
        if (it.data.hasError()) {
          final error = it.data.error;
          return Result.error('${error.code} - ${error.message}');
        }
        return const Result.success(none);
      },
    );
  }
}
