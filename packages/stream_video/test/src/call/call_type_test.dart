import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/call_type.dart';

void main() {
  group('CallType', () {
    group('CallTypeFactory', () {
      test('should create the default call types', () {
        expect(
          StreamCallType.fromString('default'),
          StreamCallType(),
        );
        expect(
          StreamCallType.fromString('livestream'),
          StreamCallType.liveStream(),
        );
        expect(
          StreamCallType.fromString('development'),
          StreamCallType.development(),
        );
        expect(
          StreamCallType.fromString('audio_room'),
          StreamCallType.audioRoom(),
        );
      });

      test('should return the custom call type', () {
        expect(
          StreamCallType.fromString('custom').value,
          StreamCallType.custom('custom').value,
        );
      });
    });
  });
}
