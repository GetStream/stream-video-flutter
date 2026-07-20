import 'package:stream_video/stream_video.dart';

const _tag = 'StreamVideoSdk';

class StreamVideoSdk {
  StreamVideoSdk._();

  static Future<StreamVideo> initialize({
    required String apiKey,
    required UserInfo user,
    required UserToken userToken,
    StreamVideoOptions? options,
  }) async {
    if (StreamVideo.isInitialized()) {
      streamLog.d(_tag, () => '[initialize] reset instance');
      await StreamVideo.reset(disconnect: true);
    }
    return StreamVideo(
      apiKey,
      user: user.toUser(),
      userToken: userToken.rawValue,
      options: options,
    );
  }
}
