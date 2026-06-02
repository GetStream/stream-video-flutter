import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

/// These tests guard against the WASM regression where JS numbers are always
/// surfaced to Dart as `double` (so an integer like `1` arrives as `1.0`).
///
/// Before the fix the stats models assigned `value['x']` straight into an
/// `int?` field, which throws a `TypeError` on WASM whenever the runtime hands
/// back a `double`. The models now go through `(value['x'] as num?)?.toInt()`,
/// which has to accept both `int` and `double` representations.
void main() {
  group('RtcCodec.fromJson int casting', () {
    test('parses integer-typed values', () {
      final codec = RtcCodec.fromJson({
        'id': 'RTCCodec_0',
        'payloadType': 101,
        'clockRate': 90000,
      });

      expect(codec, isNotNull);
      expect(codec!.payloadType, 101);
      expect(codec.payloadType, isA<int>());
      expect(codec.clockRate, 90000);
      expect(codec.clockRate, isA<int>());
    });

    test('parses double-typed values coming from WASM (1.0 -> 1)', () {
      final codec = RtcCodec.fromJson({
        'id': 'RTCCodec_0',
        'payloadType': 1.0,
        'clockRate': 90000.0,
      });

      expect(codec, isNotNull);
      expect(codec!.payloadType, 1);
      expect(codec.payloadType, isA<int>());
      expect(codec.clockRate, 90000);
      expect(codec.clockRate, isA<int>());
    });

    test('null/missing values stay null', () {
      final codec = RtcCodec.fromJson({'id': 'RTCCodec_0'});

      expect(codec, isNotNull);
      expect(codec!.payloadType, isNull);
      expect(codec.clockRate, isNull);
    });
  });

  group('RtcVideoSource.fromJson int casting', () {
    test('handles a mix of int and double sources', () {
      final source = RtcVideoSource.fromJson({
        'id': 'RTCVideoSource_5',
        'width': 1280, // int
        'height': 720.0, // double (WASM style)
        'framesPerSecond': 30.0, // stays double
        'frames': 2271.0, // double (WASM style)
      });

      expect(source, isNotNull);
      expect(source!.width, 1280);
      expect(source.width, isA<int>());
      expect(source.height, 720);
      expect(source.height, isA<int>());
      expect(source.frames, 2271);
      expect(source.frames, isA<int>());

      // framesPerSecond is intentionally a double and must remain one.
      expect(source.framesPerSecond, 30.0);
      expect(source.framesPerSecond, isA<double>());
    });
  });

  group('RtcIceCandidate.fromJson int casting', () {
    test('parses port and priority from doubles', () {
      final candidate = RtcIceCandidate.fromJson({
        'id': 'RTCIceCandidate_0',
        'port': 33389.0,
        'priority': 2122063615.0,
      });

      expect(candidate, isNotNull);
      expect(candidate!.port, 33389);
      expect(candidate.port, isA<int>());
      expect(candidate.priority, 2122063615);
      expect(candidate.priority, isA<int>());
    });
  });

  group('RtcInboundRtpVideoStream.fromJson int casting', () {
    test('casts every integer field while keeping doubles intact', () {
      final stream = RtcInboundRtpVideoStream.fromJson({
        'id': 'RTCInboundRTPVideoStream_491507150',
        // integer fields delivered as doubles (WASM style)
        'qpSum': 3446.0,
        'nackCount': 0.0,
        'firCount': 0.0,
        'pliCount': 3.0,
        'packetsLost': 0.0,
        'keyFramesDecoded': 1.0,
        'frameHeight': 540.0,
        'frameWidth': 960.0,
        'framesDropped': 1.0,
        'framesReceived': 127.0,
        'framesDecoded': 126.0,
        'ssrc': 491507150.0,
        'headerBytesReceived': 10200.0,
        'jitterBufferEmittedCount': 126.0,
        'bytesReceived': 519288.0,
        'packetsReceived': 510.0,
        // genuine double fields
        'jitter': 0.007,
        'framesPerSecond': 29.0,
        'jitterBufferDelay': 4.69,
      });

      expect(stream, isNotNull);
      expect(stream!.qpSum, 3446);
      expect(stream.frameHeight, 540);
      expect(stream.frameWidth, 960);
      expect(stream.framesReceived, 127);
      expect(stream.framesDecoded, 126);
      expect(stream.ssrc, 491507150);
      expect(stream.bytesReceived, 519288);
      expect(stream.packetsReceived, 510);

      // All of these must be real ints, not doubles.
      expect(stream.qpSum, isA<int>());
      expect(stream.frameHeight, isA<int>());
      expect(stream.frameWidth, isA<int>());
      expect(stream.ssrc, isA<int>());
      expect(stream.bytesReceived, isA<int>());

      // Double fields are untouched.
      expect(stream.jitter, 0.007);
      expect(stream.framesPerSecond, 29.0);
      expect(stream.jitterBufferDelay, 4.69);
    });
  });

  group('RtcRemoteInboundRtpVideoStream.fromJson int casting', () {
    test('parses large ssrc and counters from doubles', () {
      final stream = RtcRemoteInboundRtpVideoStream.fromJson({
        'id': 'RTCRemoteInboundRTPVideoStream_3784832368',
        // ssrc can exceed the 32-bit signed range, so the double round-trip
        // matters here.
        'ssrc': 3784832368.0,
        'roundTripTimeMeasurements': 72.0,
        'packetsLost': 0.0,
        'roundTripTime': 0.162,
        'fractionLost': 0.0,
      });

      expect(stream, isNotNull);
      expect(stream!.ssrc, 3784832368);
      expect(stream.ssrc, isA<int>());
      expect(stream.roundTripTimeMeasurements, 72);
      expect(stream.roundTripTimeMeasurements, isA<int>());
      expect(stream.packetsLost, 0);
      expect(stream.packetsLost, isA<int>());
      expect(stream.roundTripTime, 0.162);
    });
  });

  group('edge cases', () {
    test('fractional doubles are truncated by toInt()', () {
      // toInt() truncates towards zero, documenting the behaviour rather than
      // rounding. Real stats are whole numbers, but this guards the contract.
      final codec = RtcCodec.fromJson({
        'id': 'RTCCodec_0',
        'payloadType': 1.9,
        'clockRate': 90000.9,
      });

      expect(codec!.payloadType, 1);
      expect(codec.clockRate, 90000);
    });

    test('zero is preserved for both int and double inputs', () {
      final fromInt = RtcVideoSource.fromJson({'id': 'a', 'frames': 0});
      final fromDouble = RtcVideoSource.fromJson({'id': 'a', 'frames': 0.0});

      expect(fromInt!.frames, 0);
      expect(fromInt.frames, isA<int>());
      expect(fromDouble!.frames, 0);
      expect(fromDouble.frames, isA<int>());
    });

    test('fromJson returns null for non-map input', () {
      expect(RtcCodec.fromJson(null), isNull);
      expect(RtcVideoSource.fromJson('not a map'), isNull);
      expect(RtcInboundRtpVideoStream.fromJson(42), isNull);
    });
  });
}
