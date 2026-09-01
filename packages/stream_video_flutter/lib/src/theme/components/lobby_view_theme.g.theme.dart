// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'lobby_view_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamLobbyViewThemeData {
  bool get canMerge => true;

  static StreamLobbyViewThemeData? lerp(
    StreamLobbyViewThemeData? a,
    StreamLobbyViewThemeData? b,
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

    return StreamLobbyViewThemeData(
      style: StreamLobbyViewStyle.lerp(a.style, b.style, t),
    );
  }

  StreamLobbyViewThemeData copyWith({StreamLobbyViewStyle? style}) {
    final _this = (this as StreamLobbyViewThemeData);

    return StreamLobbyViewThemeData(style: style ?? _this.style);
  }

  StreamLobbyViewThemeData merge(StreamLobbyViewThemeData? other) {
    final _this = (this as StreamLobbyViewThemeData);

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

    final _this = (this as StreamLobbyViewThemeData);
    final _other = (other as StreamLobbyViewThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLobbyViewThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamLobbyViewStyle {
  bool get canMerge => true;

  static StreamLobbyViewStyle? lerp(
    StreamLobbyViewStyle? a,
    StreamLobbyViewStyle? b,
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

    return StreamLobbyViewStyle(
      previewBorderRadius: BorderRadius.lerp(
        a.previewBorderRadius,
        b.previewBorderRadius,
        t,
      ),
      previewTileStyle: StreamParticipantTileStyle.lerp(
        a.previewTileStyle,
        b.previewTileStyle,
        t,
      ),
      smallPreviewAspectRatio: lerpDouble$(
        a.smallPreviewAspectRatio,
        b.smallPreviewAspectRatio,
        t,
      ),
      largePreviewSize: Size.lerp(a.largePreviewSize, b.largePreviewSize, t),
      sectionSpacing: lerpDouble$(a.sectionSpacing, b.sectionSpacing, t),
      headingSpacing: lerpDouble$(a.headingSpacing, b.headingSpacing, t),
      smallLaneSpacing: lerpDouble$(a.smallLaneSpacing, b.smallLaneSpacing, t),
      largeLaneSpacing: lerpDouble$(a.largeLaneSpacing, b.largeLaneSpacing, t),
      controlSpacing: lerpDouble$(a.controlSpacing, b.controlSpacing, t),
      settingSpacing: lerpDouble$(a.settingSpacing, b.settingSpacing, t),
      overlayControlInset: lerpDouble$(
        a.overlayControlInset,
        b.overlayControlInset,
        t,
      ),
      joinButtonWidth: lerpDouble$(a.joinButtonWidth, b.joinButtonWidth, t),
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      subtitleTextStyle: TextStyle.lerp(
        a.subtitleTextStyle,
        b.subtitleTextStyle,
        t,
      ),
    );
  }

  StreamLobbyViewStyle copyWith({
    BorderRadius? previewBorderRadius,
    StreamParticipantTileStyle? previewTileStyle,
    double? smallPreviewAspectRatio,
    Size? largePreviewSize,
    double? sectionSpacing,
    double? headingSpacing,
    double? smallLaneSpacing,
    double? largeLaneSpacing,
    double? controlSpacing,
    double? settingSpacing,
    double? overlayControlInset,
    double? joinButtonWidth,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    final _this = (this as StreamLobbyViewStyle);

    return StreamLobbyViewStyle(
      previewBorderRadius: previewBorderRadius ?? _this.previewBorderRadius,
      previewTileStyle: previewTileStyle ?? _this.previewTileStyle,
      smallPreviewAspectRatio:
          smallPreviewAspectRatio ?? _this.smallPreviewAspectRatio,
      largePreviewSize: largePreviewSize ?? _this.largePreviewSize,
      sectionSpacing: sectionSpacing ?? _this.sectionSpacing,
      headingSpacing: headingSpacing ?? _this.headingSpacing,
      smallLaneSpacing: smallLaneSpacing ?? _this.smallLaneSpacing,
      largeLaneSpacing: largeLaneSpacing ?? _this.largeLaneSpacing,
      controlSpacing: controlSpacing ?? _this.controlSpacing,
      settingSpacing: settingSpacing ?? _this.settingSpacing,
      overlayControlInset: overlayControlInset ?? _this.overlayControlInset,
      joinButtonWidth: joinButtonWidth ?? _this.joinButtonWidth,
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _this.subtitleTextStyle,
    );
  }

  StreamLobbyViewStyle merge(StreamLobbyViewStyle? other) {
    final _this = (this as StreamLobbyViewStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      previewBorderRadius: other.previewBorderRadius,
      previewTileStyle:
          _this.previewTileStyle?.merge(other.previewTileStyle) ??
          other.previewTileStyle,
      smallPreviewAspectRatio: other.smallPreviewAspectRatio,
      largePreviewSize: other.largePreviewSize,
      sectionSpacing: other.sectionSpacing,
      headingSpacing: other.headingSpacing,
      smallLaneSpacing: other.smallLaneSpacing,
      largeLaneSpacing: other.largeLaneSpacing,
      controlSpacing: other.controlSpacing,
      settingSpacing: other.settingSpacing,
      overlayControlInset: other.overlayControlInset,
      joinButtonWidth: other.joinButtonWidth,
      titleTextStyle:
          _this.titleTextStyle?.merge(other.titleTextStyle) ??
          other.titleTextStyle,
      subtitleTextStyle:
          _this.subtitleTextStyle?.merge(other.subtitleTextStyle) ??
          other.subtitleTextStyle,
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

    final _this = (this as StreamLobbyViewStyle);
    final _other = (other as StreamLobbyViewStyle);

    return _other.previewBorderRadius == _this.previewBorderRadius &&
        _other.previewTileStyle == _this.previewTileStyle &&
        _other.smallPreviewAspectRatio == _this.smallPreviewAspectRatio &&
        _other.largePreviewSize == _this.largePreviewSize &&
        _other.sectionSpacing == _this.sectionSpacing &&
        _other.headingSpacing == _this.headingSpacing &&
        _other.smallLaneSpacing == _this.smallLaneSpacing &&
        _other.largeLaneSpacing == _this.largeLaneSpacing &&
        _other.controlSpacing == _this.controlSpacing &&
        _other.settingSpacing == _this.settingSpacing &&
        _other.overlayControlInset == _this.overlayControlInset &&
        _other.joinButtonWidth == _this.joinButtonWidth &&
        _other.titleTextStyle == _this.titleTextStyle &&
        _other.subtitleTextStyle == _this.subtitleTextStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLobbyViewStyle);

    return Object.hash(
      runtimeType,
      _this.previewBorderRadius,
      _this.previewTileStyle,
      _this.smallPreviewAspectRatio,
      _this.largePreviewSize,
      _this.sectionSpacing,
      _this.headingSpacing,
      _this.smallLaneSpacing,
      _this.largeLaneSpacing,
      _this.controlSpacing,
      _this.settingSpacing,
      _this.overlayControlInset,
      _this.joinButtonWidth,
      _this.titleTextStyle,
      _this.subtitleTextStyle,
    );
  }
}
