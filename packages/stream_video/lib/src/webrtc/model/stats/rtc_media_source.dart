import 'rtc_writable.dart';

abstract class RtcMediaSource implements RtcWritable {
  const RtcMediaSource({
    this.id,
    this.type,
    this.timestamp,
    this.kind,
    this.trackIdentifier,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? kind;
  final String? trackIdentifier;
}
