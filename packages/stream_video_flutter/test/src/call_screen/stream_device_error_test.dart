import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  StreamDeviceFailureReason reasonOf(Object cause) =>
      StreamDeviceError.from(cause).reason;

  group('StreamDeviceError.from', () {
    // The browser reports a DOMException name; flutter_webrtc a
    // PlatformException whose code and message vary by platform. Neither
    // offers a typed failure, so both are read for the words they share.
    test('reads a browser DOMException name', () {
      expect(
        reasonOf('NotAllowedError: Permission denied'),
        StreamDeviceFailureReason.permissionDenied,
      );
      expect(
        reasonOf('NotReadableError: Could not start video source'),
        StreamDeviceFailureReason.deviceBusy,
      );
      expect(
        reasonOf('NotFoundError: Requested device not found'),
        StreamDeviceFailureReason.noDevice,
      );
    });

    test('reads a PlatformException code and message', () {
      expect(
        reasonOf(PlatformException(code: 'Permission denied')),
        StreamDeviceFailureReason.permissionDenied,
      );
      expect(
        reasonOf(
          PlatformException(
            code: 'CAPTURE_ERROR',
            message: 'Camera is already in use',
          ),
        ),
        StreamDeviceFailureReason.deviceBusy,
      );
    });

    // What RtcMediaDeviceNotifier returns for a successful enumeration of an
    // empty list, which is the ordinary no-hardware case rather than a fault.
    test('classifies an empty enumeration as no device', () {
      expect(
        reasonOf('No devices found'),
        StreamDeviceFailureReason.noDevice,
      );
      expect(
        reasonOf('No devices found for kind: RtcMediaDeviceKind.videoInput'),
        StreamDeviceFailureReason.noDevice,
      );
    });

    test('falls back to unknown rather than guessing', () {
      final error = StreamDeviceError.from(StateError('something else'));

      expect(error.reason, StreamDeviceFailureReason.unknown);
      expect(error.isPermissionDenied, isFalse);
      expect(error.isDeviceBusy, isFalse);
      expect(error.isNoDevice, isFalse);
      expect(error.cause, isA<StateError>());
    });

    test('keeps the cause and stack trace it was given', () {
      final cause = StateError('nope');
      final error = StreamDeviceError.from(cause, StackTrace.empty);

      expect(error.cause, same(cause));
      expect(error.stackTrace, StackTrace.empty);
      expect('$error', contains('unknown'));
    });
  });
}
