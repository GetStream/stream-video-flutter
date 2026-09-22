// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'picture_in_picture_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPictureInPictureThemeData {
  bool get canMerge => true;

  static StreamPictureInPictureThemeData? lerp(
    StreamPictureInPictureThemeData? a,
    StreamPictureInPictureThemeData? b,
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

    return StreamPictureInPictureThemeData(
      style: StreamPictureInPictureStyle.lerp(a.style, b.style, t),
    );
  }

  StreamPictureInPictureThemeData copyWith({
    StreamPictureInPictureStyle? style,
  }) {
    final _this = (this as StreamPictureInPictureThemeData);

    return StreamPictureInPictureThemeData(style: style ?? _this.style);
  }

  StreamPictureInPictureThemeData merge(
    StreamPictureInPictureThemeData? other,
  ) {
    final _this = (this as StreamPictureInPictureThemeData);

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

    final _this = (this as StreamPictureInPictureThemeData);
    final _other = (other as StreamPictureInPictureThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPictureInPictureThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamPictureInPictureStyle {
  bool get canMerge => true;

  static StreamPictureInPictureStyle? lerp(
    StreamPictureInPictureStyle? a,
    StreamPictureInPictureStyle? b,
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

    return StreamPictureInPictureStyle(
      tileStyle: StreamParticipantTileStyle.lerp(a.tileStyle, b.tileStyle, t),
    );
  }

  StreamPictureInPictureStyle copyWith({
    StreamParticipantTileStyle? tileStyle,
  }) {
    final _this = (this as StreamPictureInPictureStyle);

    return StreamPictureInPictureStyle(tileStyle: tileStyle ?? _this.tileStyle);
  }

  StreamPictureInPictureStyle merge(StreamPictureInPictureStyle? other) {
    final _this = (this as StreamPictureInPictureStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      tileStyle: _this.tileStyle?.merge(other.tileStyle) ?? other.tileStyle,
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

    final _this = (this as StreamPictureInPictureStyle);
    final _other = (other as StreamPictureInPictureStyle);

    return _other.tileStyle == _this.tileStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPictureInPictureStyle);

    return Object.hash(runtimeType, _this.tileStyle);
  }
}
