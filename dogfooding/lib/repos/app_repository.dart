import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as video;
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../env/env.dart';
import '../log_config.dart';
import '../src/utils/consts.dart';
import 'user_repository.dart';

class AppRepository {
  AppRepository();

  StreamChatClient? _streamChatClient;

  StreamChatClient get chatClient {
    final client = _streamChatClient;
    if (client == null) {
      throw Exception(
        'Please initialise Stream Chat by calling AppRepository.beginSession()',
      );
    }
    return client;
  }

  static Future<video.StreamVideo> ensureVideoInitialized({
    required video.User user,
    String? userToken,
    video.TokenLoader? tokenLoader,
    video.OnTokenUpdated? onTokenUpdated,
  }) async {
    if (!video.StreamVideo.isInitialized()) {
      final instance = video.StreamVideo(
        Env.apiKey,
        options: const video.StreamVideoOptions(
          logPriority: video.Priority.verbose,
          muteAudioWhenInBackground: true,
          muteVideoWhenInBackground: true,
          autoConnect: false,
        ),
        user: user,
        tokenLoader: tokenLoader,
        onTokenUpdated: onTokenUpdated,
      );

      await video.StreamVideo.instance.initPushNotificationManager(
        StreamVideoPushNotificationManager.factory(
          apnsProviderName: 'flutter-apn-video',
          firebaseProviderName: 'firebase',
        ),
      );

      return instance;
    } else {
      return video.StreamVideo.instance;
    }
  }

  Future<void> beginSession() async {
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
    const consoleLogger = video.ConsoleStreamLogger();
    final children = <video.StreamLogger>[consoleLogger];
    video.FileStreamLogger? fileLogger;
    if (!kIsWeb) {
      fileLogger = video.FileStreamLogger(
        AppFileLogConfig('1.0.0'),
        sender: (logFile) async {
          consoleLogger.log(
            video.Priority.debug,
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
    video.StreamLog().logger = video.CompositeStreamLogger(children);
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
    await video.StreamVideo.reset(disconnect: true);
    await _streamChatClient?.disconnectUser();
    _streamChatClient = null;
    await UserRepository.instance.clear();
  }
}
