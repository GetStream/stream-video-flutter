// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'participant_tile_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamParticipantTileThemeData {
  bool get canMerge => true;

  static StreamParticipantTileThemeData? lerp(
    StreamParticipantTileThemeData? a,
    StreamParticipantTileThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return StreamParticipantTileThemeData(
      style: StreamParticipantTileStyle.lerp(a.style, b.style, t),
    );
  }

  StreamParticipantTileThemeData copyWith({StreamParticipantTileStyle? style}) {
    final _this = (this as StreamParticipantTileThemeData);

    return StreamParticipantTileThemeData(style: style ?? _this.style);
  }

  StreamParticipantTileThemeData merge(StreamParticipantTileThemeData? other) {
    final _this = (this as StreamParticipantTileThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(style: _this.style?.merge(other.style) ?? other.style);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamParticipantTileThemeData);
    final _other = (other as StreamParticipantTileThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamParticipantTileThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamParticipantTileStyle {
  bool get canMerge => true;

  static StreamParticipantTileStyle? lerp(
    StreamParticipantTileStyle? a,
    StreamParticipantTileStyle? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return StreamParticipantTileStyle(
      videoFit: t < 0.5 ? a.videoFit : b.videoFit,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      border: BoxBorder.lerp(a.border, b.border, t),
      speakingBorder: BoxBorder.lerp(a.speakingBorder, b.speakingBorder, t),
      showSpeakerBorder: t < 0.5 ? a.showSpeakerBorder : b.showSpeakerBorder,
      showParticipantLabel: t < 0.5
          ? a.showParticipantLabel
          : b.showParticipantLabel,
      showConnectionQualityIndicator: t < 0.5
          ? a.showConnectionQualityIndicator
          : b.showConnectionQualityIndicator,
      showMoreButton: t < 0.5 ? a.showMoreButton : b.showMoreButton,
      showReaction: t < 0.5 ? a.showReaction : b.showReaction,
      toolbarPadding: EdgeInsetsGeometry.lerp(
        a.toolbarPadding,
        b.toolbarPadding,
        t,
      ),
      toolbarSpacing: lerpDouble$(a.toolbarSpacing, b.toolbarSpacing, t),
      topToolbarPadding: EdgeInsetsGeometry.lerp(
        a.topToolbarPadding,
        b.topToolbarPadding,
        t,
      ),
      moreButtonStyle: StreamButtonThemeStyle.lerp(
        a.moreButtonStyle,
        b.moreButtonStyle,
        t,
      ),
      reactionSize: lerpDouble$(a.reactionSize, b.reactionSize, t),
      reactionInset: lerpDouble$(a.reactionInset, b.reactionInset, t),
      placeholderStyle: StreamParticipantPlaceholderStyle.lerp(
        a.placeholderStyle,
        b.placeholderStyle,
        t,
      ),
      labelStyle: StreamParticipantLabelStyle.lerp(
        a.labelStyle,
        b.labelStyle,
        t,
      ),
      connectionQualityIndicatorStyle:
          StreamConnectionQualityIndicatorStyle.lerp(
            a.connectionQualityIndicatorStyle,
            b.connectionQualityIndicatorStyle,
            t,
          ),
    );
  }

  StreamParticipantTileStyle copyWith({
    VideoFit? videoFit,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxBorder? border,
    BoxBorder? speakingBorder,
    bool? showSpeakerBorder,
    bool? showParticipantLabel,
    bool? showConnectionQualityIndicator,
    bool? showMoreButton,
    bool? showReaction,
    EdgeInsetsGeometry? toolbarPadding,
    double? toolbarSpacing,
    EdgeInsetsGeometry? topToolbarPadding,
    StreamButtonThemeStyle? moreButtonStyle,
    double? reactionSize,
    double? reactionInset,
    StreamParticipantPlaceholderStyle? placeholderStyle,
    StreamParticipantLabelStyle? labelStyle,
    StreamConnectionQualityIndicatorStyle? connectionQualityIndicatorStyle,
  }) {
    final _this = (this as StreamParticipantTileStyle);

    return StreamParticipantTileStyle(
      videoFit: videoFit ?? _this.videoFit,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      border: border ?? _this.border,
      speakingBorder: speakingBorder ?? _this.speakingBorder,
      showSpeakerBorder: showSpeakerBorder ?? _this.showSpeakerBorder,
      showParticipantLabel: showParticipantLabel ?? _this.showParticipantLabel,
      showConnectionQualityIndicator:
          showConnectionQualityIndicator ??
          _this.showConnectionQualityIndicator,
      showMoreButton: showMoreButton ?? _this.showMoreButton,
      showReaction: showReaction ?? _this.showReaction,
      toolbarPadding: toolbarPadding ?? _this.toolbarPadding,
      toolbarSpacing: toolbarSpacing ?? _this.toolbarSpacing,
      topToolbarPadding: topToolbarPadding ?? _this.topToolbarPadding,
      moreButtonStyle: moreButtonStyle ?? _this.moreButtonStyle,
      reactionSize: reactionSize ?? _this.reactionSize,
      reactionInset: reactionInset ?? _this.reactionInset,
      placeholderStyle: placeholderStyle ?? _this.placeholderStyle,
      labelStyle: labelStyle ?? _this.labelStyle,
      connectionQualityIndicatorStyle:
          connectionQualityIndicatorStyle ??
          _this.connectionQualityIndicatorStyle,
    );
  }

  StreamParticipantTileStyle merge(StreamParticipantTileStyle? other) {
    final _this = (this as StreamParticipantTileStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      videoFit: other.videoFit,
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      border: other.border,
      speakingBorder: other.speakingBorder,
      showSpeakerBorder: other.showSpeakerBorder,
      showParticipantLabel: other.showParticipantLabel,
      showConnectionQualityIndicator: other.showConnectionQualityIndicator,
      showMoreButton: other.showMoreButton,
      showReaction: other.showReaction,
      toolbarPadding: other.toolbarPadding,
      toolbarSpacing: other.toolbarSpacing,
      topToolbarPadding: other.topToolbarPadding,
      moreButtonStyle:
          _this.moreButtonStyle?.merge(other.moreButtonStyle) ??
          other.moreButtonStyle,
      reactionSize: other.reactionSize,
      reactionInset: other.reactionInset,
      placeholderStyle:
          _this.placeholderStyle?.merge(other.placeholderStyle) ??
          other.placeholderStyle,
      labelStyle: _this.labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      connectionQualityIndicatorStyle:
          _this.connectionQualityIndicatorStyle?.merge(
            other.connectionQualityIndicatorStyle,
          ) ??
          other.connectionQualityIndicatorStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamParticipantTileStyle);
    final _other = (other as StreamParticipantTileStyle);

    return _other.videoFit == _this.videoFit &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.border == _this.border &&
        _other.speakingBorder == _this.speakingBorder &&
        _other.showSpeakerBorder == _this.showSpeakerBorder &&
        _other.showParticipantLabel == _this.showParticipantLabel &&
        _other.showConnectionQualityIndicator ==
            _this.showConnectionQualityIndicator &&
        _other.showMoreButton == _this.showMoreButton &&
        _other.showReaction == _this.showReaction &&
        _other.toolbarPadding == _this.toolbarPadding &&
        _other.toolbarSpacing == _this.toolbarSpacing &&
        _other.topToolbarPadding == _this.topToolbarPadding &&
        _other.moreButtonStyle == _this.moreButtonStyle &&
        _other.reactionSize == _this.reactionSize &&
        _other.reactionInset == _this.reactionInset &&
        _other.placeholderStyle == _this.placeholderStyle &&
        _other.labelStyle == _this.labelStyle &&
        _other.connectionQualityIndicatorStyle ==
            _this.connectionQualityIndicatorStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamParticipantTileStyle);

    return Object.hash(
      runtimeType,
      _this.videoFit,
      _this.backgroundColor,
      _this.borderRadius,
      _this.border,
      _this.speakingBorder,
      _this.showSpeakerBorder,
      _this.showParticipantLabel,
      _this.showConnectionQualityIndicator,
      _this.showMoreButton,
      _this.showReaction,
      _this.toolbarPadding,
      _this.toolbarSpacing,
      _this.topToolbarPadding,
      _this.moreButtonStyle,
      _this.reactionSize,
      _this.reactionInset,
      _this.placeholderStyle,
      _this.labelStyle,
      _this.connectionQualityIndicatorStyle,
    );
  }
}

mixin _$StreamParticipantPlaceholderStyle {
  bool get canMerge => true;

  static StreamParticipantPlaceholderStyle? lerp(
    StreamParticipantPlaceholderStyle? a,
    StreamParticipantPlaceholderStyle? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return StreamParticipantPlaceholderStyle(
      avatarTheme: StreamAvatarThemeData.lerp(a.avatarTheme, b.avatarTheme, t),
    );
  }

  StreamParticipantPlaceholderStyle copyWith({
    StreamAvatarThemeData? avatarTheme,
  }) {
    final _this = (this as StreamParticipantPlaceholderStyle);

    return StreamParticipantPlaceholderStyle(
      avatarTheme: avatarTheme ?? _this.avatarTheme,
    );
  }

  StreamParticipantPlaceholderStyle merge(
    StreamParticipantPlaceholderStyle? other,
  ) {
    final _this = (this as StreamParticipantPlaceholderStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      avatarTheme:
          _this.avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamParticipantPlaceholderStyle);
    final _other = (other as StreamParticipantPlaceholderStyle);

    return _other.avatarTheme == _this.avatarTheme;
  }

  @override
  int get hashCode {
    final _this = (this as StreamParticipantPlaceholderStyle);

    return Object.hash(runtimeType, _this.avatarTheme);
  }
}
