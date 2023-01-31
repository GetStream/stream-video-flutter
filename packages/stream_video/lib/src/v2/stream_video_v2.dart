import 'dart:async';

import 'package:logging/logging.dart';

import '../models/user_info.dart';
import '../token/token.dart';
import '../token/token_manager.dart';
import 'coordinator/models/coordinator_models.dart';
import 'coordinator/ws/coordinator_events.dart';
import 'internal/_instance_holder.dart';
import 'model/call_cid.dart';
import 'model/call_created.dart';
import 'model/call_joined.dart';
import 'model/call_received_created.dart';
import 'shared_emitter.dart';
import 'stream_video_v2_impl.dart';
import 'utils/none.dart';
import 'utils/result.dart';

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
  Level.SHOUT: '📣',
  Level.FINE: '🔍',
  Level.FINER: '🔎',
  Level.FINEST: '🔎',
  Level.CONFIG: '🔧',
};

const _defaultCoordinatorRpcUrl =
    'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc';
const _defaultCoordinatorWsUrl =
    'wss://wss-video-coordinator.oregon-v1.stream-io-video.com:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect';

/// The client responsible for handling config and maintaining calls
abstract class StreamVideoV2 {
  factory StreamVideoV2(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
  }) {
    return StreamVideoV2Impl(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }
  static final InstanceHolder _instanceHolder = InstanceHolder();

  UserInfo? get currentUser;

  SharedEmitter<CoordinatorEventV2> get events;

  void Function(CallCreated)? onCallCreated;

  /// Connects the [user] to the Stream Video service.
  Future<void> connectUser(
    UserInfo user, {
    Token? token,
    TokenProvider? provider,
  });

  /// Disconnects the [user] from the Stream Video service.
  Future<void> disconnectUser();

  Future<Result<CallCreated>> createCall({
    required StreamCallCid cid,
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<CallReceivedOrCreated>> getOrCreateCall({
    required StreamCallCid cid,
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<CallJoined>> joinCall({
    required StreamCallCid cid,
  });

  Future<Result<None>> acceptCall({
    required StreamCallCid cid,
  });

  Future<Result<None>> rejectCall({
    required StreamCallCid cid,
  });

  Future<Result<None>> cancelCall({
    required StreamCallCid cid,
  });

  Future<Result<None>> sendCustomEvent({
    required StreamCallCid cid,
    required List<int> dataJson,
    String? eventType,
  });

  // TODO replace with domain users
  Future<Result<List<CallUser>>> queryUsers({
    required Set<String> userIds,
  });

  static void init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.OFF,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
  }) {
    _instanceHolder.init(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }

  /// The singleton instance of the Stream Video client.
  static StreamVideoV2 get instance {
    return _instanceHolder.instance;
  }

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnectUser = false}) async {
    if (disconnectUser) {
      await _instanceHolder.instance.disconnectUser();
    }
    return _instanceHolder.reset();
  }

  /// Return if the singleton instance of the Stream Video Client has already
  /// been initialized.
  static bool isInitialized() {
    return _instanceHolder.isInitialized();
  }
}

/// Default log handler function for the [StreamVideoV2Impl] logger.
void _defaultLogHandler(LogRecord record) {
  print(
    '${record.time} '
    '${_levelEmojiMapper[record.level] ?? record.level.name} '
    '[${record.loggerName}] ${record.message} ',
  );
  if (record.error != null) print(record.error);
  if (record.stackTrace != null) print(record.stackTrace);
}
