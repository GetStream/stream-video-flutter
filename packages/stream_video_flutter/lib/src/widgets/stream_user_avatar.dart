import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';
import 'avatar_size_from_constraints.dart';

/// The action to perform when the user avatar is tapped.
typedef OnUserAvatarTap = void Function(UserInfo);

/// The action to perform when the user avatar is long-pressed.
typedef OnUserAvatarLongPress = void Function(UserInfo);

/// Displays a user's avatar.
///
/// Every avatar in the SDK goes through here, so registering a `userAvatar`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory]
/// changes all of them at once — in a participant tile, the lobby, the
/// participants list and the incoming and outgoing call screens. The builder
/// receives the whole [UserInfo], so an avatar can be drawn from fields the SDK
/// itself never reads: a team badge, a role ring, an identicon derived from
/// `extraData`.
///
/// When no builder is registered, [DefaultStreamUserAvatar] is used.
///
/// See also:
///
///  * [StreamAvatarTheme], for customizing its size, colors and border.
class StreamUserAvatar extends StatelessWidget {
  /// Creates a new instance of [StreamUserAvatar].
  StreamUserAvatar({
    super.key,
    required UserInfo user,
    OnUserAvatarTap? onTap,
    OnUserAvatarLongPress? onLongPress,
  }) : props = .new(user: user, onTap: onTap, onLongPress: onLongPress);

  /// The properties that configure this avatar.
  final StreamUserAvatarProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamUserAvatarProps>();
    return builder?.call(context, props) ??
        DefaultStreamUserAvatar(props: props);
  }
}

/// Properties for configuring a [StreamUserAvatar].
///
/// See also:
///
///  * [StreamUserAvatar], which uses these properties.
///  * [DefaultStreamUserAvatar], the default implementation.
@immutable
class StreamUserAvatarProps {
  /// Creates properties for a user avatar.
  const StreamUserAvatarProps({
    required this.user,
    this.onTap,
    this.onLongPress,
  });

  /// The user whose avatar is displayed.
  ///
  /// The whole record rather than just an image URL, so a replacement can draw
  /// from anything the user carries.
  final UserInfo user;

  /// Called when the avatar is tapped.
  final OnUserAvatarTap? onTap;

  /// Called when the avatar is long-pressed.
  final OnUserAvatarLongPress? onLongPress;

  /// Creates a copy of these properties with the given fields replaced.
  StreamUserAvatarProps copyWith({
    UserInfo? user,
    OnUserAvatarTap? onTap,
    OnUserAvatarLongPress? onLongPress,
  }) {
    return StreamUserAvatarProps(
      user: user ?? this.user,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
    );
  }
}

/// The default implementation of [StreamUserAvatar].
///
/// The design system's [StreamAvatar] showing the user's picture, falling back
/// to their initials.
class DefaultStreamUserAvatar extends StatelessWidget {
  /// Creates the default user avatar.
  const DefaultStreamUserAvatar({super.key, required this.props});

  /// The properties that configure this avatar.
  final StreamUserAvatarProps props;

  @override
  Widget build(BuildContext context) {
    final user = props.user;
    final imageUrl = user.image;

    // A scoped StreamAvatarTheme wins; the deprecated StreamUserAvatarTheme is
    // read underneath it so the screens still wrapping avatars in one keep
    // their sizing and colors.
    final theme = StreamAvatarTheme.of(context);
    final legacy = StreamUserAvatarTheme.of(context);

    final avatar = StreamAvatar(
      imageUrl: imageUrl != null && imageUrl.isNotEmpty ? imageUrl : null,
      size: theme.size ?? avatarSizeFromConstraints(legacy.constraints),
      backgroundColor: theme.backgroundColor ?? legacy.initialsBackground,
      foregroundColor: theme.foregroundColor ?? legacy.initialsTextStyle.color,
      semanticsLabel: user.name.isNotEmpty ? user.name : user.id,
      placeholder: (context) => Text(_initialsFor(user)),
    );

    final onTap = props.onTap;
    final onLongPress = props.onLongPress;
    if (onTap == null && onLongPress == null) return avatar;

    return GestureDetector(
      onTap: onTap != null ? () => onTap(user) : null,
      onLongPress: onLongPress != null ? () => onLongPress(user) : null,
      child: avatar,
    );
  }

  // A name of nothing but spaces has no initials, so fall through to the id
  // rather than showing an empty circle.
  static String _initialsFor(UserInfo user) {
    final fromName = user.name.initials();
    return fromName.isNotEmpty ? fromName : user.id.initials();
  }
}
