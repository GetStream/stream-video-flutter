import 'package:equatable/equatable.dart';

class SfuCallGrants with EquatableMixin {
  SfuCallGrants({
    required this.canPublishAudio,
    required this.canPublishVideo,
    required this.canScreenShare,
  });

  final bool canPublishAudio;
  final bool canPublishVideo;
  final bool canScreenShare;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [canPublishAudio, canPublishVideo, canScreenShare];
}
