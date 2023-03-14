import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// Builder function used to build an image widget for the user avatar.
typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
  ImageProvider imageProvider,
);

/// Builder function used to build a placeholder widget.
typedef PlaceholderWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
);

/// Builder function used to build an error widget.
typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
  Object error,
);

/// Builder function used to build a widget with the user initials.
typedef FallbackWidgetBuilder = Widget Function(
  BuildContext context,
  UserInfo user,
);

/// The action to perform when the user avatar is tapped.
typedef OnUserAvatarTap = void Function(UserInfo);

/// The action to perform when the user avatar is long-pressed.
typedef OnUserAvatarLongPress = void Function(UserInfo);

/// Displays a user's avatar.
class StreamUserAvatar extends StatelessWidget {
  /// Creates a new instance of [StreamUserAvatar].
  const StreamUserAvatar({
    super.key,
    required this.user,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.imageBuilder,
    this.placeholderBuilder,
    this.errorBuilder,
    this.fallbackBuilder,
    this.constraints,
    this.borderRadius,
    this.initialsTextStyle,
    this.selectionColor,
    this.selectionThickness,
  });

  /// User whose avatar is to be displayed.
  final UserInfo user;

  /// Flag for if avatar is selected. Defaults to `false`.
  final bool selected;

  /// The action to perform when the user avatar is tapped.
  final OnUserAvatarTap? onTap;

  /// The action to perform when the user avatar is long-pressed.
  final OnUserAvatarLongPress? onLongPress;

  /// Builder function used to build an image widget for the user avatar.
  final ImageWidgetBuilder? imageBuilder;

  /// Builder function used to build a placeholder widget.
  final PlaceholderWidgetBuilder? placeholderBuilder;

  /// Builder function used to build an error widget.
  final ErrorWidgetBuilder? errorBuilder;

  /// Builder function used to build a widget with the user initials.
  final FallbackWidgetBuilder? fallbackBuilder;

  /// Sizing constraints of the avatar.
  final BoxConstraints? constraints;

  /// [BorderRadius] of the image.
  final BorderRadius? borderRadius;

  /// [TextStyle] for the initials text.
  final TextStyle? initialsTextStyle;

  /// Color of the selection.
  final Color? selectionColor;

  /// Selection thickness around the avatar.
  final double? selectionThickness;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    final theme = StreamUserAvatarTheme.of(context);
    final constraints = this.constraints ?? theme.constraints;
    final borderRadius = this.borderRadius ?? theme.borderRadius;
    final initialsTextStyle = this.initialsTextStyle ?? theme.initialsTextStyle;
    final selectionColor = this.selectionColor ?? theme.selectionColor;
    final selectionThickness =
        this.selectionThickness ?? theme.selectionThickness;

    Widget avatar = FittedBox(
      fit: BoxFit.cover,
      child: Container(
        constraints: constraints,
        child: hasImage
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                imageUrl: imageUrl,
                errorWidget: (context, __, error) => errorBuilder != null
                    ? errorBuilder!(context, user, error)
                    : _InitialsUserAvatar(
                        user: user,
                        borderRadius: borderRadius,
                        initialsTextStyle: initialsTextStyle,
                      ),
                placeholder: placeholderBuilder != null
                    ? (context, __) => placeholderBuilder!(context, user)
                    : null,
                imageBuilder: (context, imageProvider) => imageBuilder != null
                    ? imageBuilder!(context, user, imageProvider)
                    : _ImageUserAvatar(
                        imageProvider: imageProvider,
                        borderRadius: borderRadius,
                      ),
              )
            : fallbackBuilder != null
                ? fallbackBuilder!(context, user)
                : _InitialsUserAvatar(
                    user: user,
                    borderRadius: borderRadius,
                    initialsTextStyle: initialsTextStyle,
                  ),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: borderRadius + BorderRadius.circular(selectionThickness),
        child: Container(
          constraints: constraints,
          color: selectionColor,
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
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

/// Displays an avatar with the user picture.
class _ImageUserAvatar extends StatelessWidget {
  /// Creates a new instance of [_ImageUserAvatar].
  const _ImageUserAvatar({
    required this.imageProvider,
    required this.borderRadius,
  });

  /// The image to be painted into the decoration.
  final ImageProvider imageProvider;

  /// [BorderRadius] of the image.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// Displays an avatar with a color background and initials text.
class _InitialsUserAvatar extends StatelessWidget {
  /// Creates a new instance of [_InitialsUserAvatar].
  const _InitialsUserAvatar({
    required this.user,
    required this.borderRadius,
    required this.initialsTextStyle,
  });

  /// User whose avatar is to be displayed.
  final UserInfo user;

  /// [BorderRadius] of the image.
  final BorderRadius borderRadius;

  /// [TextStyle] for the initials text.
  final TextStyle? initialsTextStyle;

  @override
  Widget build(BuildContext context) {
    final initials =
        user.name.isNotEmpty ? user.name.initials() : user.id.initials();

    final avatarColorIndex = initials.hashCode.abs() % avatarColors.length;
    final avatarColor = avatarColors[avatarColorIndex];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: avatarColor,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          initials,
          style: initialsTextStyle,
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
