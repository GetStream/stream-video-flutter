// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'call_participants_grid_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamCallParticipantsGridThemeData {
  bool get canMerge => true;

  static StreamCallParticipantsGridThemeData? lerp(
    StreamCallParticipantsGridThemeData? a,
    StreamCallParticipantsGridThemeData? b,
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

    return StreamCallParticipantsGridThemeData(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      mainAxisSpacing: lerpDouble$(a.mainAxisSpacing, b.mainAxisSpacing, t),
      crossAxisSpacing: lerpDouble$(a.crossAxisSpacing, b.crossAxisSpacing, t),
    );
  }

  StreamCallParticipantsGridThemeData copyWith({
    EdgeInsetsGeometry? padding,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
  }) {
    final _this = (this as StreamCallParticipantsGridThemeData);

    return StreamCallParticipantsGridThemeData(
      padding: padding ?? _this.padding,
      mainAxisSpacing: mainAxisSpacing ?? _this.mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing ?? _this.crossAxisSpacing,
    );
  }

  StreamCallParticipantsGridThemeData merge(
    StreamCallParticipantsGridThemeData? other,
  ) {
    final _this = (this as StreamCallParticipantsGridThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      mainAxisSpacing: other.mainAxisSpacing,
      crossAxisSpacing: other.crossAxisSpacing,
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

    final _this = (this as StreamCallParticipantsGridThemeData);
    final _other = (other as StreamCallParticipantsGridThemeData);

    return _other.padding == _this.padding &&
        _other.mainAxisSpacing == _this.mainAxisSpacing &&
        _other.crossAxisSpacing == _this.crossAxisSpacing;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallParticipantsGridThemeData);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.mainAxisSpacing,
      _this.crossAxisSpacing,
    );
  }
}
