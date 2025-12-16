import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/location/location_service.dart';
import 'package:stream_video/src/logger/stream_log.dart';
import 'package:stream_video/src/logger/stream_logger.dart';

import '../logger/impl/test_logger.dart';

class MockHttpClient extends Mock implements http.Client {}

class UriFake extends Fake implements Uri {}

void main() {
  late LocationService service;
  late MockHttpClient mockClient;

  setUpAll(() {
    StreamLog().logger = TestStreamLogger();
    StreamLog().priority = Priority.verbose;
    registerFallbackValue(UriFake());
  });

  setUp(() {
    mockClient = MockHttpClient();
    service = LocationService(client: mockClient);
  });

  group('LocationService', () {
    test(
      'returns location code when request succeeds on first attempt',
      () async {
        // Given
        final response = http.Response(
          '',
          200,
          headers: {
            'x-amz-cf-pop': 'AMS1-P2',
          },
        );
        when(() => mockClient.head(any())).thenAnswer((_) async => response);

        // When
        final result = await service.getLocation();

        // Then
        expect(result, equals('AMS'));
        verify(() => mockClient.head(any())).called(1);
      },
    );

    test(
      'returns location code when request succeeds after retry',
      () async {
        // Given
        var callCount = 0;
        when(() => mockClient.head(any())).thenAnswer((_) async {
          callCount++;
          if (callCount < 2) {
            throw Exception('Network error');
          }
          return http.Response(
            '',
            200,
            headers: {
              'x-amz-cf-pop': 'FRA1-C1',
            },
          );
        });

        // When
        final result = await service.getLocation();

        // Then
        expect(result, equals('FRA'));
        verify(() => mockClient.head(any())).called(2);
      },
    );

    test(
      'returns ERR after all retry attempts fail',
      () async {
        // Given
        when(
          () => mockClient.head(any()),
        ).thenThrow(Exception('Network error'));

        // When
        final result = await service.getLocation();

        // Then
        expect(result, equals('ERR'));
        verify(() => mockClient.head(any())).called(3);
      },
    );

    test(
      'returns ERR when header is missing',
      () async {
        // Given
        final response = http.Response('', 200, headers: {});
        when(() => mockClient.head(any())).thenAnswer((_) async => response);

        // When
        final result = await service.getLocation(maxAttempts: 1);

        // Then
        expect(result, equals('ERR'));
      },
    );

    test(
      'returns ERR on timeout and retries',
      () async {
        // Given
        when(() => mockClient.head(any())).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => http.Response('', 200, headers: {'x-amz-cf-pop': 'AMS1'}),
          ),
        );

        // When
        final result = await service.getLocation(
          timeout: const Duration(milliseconds: 10),
          maxAttempts: 2,
        );

        // Then
        expect(result, equals('ERR'));
        verify(() => mockClient.head(any())).called(2);
      },
    );

    test(
      'respects maxAttempts parameter',
      () async {
        // Given
        when(
          () => mockClient.head(any()),
        ).thenThrow(Exception('Network error'));

        // When
        final result = await service.getLocation(maxAttempts: 5);

        // Then
        expect(result, equals('ERR'));
        verify(() => mockClient.head(any())).called(5);
      },
    );

    test(
      'succeeds on last attempt',
      () async {
        // Given
        var callCount = 0;
        when(() => mockClient.head(any())).thenAnswer((_) async {
          callCount++;
          if (callCount < 3) {
            throw Exception('Network error');
          }
          return http.Response(
            '',
            200,
            headers: {
              'x-amz-cf-pop': 'SIN1-P1',
            },
          );
        });

        // When
        final result = await service.getLocation();

        // Then
        expect(result, equals('SIN'));
        verify(() => mockClient.head(any())).called(3);
      },
    );
  });
}
