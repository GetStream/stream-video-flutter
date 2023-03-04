import 'package:equatable/equatable.dart';

class NotificationOptions with EquatableMixin {
  NotificationOptions({
    required this.callCid,
    this.content,
  });

  factory NotificationOptions.from({
    required String callCid,
    String? contentTitle,
    String? contentText,
  }) {
    return NotificationOptions(
      callCid: callCid,
      content: ContentOptions(
        title: contentTitle,
        text: contentText,
      ),
    );
  }

  final String callCid;
  ContentOptions? content;

  Map<String, Object?> toJson() {
    return {
      'call_cid': callCid,
      'content_title': content?.title,
      'content_text': content?.text,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [callCid, content];
}

class ContentOptions with EquatableMixin {
  String? title;
  String? text;

  ContentOptions({
    this.title,
    this.text,
  });

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [title, text];
}
