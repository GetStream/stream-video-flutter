import 'package:flutter/material.dart';

/// Contains definitions for the various text styles.
class StreamTextTheme {
  /// Initialise light text theme.
  const StreamTextTheme.light({
    this.title1 = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.title3 = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.title3Bold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.bodyItalic = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontStyle: FontStyle.italic,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    this.footnoteItalic = const TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    this.tabBar = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  });

  /// Initialise with dark theme.
  const StreamTextTheme.dark({
    this.title1 = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.title3 = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    this.title3Bold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    this.bodyItalic = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    this.footnoteItalic = const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    this.tabBar = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  });

  /// Raw text theme initialization.
  const StreamTextTheme.raw({
    required this.title1,
    required this.title3,
    required this.title3Bold,
    required this.body,
    required this.bodyItalic,
    required this.bodyBold,
    required this.footnote,
    required this.footnoteItalic,
    required this.footnoteBold,
    required this.captionBold,
    required this.tabBar,
  });

  /// Text style for title1 text.
  final TextStyle title1;

  /// Text style for title3 text.
  final TextStyle title3;

  /// Bold text style for title3 text.
  final TextStyle title3Bold;

  /// Text style for body text.
  final TextStyle body;

  /// Italic text theme for body text.
  final TextStyle bodyItalic;

  /// Bold text style for body text.
  final TextStyle bodyBold;

  /// Text style for footnote text.
  final TextStyle footnote;

  /// Italic text style for footnote text.
  final TextStyle footnoteItalic;

  /// Bold text style for footnote text.
  final TextStyle footnoteBold;

  /// Bold text style for caption text.
  final TextStyle captionBold;

  /// Text style for tab bar text.
  final TextStyle tabBar;

  /// Copy with theme
  StreamTextTheme copyWith({
    TextStyle? title1,
    TextStyle? title3,
    TextStyle? title3Bold,
    TextStyle? body,
    TextStyle? bodyItalic,
    TextStyle? bodyBold,
    TextStyle? footnote,
    TextStyle? footnoteItalic,
    TextStyle? footnoteBold,
    TextStyle? captionBold,
    TextStyle? tabBar,
  }) =>
      StreamTextTheme.raw(
        title1: title1 ?? this.title1,
        title3: title3 ?? this.title3,
        title3Bold: title3Bold ?? this.title3Bold,
        body: body ?? this.body,
        bodyItalic: bodyItalic ?? this.bodyItalic,
        bodyBold: bodyBold ?? this.bodyBold,
        footnote: footnote ?? this.footnote,
        footnoteItalic: footnoteItalic ?? this.footnoteItalic,
        footnoteBold: footnoteBold ?? this.footnoteBold,
        captionBold: captionBold ?? this.captionBold,
        tabBar: tabBar ?? this.tabBar,
      );

  /// Merge text themes.
  StreamTextTheme merge(StreamTextTheme? other) {
    if (other == null) return this;
    return copyWith(
      title1: title1.merge(other.title1),
      title3: title3.merge(other.title3),
      title3Bold: title3Bold.merge(other.title3Bold),
      body: body.merge(other.body),
      bodyItalic: bodyItalic.merge(other.bodyItalic),
      bodyBold: bodyBold.merge(other.bodyBold),
      footnote: footnote.merge(other.footnote),
      footnoteItalic: footnoteItalic.merge(other.footnoteItalic),
      footnoteBold: footnoteBold.merge(other.footnoteBold),
      captionBold: captionBold.merge(other.captionBold),
      tabBar: tabBar.merge(other.tabBar),
    );
  }

  /// Linearly interpolate between two text themes.
  StreamTextTheme lerp(StreamTextTheme? other, double t) {
    if (other == null) return this;
    return copyWith(
      title1: TextStyle.lerp(title1, other.title1, t),
      title3: TextStyle.lerp(title3, other.title3, t),
      title3Bold: TextStyle.lerp(title3Bold, other.title3Bold, t),
      body: TextStyle.lerp(body, other.body, t),
      bodyItalic: TextStyle.lerp(bodyItalic, other.bodyItalic, t),
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t),
      footnote: TextStyle.lerp(footnote, other.footnote, t),
      footnoteItalic: TextStyle.lerp(footnoteItalic, other.footnoteItalic, t),
      footnoteBold: TextStyle.lerp(footnoteBold, other.footnoteBold, t),
      captionBold: TextStyle.lerp(captionBold, other.captionBold, t),
      tabBar: TextStyle.lerp(tabBar, other.tabBar, t),
    );
  }
}
