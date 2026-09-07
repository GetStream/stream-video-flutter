// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Whether the call these settings describe is end-to-end encrypted.
bool isCallEncrypted(CallSettings settings) =>
    settings.encryption.mode == StreamEncryptionMode.autoOn;
