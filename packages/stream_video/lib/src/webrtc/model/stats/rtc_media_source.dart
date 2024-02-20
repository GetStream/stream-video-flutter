import 'rtc_stats.dart';
import 'rtc_writable.dart';

abstract class RtcMediaSource extends RtcStats implements RtcWritable {
  const RtcMediaSource({
    super.id,
    super.type,
    super.timestamp,
    this.kind,
    this.trackIdentifier,
  });

  final String? kind;
  final String? trackIdentifier;
}
