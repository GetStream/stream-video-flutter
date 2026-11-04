import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'app_accent_color.dart';
import 'app_design.dart';

/// The app's theme of [brightness] in [design] with [accent]: the design's
/// Material and Stream themes, plus the app's own video theme.
ThemeData buildAppTheme({
  required AppDesign design,
  required Brightness brightness,
  required AppAccentColor accent,
}) {
  final spec = design.spec;
  final coreTheme = spec.streamTheme(brightness, accent);
  final baseTheme = spec.materialTheme(brightness, accent, coreTheme);
  final videoTheme = switch (brightness) {
    Brightness.light => StreamVideoTheme.light(),
    Brightness.dark => StreamVideoTheme.dark(),
  };
  final colorScheme = coreTheme.colorScheme;

  return baseTheme.copyWith(
    extensions: [
      for (final extension in baseTheme.extensions.values)
        if (extension is! StreamTheme && extension is! StreamVideoTheme)
          extension,
      coreTheme,
      videoTheme.copyWith(
        callControlsTheme: StreamCallControlsThemeData(
          callReactions: const [
            CallReactionData(
              type: 'Fireworks',
              emojiCode: ':fireworks:',
              icon: '🎉',
            ),
            CallReactionData(
              type: 'Liked',
              emojiCode: ':like:',
              icon: '👍',
            ),
            CallReactionData(
              type: 'Dislike',
              emojiCode: ':dislike:',
              icon: '👎',
            ),
            CallReactionData(
              type: 'Smile',
              emojiCode: ':smile:',
              icon: '😊',
            ),
            CallReactionData(
              type: 'Heart',
              emojiCode: ':heart:',
              icon: '♥️',
            ),
            CallReactionData(
              emojiCode: ':raise-hand:',
              type: 'Raise hand',
              icon: '✋',
            ),
          ],
          backgroundColor: colorScheme.backgroundElevation0,
          spacing: 4,
          optionIconColor: colorScheme.textPrimary,
          optionBackgroundColor: colorScheme.backgroundSurface,
          inactiveOptionBackgroundColor: colorScheme.backgroundOverlayDark,
          optionPadding: const EdgeInsets.all(14),
        ),
        userAvatarTheme: StreamUserAvatarThemeData(
          borderRadius: BorderRadius.circular(20),
          initialsTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.brand,
          ),
          initialsBackground: colorScheme.brand.shade100,
        ),
        // The label sits on a dark overlay in every design, so its text and
        // icons stay white even where the design's accent takes dark text.
        participantLabelTheme: StreamParticipantLabelThemeData(
          style: StreamParticipantLabelStyle(
            nameTextStyle: coreTheme.textTheme.metadataDefault.copyWith(
              color: _onOverlay,
            ),
            videoOffIconColor: _onOverlay,
            videoPausedColor: _onOverlay,
            microphoneOffColor: _onOverlay,
          ),
        ),
        // The participant tile is styled by the design system now. Nothing
        // is overridden here, which is what an app wanting the stock look
        // should do: setting `callParticipantTheme` opts back into the
        // deprecated shape.
        callParticipantsGridTheme: const StreamCallParticipantsGridThemeData(
          padding: EdgeInsets.all(4),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
      ),
    ],
  );
}

/// Text and icons on the SDK's dark overlays.
const _onOverlay = Colors.white;
