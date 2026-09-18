// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_participants_spotlight_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamCallParticipantsSpotlightThemeData {
  bool get canMerge => true;

  static StreamCallParticipantsSpotlightThemeData? lerp(
    StreamCallParticipantsSpotlightThemeData? a,
    StreamCallParticipantsSpotlightThemeData? b,
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

    return StreamCallParticipantsSpotlightThemeData(
      style: StreamCallParticipantsSpotlightStyle.lerp(a.style, b.style, t),
    );
  }

  StreamCallParticipantsSpotlightThemeData copyWith({
    StreamCallParticipantsSpotlightStyle? style,
  }) {
    final _this = (this as StreamCallParticipantsSpotlightThemeData);

    return StreamCallParticipantsSpotlightThemeData(
      style: style ?? _this.style,
    );
  }

  StreamCallParticipantsSpotlightThemeData merge(
    StreamCallParticipantsSpotlightThemeData? other,
  ) {
    final _this = (this as StreamCallParticipantsSpotlightThemeData);

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

    final _this = (this as StreamCallParticipantsSpotlightThemeData);
    final _other = (other as StreamCallParticipantsSpotlightThemeData);

    return _other.style == _this.style;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallParticipantsSpotlightThemeData);

    return Object.hash(runtimeType, _this.style);
  }
}

mixin _$StreamCallParticipantsSpotlightStyle {
  bool get canMerge => true;

  static StreamCallParticipantsSpotlightStyle? lerp(
    StreamCallParticipantsSpotlightStyle? a,
    StreamCallParticipantsSpotlightStyle? b,
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

    return StreamCallParticipantsSpotlightStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: lerpDouble$(a.spacing, b.spacing, t),
      maxSpotlightAspectRatio: lerpDouble$(
        a.maxSpotlightAspectRatio,
        b.maxSpotlightAspectRatio,
        t,
      ),
      compactBarTileSize: Size.lerp(
        a.compactBarTileSize,
        b.compactBarTileSize,
        t,
      ),
      barTileSize: Size.lerp(a.barTileSize, b.barTileSize, t),
      expandedBarTileSize: Size.lerp(
        a.expandedBarTileSize,
        b.expandedBarTileSize,
        t,
      ),
    );
  }

  StreamCallParticipantsSpotlightStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? maxSpotlightAspectRatio,
    Size? compactBarTileSize,
    Size? barTileSize,
    Size? expandedBarTileSize,
  }) {
    final _this = (this as StreamCallParticipantsSpotlightStyle);

    return StreamCallParticipantsSpotlightStyle(
      padding: padding ?? _this.padding,
      spacing: spacing ?? _this.spacing,
      maxSpotlightAspectRatio:
          maxSpotlightAspectRatio ?? _this.maxSpotlightAspectRatio,
      compactBarTileSize: compactBarTileSize ?? _this.compactBarTileSize,
      barTileSize: barTileSize ?? _this.barTileSize,
      expandedBarTileSize: expandedBarTileSize ?? _this.expandedBarTileSize,
    );
  }

  StreamCallParticipantsSpotlightStyle merge(
    StreamCallParticipantsSpotlightStyle? other,
  ) {
    final _this = (this as StreamCallParticipantsSpotlightStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      spacing: other.spacing,
      maxSpotlightAspectRatio: other.maxSpotlightAspectRatio,
      compactBarTileSize: other.compactBarTileSize,
      barTileSize: other.barTileSize,
      expandedBarTileSize: other.expandedBarTileSize,
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

    final _this = (this as StreamCallParticipantsSpotlightStyle);
    final _other = (other as StreamCallParticipantsSpotlightStyle);

    return _other.padding == _this.padding &&
        _other.spacing == _this.spacing &&
        _other.maxSpotlightAspectRatio == _this.maxSpotlightAspectRatio &&
        _other.compactBarTileSize == _this.compactBarTileSize &&
        _other.barTileSize == _this.barTileSize &&
        _other.expandedBarTileSize == _this.expandedBarTileSize;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallParticipantsSpotlightStyle);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.spacing,
      _this.maxSpotlightAspectRatio,
      _this.compactBarTileSize,
      _this.barTileSize,
      _this.expandedBarTileSize,
    );
  }
}
