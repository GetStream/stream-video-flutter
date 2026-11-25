// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'logger/impl/test_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  StreamVideo create(AudioProcessor? processor) {
    return StreamVideo.create(
      'test-api-key',
      user: const User(id: 'test-user'),
      userToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
      options: StreamVideoOptions(
        autoConnect: false,
        audioProcessor: processor,
      ),
    );
  }

  tearDown(StreamVideo.reset);

  test('passes on what the audio processor reports', () async {
    final processor = _FakeAudioProcessor();
    final streamVideo = create(processor);

    final set = await streamVideo.setAudioProcessingEnabled(true);
    final enabled = await streamVideo.isAudioProcessingEnabled();
    final advanced = await streamVideo.deviceSupportsAdvancedAudioProcessing();

    expect(set.isSuccess, isTrue);
    expect(enabled.getDataOrNull(), isTrue);
    expect(advanced.getDataOrNull(), isFalse);
  });

  test('fails without an audio processor', () async {
    final streamVideo = create(null);

    final result = await streamVideo.isAudioProcessingEnabled();

    expect(result.isFailure, isTrue);
  });

  test('a processor that throws fails and is logged', () async {
    final logger = installRecordingLogger();
    final streamVideo = create(
      _FakeAudioProcessor(error: Exception('native failure')),
    );

    final result = await streamVideo.setAudioProcessingEnabled(true);

    expect(result.isFailure, isTrue);
    expect(logger.errors, [contains('native failure')]);
  });
}

final class _FakeAudioProcessor extends AudioProcessor {
  _FakeAudioProcessor({this.error});

  final Object? error;
  bool _enabled = false;

  @override
  Future<bool> isEnabled() async {
    if (error case final error?) throw error;
    return _enabled;
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    if (error case final error?) throw error;
    _enabled = enabled;
  }

  @override
  Future<bool> deviceSupportsAdvancedAudioProcessing() async {
    if (error case final error?) throw error;
    return false;
  }
}
