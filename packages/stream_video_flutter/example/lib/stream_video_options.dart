import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:stream_video/stream_video.dart';

mixin DefaultVideoOptions {
  static StreamVideoOptions get remote {
    return const StreamVideoOptions();
  }

  static StreamVideoOptions get local {
    return const StreamVideoOptions(
      coordinatorRpcUrl: 'http://10.0.0.53:3030/video',
      coordinatorWsUrl: 'ws://10.0.0.53:8800/video/connect',
    );
  }

  static StreamVideoOptions get localhost {
    if (kIsWeb) {
      return _web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const StreamVideoOptions _web = StreamVideoOptions(
    coordinatorRpcUrl: 'http://localhost:3030/video',
    coordinatorWsUrl: 'ws://localhost:8800/video/connect',
  );

  static const StreamVideoOptions _android = StreamVideoOptions(
    coordinatorRpcUrl: 'http://10.0.2.2:3030/video',
    coordinatorWsUrl: 'ws://10.0.2.2:8800/video/connect',
  );

  static const StreamVideoOptions _ios = StreamVideoOptions(
    coordinatorRpcUrl: 'http://localhost:3030/video',
    coordinatorWsUrl: 'ws://localhost:8800/video/connect',
  );
}
