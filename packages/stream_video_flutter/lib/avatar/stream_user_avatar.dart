import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/theme/stream_avatar_theme.dart';
import 'package:stream_video_flutter/theme/stream_video_theme.dart';
import 'package:stream_video_flutter/utils/extensions.dart';

/// {@template imageWidgetBuilder}
/// Builder function used to build an image widget for the user avatar.
/// {@endtemplate}
typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
  ImageProvider imageProvider,
);

/// {@template placeholderWidgetBuilder}
/// Builder function used to build a placeholder widget.
/// {@endtemplate}
typedef PlaceholderWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
);

/// {@template errorWidgetBuilder}
/// Builder function used to build an error widget.
/// {@endtemplate}
typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
  Object error,
);

/// {@template fallbackWidgetBuilder}
/// Builder function used to build a widget with the user initials.
/// {@endtemplate}
typedef FallbackWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
);

/// {@template onUserAvatarTap}
/// The action to perform when the user avatar is tapped.
/// {@endtemplate}
typedef OnUserAvatarTap = void Function(UserInfo);

/// {@template onUserAvatarLongPress}
/// The action to perform when the user avatar is long-pressed.
/// {@endtemplate}
typedef OnUserAvatarLongPress = void Function(UserInfo);

/// {@template streamUserAvatar}
/// Displays a user's avatar.
/// {@endtemplate}
class StreamUserAvatar extends StatelessWidget {
  /// {@macro streamUserAvatar}
  const StreamUserAvatar({
    super.key,
    required this.user,
    this.selected = false,
    this.avatarTheme,
    this.onTap,
    this.onLongPress,
    this.imageBuilder,
    this.placeholderBuilder,
    this.errorBuilder,
    this.fallbackBuilder,
  });

  /// User whose avatar is to be displayed.
  final UserInfo user;

  /// Flag for if avatar is selected. Defaults to `false`.
  final bool selected;

  /// Theme for the avatar.
  final StreamAvatarTheme? avatarTheme;

  /// {@macro onUserAvatarTap}
  final OnUserAvatarTap? onTap;

  /// {@macro onUserAvatarLongPress}
  final OnUserAvatarLongPress? onLongPress;

  /// {@macro imageWidgetBuilder}
  final ImageWidgetBuilder? imageBuilder;

  /// {@macro placeholderWidgetBuilder}
  final PlaceholderWidgetBuilder? placeholderBuilder;

  /// {@macro errorWidgetBuilder}
  final ErrorWidgetBuilder? errorBuilder;

  /// {@macro fallbackWidgetBuilder}
  final FallbackWidgetBuilder? fallbackBuilder;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.imageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final streamChatTheme = StreamVideoTheme.of(context);
    final avatarTheme = this.avatarTheme ?? streamChatTheme.avatarTheme;

    Widget avatar = FittedBox(
      fit: BoxFit.cover,
      child: Container(
        constraints: avatarTheme.constraints,
        child: hasImage
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                imageUrl: imageUrl,
                errorWidget: (context, __, error) => errorBuilder != null
                    ? errorBuilder!(context, user, error)
                    : _InitialsUserAvatar(user: user, avatarTheme: avatarTheme),
                placeholder: placeholderBuilder != null
                    ? (context, __) => placeholderBuilder!(context, user)
                    : null,
                imageBuilder: (context, imageProvider) => imageBuilder != null
                    ? imageBuilder!(context, user, imageProvider)
                    : _ImageUserAvatar(
                        imageProvider: imageProvider, avatarTheme: avatarTheme),
              )
            : fallbackBuilder != null
                ? fallbackBuilder!(context, user)
                : _InitialsUserAvatar(user: user, avatarTheme: avatarTheme),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: avatarTheme.borderRadius +
            BorderRadius.circular(avatarTheme.selectionThickness),
        child: Container(
          constraints: avatarTheme.constraints,
          color: avatarTheme.selectionColor,
          child: Padding(
            padding: EdgeInsets.all(avatarTheme.selectionThickness),
            child: avatar,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(user) : null,
      onLongPress: onLongPress != null ? () => onLongPress!(user) : null,
      child: avatar,
    );
  }
}

/// {@template imageUserAvatar}
/// Displays an avatar with the user picture.
/// {@endtemplate}
class _ImageUserAvatar extends StatelessWidget {
  /// {@macro imageUserAvatar}
  const _ImageUserAvatar({
    required this.imageProvider,
    required this.avatarTheme,
  });

  /// The image to be painted into the decoration.
  final ImageProvider imageProvider;

  /// Theme for tha avatar
  final StreamAvatarTheme avatarTheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: avatarTheme.borderRadius,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// {@template initialsUserAvatar}
/// Displays an avatar with a color background and initials text.
/// {@endtemplate}
class _InitialsUserAvatar extends StatelessWidget {
  /// {@macro initialsUserAvatar}
  const _InitialsUserAvatar({
    required this.user,
    required this.avatarTheme,
  });

  /// User whose avatar is to be displayed.
  final UserInfo user;

  /// Theme for the avatar.
  final StreamAvatarTheme avatarTheme;

  @override
  Widget build(BuildContext context) {
    final initials =
        user.name.isNotEmpty ? user.name.initials() : user.id.initials();

    final avatarColorIndex = initials.hashCode.abs() % avatarColors.length;
    final avatarColor = avatarColors[avatarColorIndex];

    return DecoratedBox(
      decoration: BoxDecoration(
          color: avatarColor, borderRadius: avatarTheme.borderRadius),
      child: Center(
        child: Text(
          initials,
          style: avatarTheme.initialsTextStyle,
        ),
      ),
    );
  }

  /// The list of available colors for avatars.
  static const avatarColors = [
    Color(0xffb64e4e),
    Color(0xffB4774B),
    Color(0xffB4A34B),
    Color(0xff9AB44B),
    Color(0xff6EB44B),
    Color(0xff4BB453),
    Color(0xff4BB47F),
    Color(0xff4BB4AC),
    Color(0xff4B91B4),
    Color(0xff4B65B4),
    Color(0xff5C4BB4),
    Color(0xff884BB4),
    Color(0xffB44BB4),
    Color(0xffB44B88),
    Color(0xff926D73),
    Color(0xff6E8B91),
  ];
}
