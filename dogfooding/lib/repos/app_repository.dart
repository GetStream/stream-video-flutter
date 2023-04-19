import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../env/env.dart';
import '../log_config.dart';

class AppRepository {
  factory AppRepository() => instance;

  AppRepository._internal();

  static final AppRepository instance = AppRepository._internal();

  StreamVideo? streamVideoClient;
  StreamChatClient? streamChatClient;

  Future<void> beginSession() async {
    await initStreamVideo();
    _initChat();
    return;
  }

  Future<StreamVideo> initStreamVideo() async {
    if (!StreamVideo.isInitialized()) {
      await _setupLogger();
      streamVideoClient = StreamVideo.init(
        Env.apiKey,
        coordinatorRpcUrl: Env.coordinatorRpcUrl,
        coordinatorWsUrl: Env.coordinatorWsUrl,
        logPriority: Priority.info,
      );
      // TODO throws MissingPluginException (No implementation found for method listen on channel stream_video_push_notification_events)
      streamVideoClient?.pushNotificationManager =
          await StreamVideoPushNotificationManager.create(
        streamVideoClient!,
      );
      return streamVideoClient!;
    } else {
      return streamVideoClient!;
    }
  }

  StreamChatClient _initChat() {
    streamChatClient = StreamChatClient(
      Env.apiKey,
      logLevel: Level.INFO,
    );
    return streamChatClient!;
  }

  Future<void> _setupLogger() async {
    const consoleLogger = ConsoleStreamLogger();
    final children = <StreamLogger>[consoleLogger];
    FileStreamLogger? fileLogger;
    if (!kIsWeb) {
      fileLogger = FileStreamLogger(
        AppFileLogConfig('1.0.0'),
        sender: (logFile) async {
          consoleLogger.log(
            Priority.debug,
            'DogFoodingApp',
            () => '[send] logFile: $logFile(${logFile.existsSync()})',
          );
          await Share.shareXFiles(
            [XFile(logFile.path)],
            subject: 'Share Logs',
            text: 'Stream Flutter Dogfooding Logs',
          );
        },
        console: consoleLogger,
      );
      children.add(fileLogger);
    }
    StreamLog().validator = (priority, _) => true;
    StreamLog().logger = CompositeStreamLogger(children);
  }

  Future<Channel> createChatChannel({
    required String channelId,
    required String channelName,
    required List<String> channelMembers,
  }) async {
    assert(streamChatClient != null);

    /// TODO: check if can use "livestream" channel type here.
    final channel = streamChatClient?.channel(
      'messaging',
      id: channelId,
      extraData: {
        'name': channelName,
        'members': channelMembers,
      },
    );

    await channel?.watch();
    return channel!;
  }

  Future<void> endSession() async {
    await streamVideoClient?.disconnectUser();
    await streamChatClient?.disconnectUser();
  }


}
