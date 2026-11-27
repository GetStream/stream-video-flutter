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
      columnResolver: t < 0.5 ? a.columnResolver : b.columnResolver,
      maxTileAspectRatio: lerpDouble$(
        a.maxTileAspectRatio,
        b.maxTileAspectRatio,
        t,
      ),
      compactPageSize: t < 0.5 ? a.compactPageSize : b.compactPageSize,
      pageSize: t < 0.5 ? a.pageSize : b.pageSize,
      foldStyle: StreamFoldLayoutStyle.lerp(a.foldStyle, b.foldStyle, t),
      maxExtraTilesOnSmallerSide: t < 0.5
          ? a.maxExtraTilesOnSmallerSide
          : b.maxExtraTilesOnSmallerSide,
      foldSplitResolver: t < 0.5 ? a.foldSplitResolver : b.foldSplitResolver,
    );
  }

  StreamCallParticipantsGridThemeData copyWith({
    EdgeInsetsGeometry? padding,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    int? Function(StreamParticipantGridDetails)? columnResolver,
    double? maxTileAspectRatio,
    int? compactPageSize,
    int? pageSize,
    StreamFoldLayoutStyle? foldStyle,
    int? maxExtraTilesOnSmallerSide,
    int? Function(StreamParticipantFoldSplitDetails)? foldSplitResolver,
  }) {
    final _this = (this as StreamCallParticipantsGridThemeData);

    return StreamCallParticipantsGridThemeData(
      padding: padding ?? _this.padding,
      mainAxisSpacing: mainAxisSpacing ?? _this.mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing ?? _this.crossAxisSpacing,
      columnResolver: columnResolver ?? _this.columnResolver,
      maxTileAspectRatio: maxTileAspectRatio ?? _this.maxTileAspectRatio,
      compactPageSize: compactPageSize ?? _this.compactPageSize,
      pageSize: pageSize ?? _this.pageSize,
      foldStyle: foldStyle ?? _this.foldStyle,
      maxExtraTilesOnSmallerSide:
          maxExtraTilesOnSmallerSide ?? _this.maxExtraTilesOnSmallerSide,
      foldSplitResolver: foldSplitResolver ?? _this.foldSplitResolver,
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
      columnResolver: other.columnResolver,
      maxTileAspectRatio: other.maxTileAspectRatio,
      compactPageSize: other.compactPageSize,
      pageSize: other.pageSize,
      foldStyle: _this.foldStyle?.merge(other.foldStyle) ?? other.foldStyle,
      maxExtraTilesOnSmallerSide: other.maxExtraTilesOnSmallerSide,
      foldSplitResolver: other.foldSplitResolver,
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
        _other.crossAxisSpacing == _this.crossAxisSpacing &&
        _other.columnResolver == _this.columnResolver &&
        _other.maxTileAspectRatio == _this.maxTileAspectRatio &&
        _other.compactPageSize == _this.compactPageSize &&
        _other.pageSize == _this.pageSize &&
        _other.foldStyle == _this.foldStyle &&
        _other.maxExtraTilesOnSmallerSide == _this.maxExtraTilesOnSmallerSide &&
        _other.foldSplitResolver == _this.foldSplitResolver;
  }

  @override
  int get hashCode {
    final _this = (this as StreamCallParticipantsGridThemeData);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.mainAxisSpacing,
      _this.crossAxisSpacing,
      _this.columnResolver,
      _this.maxTileAspectRatio,
      _this.compactPageSize,
      _this.pageSize,
      _this.foldStyle,
      _this.maxExtraTilesOnSmallerSide,
      _this.foldSplitResolver,
    );
  }
}
