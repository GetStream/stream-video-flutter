import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../env/env.dart';
import '../log_config.dart';
import '../src/utils/consts.dart';
import 'user_repository.dart';

class AppRepository {
  AppRepository();

  StreamVideo? _streamVideoClient;
  StreamChatClient? _streamChatClient;

  StreamVideo get videoClient {
    final client = _streamVideoClient;
    if (client == null) {
      throw Exception(
        'Please initialise Stream Video by calling AppRepository.beginSession()',
      );
    }

    return client;
  }

  StreamChatClient get chatClient {
    final client = _streamChatClient;
    if (client == null) {
      throw Exception(
        'Please initialise Stream Chat by calling AppRepository.beginSession()',
      );
    }
    return client;
  }

  static Future<StreamVideo> initStreamVideo() async {
    if (!StreamVideo.isInitialized()) {
      final streamVideoClient = StreamVideo.init(
        Env.apiKey,
        logPriority: Priority.info,
        muteAudioWhenInBackground: true,
        muteVideoWhenInBackground: true,
      );
      await streamVideoClient.initPushNotificationManager(
        StreamVideoPushNotificationManager.factory(
          apnsProviderName: 'flutter-apn-video',
          firebaseProviderName: 'firebase',
        ),
      );
      return streamVideoClient;
    } else {
      return StreamVideo.instance;
    }
  }

  Future<void> beginSession() async {
    _streamVideoClient = await initStreamVideo();
    unawaited(_setupLogger());
    _streamChatClient = initStreamChat();
  }

  StreamChatClient initStreamChat() {
    return StreamChatClient(
      Env.apiKey,
      logLevel: Level.INFO,
    );
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
    StreamLog().logger = CompositeStreamLogger(children);
  }

  Future<Channel> createChatChannel({
    required String channelId,
  }) async {
    final channel = chatClient.channel(
      kMessageChannelType,
      id: channelId,
    );

    await channel.watch();
    return channel;
  }

  Future<void> endSession() async {
    await _streamVideoClient?.disconnectUser();
    _streamVideoClient = null;
    await _streamChatClient?.disconnectUser();
    _streamChatClient = null;
    await UserRepository.instance.clear();
  }
}
