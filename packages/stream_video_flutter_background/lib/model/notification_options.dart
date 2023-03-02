import 'package:equatable/equatable.dart';

class NotificationOptions with EquatableMixin {
  const NotificationOptions({
    required this.appId,
    required this.callCid,
    required this.contentTitle,
    required this.contentText,
  });

  final String appId;
  final String callCid;
  final String contentTitle;
  final String contentText;

  Map<String, Object> toJson() {
    return {
      'app_id': appId,
      'call_cid': callCid,
      'content_title': contentTitle,
      'content_text': contentText,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [appId, callCid, contentTitle, contentText];
}
