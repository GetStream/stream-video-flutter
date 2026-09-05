// ignore_for_file: avoid_implementing_value_types

import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class MockCall extends Mock implements Call {}

class MockCallState extends Mock implements CallState {}

class MockCallParticipantState extends Mock implements CallParticipantState {}

class MockRtcMediaDeviceNotifier extends Mock
    implements RtcMediaDeviceNotifier {}

class MockStreamVideo extends Mock implements StreamVideo {
  // StreamVideo marks dispose as @mustBeOverridden.
  @override
  Future<Result<None>> dispose() async => const Result.success(none);
}

class MockCallCreatedData extends Mock implements CallCreatedData {}

class MockCallMetadata extends Mock implements CallMetadata {}

class MockCallSettings extends Mock implements CallSettings {}

class MockRtcLocalAudioTrack extends Mock implements RtcLocalAudioTrack {}

class MockRtcLocalCameraTrack extends Mock implements RtcLocalCameraTrack {}
