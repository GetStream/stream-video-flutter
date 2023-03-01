import 'dart:async';

import 'package:logging/logging.dart';

import '../stream_video.dart';
import 'call_permission.dart';
import 'coordinator/models/coordinator_events.dart';
import 'internal/_instance_holder.dart';
import 'models/call_device.dart';
import 'models/call_metadata.dart';
import 'push_notification/no_op_push_notification.dart';
import 'shared_emitter.dart';
import 'stream_video_impl.dart';
import 'token/token_manager.dart';
import 'utils/none.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

typedef PushNotificationFactory = Future<PushNotificationManager> Function(
  StreamVideo,
);

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.

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
    'https://video-edge-frankfurt-ce1.stream-io-api.com/video';
const _defaultCoordinatorWsUrl =
    'wss://video-edge-frankfurt-ce1.stream-io-api.com/video/connect';

/// The client responsible for handling config and maintaining calls
abstract class StreamVideo {
  factory StreamVideo(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
    PushNotificationFactory pushNotificationFactory =
        defaultPushNotificationManager,
  }) {
    return StreamVideoImpl(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
      pushNotificationFactory: pushNotificationFactory,
    );
  }
  static final InstanceHolder _instanceHolder = InstanceHolder();

  UserInfo? get currentUser;

  SharedEmitter<CoordinatorEvent> get events;

  void Function(CallCreated)? onCallCreated;

  /// Connects the [user] to the Stream Video service.
  Future<Result<None>> connectUser(
    UserInfo user, {
    Token? token,
    TokenProvider? provider,
  });

  /// Disconnects the [user] from the Stream Video service.
  Future<Result<None>> disconnectUser();

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
    void Function(CallReceivedOrCreated)? onReceivedOrCreated,
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
    required String eventType,
    required Map<String, Object> extraData,
  });

  // TODO replace with domain users
  Future<Result<List<CallUser>>> queryUsers({
    required StreamCallCid callCid,
    required Set<String> userIds,
  });

  Future<Result<None>> inviteUsers({
    required String callCid,
    required List<UserInfo> users,
  });

  Future<Result<None>> requestPermissions({
    required StreamCallCid callCid,
    required List<CallPermission> permissions,
  });

  Future<Result<None>> updateUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    List<CallPermission> grantPermissions = const [],
    List<CallPermission> revokePermissions = const [],
  });

  Future<Result<None>> startRecording(StreamCallCid callCid);

  Future<Result<None>> stopRecording(StreamCallCid callCid);

  Future<Result<CallDevice>> createDevice({
    required String token,
    required String pushProviderId,
  });

  Future<bool> handlePushNotification(Map<String, dynamic> payload);

  Future<CallCreated?> consumeIncomingCall();

  static void init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.OFF,
    LogHandlerFunction logHandlerFunction = _defaultLogHandler,
    PushNotificationFactory pushNotificationFactory =
        defaultPushNotificationManager,
  }) {
    _instanceHolder.init(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
      pushNotificationFactory: pushNotificationFactory,
    );
  }

  /// The singleton instance of the Stream Video client.
  static StreamVideo get instance {
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

/// Default log handler function for the [StreamVideoImpl] logger.
void _defaultLogHandler(LogRecord record) {
  print(
    '${record.time} '
    '${_levelEmojiMapper[record.level] ?? record.level.name} '
    '[${record.loggerName}] ${record.message} ',
  );
  if (record.error != null) print(record.error);
  if (record.stackTrace != null) print(record.stackTrace);
}

extension StreamVideoX on StreamVideo {
  /// Connects the [user] to the Stream Video service.
  Future<Result<None>> connectUserWithToken(
    UserInfo user,
    Token token,
  ) {
    return connectUser(user, token: token);
  }

  /// Connects the [user] to the Stream Video service.
  Future<Result<None>> connectUserWithProvider(
    UserInfo user,
    TokenProvider provider,
  ) {
    return connectUser(user, provider: provider);
  }

  /// Grants the [permissions] to the [userId] in the [callCid].
  Future<Result<None>> grantUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    required List<CallPermission> permissions,
  }) {
    return updateUserPermissions(
      callCid: callCid,
      userId: userId,
      grantPermissions: permissions,
    );
  }

  /// Revokes the [permissions] from the [userId] in the [callCid].
  Future<Result<None>> revokeUserPermissions({
    required StreamCallCid callCid,
    required String userId,
    required List<CallPermission> permissions,
  }) {
    return updateUserPermissions(
      callCid: callCid,
      userId: userId,
      revokePermissions: permissions,
    );
  }
}
