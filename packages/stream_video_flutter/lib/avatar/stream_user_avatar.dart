import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
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
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    TextStyle? initialsTextStyle,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
    this.onTap,
    this.onLongPress,
    this.imageBuilder,
    this.placeholderBuilder,
    this.errorBuilder,
    this.fallbackBuilder,
  })  : _constraints = constraints,
        _borderRadius = borderRadius,
        _initialsTextStyle = initialsTextStyle;

  /// Sizing constraints of the avatar.
  final BoxConstraints? _constraints;

  /// [BorderRadius] of the image.
  final BorderRadius? _borderRadius;

  /// [TextStyle] for the initials text.
  final TextStyle? _initialsTextStyle;

  /// User whose avatar is to be displayed.
  final UserInfo user;

  /// Get constraints for avatar
  BoxConstraints get constraints =>
      _constraints ??
      const BoxConstraints.tightFor(
        height: 40,
        width: 40,
      );

  /// Get border radius
  BorderRadius get borderRadius => _borderRadius ?? BorderRadius.circular(20);

  /// Get initials text style.
  TextStyle get initialsTextStyle =>
      _initialsTextStyle ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  /// Flag for if avatar is selected. Defaults to `false`.
  final bool selected;

  /// Color of the selection.
  final Color? selectionColor;

  /// Selection thickness around the avatar. Defaults to `4`.
  final double selectionThickness;

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
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final streamChatTheme = StreamVideoTheme.of(context);

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
                    : _gradientAvatar(context),
                placeholder: placeholderBuilder != null
                    ? (context, __) => placeholderBuilder!(context, user)
                    : null,
                imageBuilder: _imageBuilder,
              )
            : fallbackBuilder != null
                ? fallbackBuilder!(context, user)
                : _gradientAvatar(context),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: borderRadius + BorderRadius.circular(selectionThickness),
        child: Container(
          constraints: constraints,
          color: selectionColor ?? streamChatTheme.colorTheme.accentPrimary,
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
        child: avatar);
  }

  /// Build an avatar with an image.
  Widget _imageBuilder(BuildContext context, ImageProvider imageProvider) {
    if (imageBuilder != null) {
      return imageBuilder!(context, user, imageProvider);
    } else {
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

  /// Build an avatar with a color background and initials text.
  Widget _gradientAvatar(BuildContext context) {
    final initials =
        user.name.isNotEmpty ? user.name.initials() : user.id.initials();

    final avatarColorIndex = initials.hashCode.abs() % avatarColors.length;
    final avatarColor = avatarColors[avatarColorIndex];

    return DecoratedBox(
      decoration: BoxDecoration(color: avatarColor, borderRadius: borderRadius),
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
