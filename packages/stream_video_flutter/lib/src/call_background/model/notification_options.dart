import 'package:equatable/equatable.dart';

class NotificationOptions with EquatableMixin {
  const NotificationOptions({
    this.content,
    this.avatar,
    this.useCustomLayout = false,
  });

  final NotificationContent? content;
  final NotificationAvatar? avatar;
  final bool useCustomLayout;

  Map<String, Object?> toJson() {
    return {
      'content': content?.toJson(),
      'avatar': avatar?.toJson(),
      'use_custom_layout': useCustomLayout,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [content, avatar, useCustomLayout];
}

class NotificationContent with EquatableMixin {
  const NotificationContent({
    this.title,
    this.text,
  });

  final String? title;
  final String? text;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'text': text,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [title, text];
}

class NotificationAvatar with EquatableMixin {
  const NotificationAvatar({
    required this.url,
    this.httpHeaders = const {},
  });

  final String url;
  final Map<String, String> httpHeaders;

  Map<String, Object?> toJson() {
    return {
      'url': url,
      'http_headers': httpHeaders,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [url, httpHeaders];
}
