// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'live_indicator_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamLiveIndicatorThemeData {
  bool get canMerge => true;

  static StreamLiveIndicatorThemeData? lerp(
    StreamLiveIndicatorThemeData? a,
    StreamLiveIndicatorThemeData? b,
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

    return StreamLiveIndicatorThemeData(
      style: StreamLiveIndicatorStyle.lerp(a.style, b.style, t),
    );
  }

  StreamLiveIndicatorThemeData copyWith({StreamLiveIndicatorStyle? style}) {
    final _this = (this as StreamLiveIndicatorThemeData);

    return StreamLiveIndicatorThemeData(style: style ?? _this.style);
  }

  StreamLiveIndicatorThemeData merge(StreamLiveIndicatorThemeData? other) {
    final _this = (this as StreamLiveIndicatorThemeData);

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

    final _this = (this as StreamLiveIndicatorThemeData);
    final _other = (other as StreamLiveIndicatorThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLiveIndicatorThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamLiveIndicatorStyle {
  bool get canMerge => true;

  static StreamLiveIndicatorStyle? lerp(
    StreamLiveIndicatorStyle? a,
    StreamLiveIndicatorStyle? b,
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

    return StreamLiveIndicatorStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      dotSize: lerpDouble$(a.dotSize, b.dotSize, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      liveBackgroundColor: Color.lerp(
        a.liveBackgroundColor,
        b.liveBackgroundColor,
        t,
      ),
      liveForegroundColor: Color.lerp(
        a.liveForegroundColor,
        b.liveForegroundColor,
        t,
      ),
      backstageBackgroundColor: Color.lerp(
        a.backstageBackgroundColor,
        b.backstageBackgroundColor,
        t,
      ),
      backstageForegroundColor: Color.lerp(
        a.backstageForegroundColor,
        b.backstageForegroundColor,
        t,
      ),
    );
  }

  StreamLiveIndicatorStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? dotSize,
    BorderRadiusGeometry? borderRadius,
    TextStyle? textStyle,
    Color? liveBackgroundColor,
    Color? liveForegroundColor,
    Color? backstageBackgroundColor,
    Color? backstageForegroundColor,
  }) {
    final _this = (this as StreamLiveIndicatorStyle);

    return StreamLiveIndicatorStyle(
      padding: padding ?? _this.padding,
      spacing: spacing ?? _this.spacing,
      dotSize: dotSize ?? _this.dotSize,
      borderRadius: borderRadius ?? _this.borderRadius,
      textStyle: textStyle ?? _this.textStyle,
      liveBackgroundColor: liveBackgroundColor ?? _this.liveBackgroundColor,
      liveForegroundColor: liveForegroundColor ?? _this.liveForegroundColor,
      backstageBackgroundColor:
          backstageBackgroundColor ?? _this.backstageBackgroundColor,
      backstageForegroundColor:
          backstageForegroundColor ?? _this.backstageForegroundColor,
    );
  }

  StreamLiveIndicatorStyle merge(StreamLiveIndicatorStyle? other) {
    final _this = (this as StreamLiveIndicatorStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      spacing: other.spacing,
      dotSize: other.dotSize,
      borderRadius: other.borderRadius,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      liveBackgroundColor: other.liveBackgroundColor,
      liveForegroundColor: other.liveForegroundColor,
      backstageBackgroundColor: other.backstageBackgroundColor,
      backstageForegroundColor: other.backstageForegroundColor,
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

    final _this = (this as StreamLiveIndicatorStyle);
    final _other = (other as StreamLiveIndicatorStyle);

    return _other.padding == _this.padding &&
        _other.spacing == _this.spacing &&
        _other.dotSize == _this.dotSize &&
        _other.borderRadius == _this.borderRadius &&
        _other.textStyle == _this.textStyle &&
        _other.liveBackgroundColor == _this.liveBackgroundColor &&
        _other.liveForegroundColor == _this.liveForegroundColor &&
        _other.backstageBackgroundColor == _this.backstageBackgroundColor &&
        _other.backstageForegroundColor == _this.backstageForegroundColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLiveIndicatorStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.spacing,
      _this.dotSize,
      _this.borderRadius,
      _this.textStyle,
      _this.liveBackgroundColor,
      _this.liveForegroundColor,
      _this.backstageBackgroundColor,
      _this.backstageForegroundColor,
    );
  }
}
