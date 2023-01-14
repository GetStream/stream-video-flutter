import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart';
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/coordinator_client.dart';
import 'package:stream_video/src/coordinator_ws.dart';
import 'package:stream_video/src/core/rx_controller.dart';
import 'package:stream_video/src/core/video_error.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/latency_service/latency.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/token/token.dart';
import 'package:stream_video/src/token/token_manager.dart';
import 'package:stream_video/src/v2/coordinator/ws/coordinator_ws.dart';
import 'package:stream_video/src/v2/shared_emitter.dart';
import 'package:synchronized/synchronized.dart';
import 'package:stream_video/src/v2/coordinator/ws/mapper_extensions.dart';

import '../../protobuf/video/coordinator/event_v1/event.pb.dart';
import 'call/call.dart';
import 'call/call_impl.dart';
import 'coordinator/coordinator_client.dart';
import 'coordinator/ws/coordinator_events.dart';
import 'coordinator/ws/coordinator_socket_listener.dart';
import 'stream_video_v2_impl.dart';
import 'utils/result.dart';
import 'utils/result_converters.dart';

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
  UserInfo? get currentUser;

  SharedEmitter<CoordinatorEventV2> get events;

  Function(CallV2)? onCallCreated;

  /// Connects the [user] to the Stream Video service.
  Future<void> connectUser(
    UserInfo user, {
    Token? token,
    TokenProvider? provider,
  });

  /// Disconnects the [user] from the Stream Video service.
  Future<void> disconnectUser();

  Future<Result<CallV2>> createCall({
    required String type,
    required String id,
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<CallV2>> getOrCreateCall({
    required String type,
    required String id,
    List<String> participantIds = const [],
    bool ringing = false,
  });

  static void init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = _InstanceHolder.defaultLogHandler,
  }) {
    _InstanceHolder.init(
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
    return _InstanceHolder.instance;
  }

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnectUser = false}) async {
    return _InstanceHolder.reset(disconnectUser: disconnectUser);
  }
}

class _InstanceHolder {
  @internal
  static StreamVideoV2? internalInstance;

  static void init(
    String apiKey, {
    String coordinatorRpcUrl = _defaultCoordinatorRpcUrl,
    String coordinatorWsUrl = _defaultCoordinatorWsUrl,
    int latencyMeasurementRounds = 3,
    Level logLevel = Level.ALL,
    LogHandlerFunction logHandlerFunction = defaultLogHandler,
  }) {
    if (_InstanceHolder.internalInstance != null) {
      throw Exception('''
        StreamVideo has already been initialised, use StreamVideo.instance to access the singleton instance.
        If you want to re-initialise the SDK, call StreamVideo.reset() first.
        If you want to use multiple instances of the SDK, use StreamVideo.new() instead.
        ''');
    }
    _InstanceHolder.internalInstance = StreamVideoV2Impl(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }

  /// Default log handler function for the [StreamVideoV2Impl] logger.
  static void defaultLogHandler(LogRecord record) {
    print(
      '${record.time} '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '[${record.loggerName}] ${record.message} ',
    );
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  }

  /// The singleton instance of the Stream Video client.
  static StreamVideoV2 get instance {
    final instance = internalInstance;
    if (instance == null) {
      throw Exception(
        'Please initialise Stream Video by calling StreamVideo.init()',
      );
    }
    return instance;
  }

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  static Future<void> reset({bool disconnectUser = false}) async {
    if (disconnectUser) {
      await internalInstance?.disconnectUser();
    }
    internalInstance = null;
  }
}
