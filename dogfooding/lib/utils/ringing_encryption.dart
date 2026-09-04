// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Supplies the shared key for a call the SDK joins on our behalf.
///
/// This app does not support encrypted ringing calls yet, so it always
/// declines. Answering an `auto-on` call without a key is rejected by Stream,
/// which is the honest outcome: joining with a made-up key would put the user
/// in a call where nothing decrypts.
///
/// The hook is wired up all the same, because this is where a real app answers.
Future<CallEncryptionKey?> resolveRingingEncryptionKey(
  CallEncryptionKeyRequest request,
) async => null;
