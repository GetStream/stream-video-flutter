// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/globals.dart';
import 'package:stream_video/src/core/connection_state.dart';
import 'package:stream_video/stream_video.dart';

class _FakeEnvironmentInfoProvider implements EnvironmentInfoProvider {
  _FakeEnvironmentInfoProvider(this._collect);

  final Future<VideoEnvironment> Function() _collect;

  @override
  Future<VideoEnvironment> collect() => _collect();
}

void main() {
  group('StreamVideo autoConnect after environment collection', () {
    late User user;
    late String userToken;
    final defaultProvider = EnvironmentInfoProvider.instance;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      user = User.regular(
        userId: 'test-user',
        name: 'Test User',
      );

      userToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU';
    });

    tearDown(() async {
      EnvironmentInfoProvider.instance = defaultProvider;
      await StreamVideo.reset();
    });

    Future<void> waitForInit() async {
      await pumpEventQueue(times: 20);
    }

    bool connectWasAttempted(ConnectionState connectionState) {
      return connectionState.isConnecting ||
          connectionState.isFailed ||
          connectionState.isConnected;
    }

    test('autoConnect runs when environment collection throws', () async {
      EnvironmentInfoProvider.instance = _FakeEnvironmentInfoProvider(() async {
        throw Exception('collect failed');
      });

      final streamVideo = StreamVideo.create(
        'test-api-key',
        user: user,
        userToken: userToken,
        options: StreamVideoOptions(autoConnect: true),
      );

      await waitForInit();

      expect(
        connectWasAttempted(streamVideo.state.connection.value),
        isTrue,
        reason: 'connect should be attempted after env collection fails',
      );
    });

    test(
      'autoConnect does not run when disabled despite env collection failure',
      () async {
        EnvironmentInfoProvider.instance = _FakeEnvironmentInfoProvider(() async {
          throw Exception('collect failed');
        });

        final streamVideo = StreamVideo.create(
          'test-api-key',
          user: user,
          userToken: userToken,
          options: StreamVideoOptions(autoConnect: false),
        );

        await waitForInit();

        expect(streamVideo.state.connection.value.isDisconnected, isTrue);
      },
    );

    test(
      'updates environment and autoConnects when collection succeeds',
      () async {
        EnvironmentInfoProvider.instance = _FakeEnvironmentInfoProvider(
          () async => const VideoEnvironment(
            sdkVersion: 'test-sdk',
            osName: 'test-os',
            appName: 'test-app',
          ),
        );

        final streamVideo = StreamVideo.create(
          'test-api-key',
          user: user,
          userToken: userToken,
          options: StreamVideoOptions(autoConnect: true),
        );

        await waitForInit();

        expect(videoEnvironmentManager.environment.sdkVersion, 'test-sdk');
        expect(videoEnvironmentManager.environment.osName, 'test-os');
        expect(videoEnvironmentManager.environment.appName, 'test-app');
        expect(
          connectWasAttempted(streamVideo.state.connection.value),
          isTrue,
        );
      },
    );
  });
}
