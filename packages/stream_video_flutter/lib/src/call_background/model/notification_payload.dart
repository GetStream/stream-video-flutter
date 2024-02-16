import 'package:equatable/equatable.dart';
import 'package:stream_video_flutter/src/call_background/model/notification_options.dart';

class NotificationPayload with EquatableMixin {
  const NotificationPayload({
    required this.callCid,
    this.options,
  });

  final String callCid;
  final NotificationOptions? options;

  Map<String, Object?> toJson() {
    return {
      'call_cid': callCid,
      'options': options?.toJson(),
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [callCid, options];
}
