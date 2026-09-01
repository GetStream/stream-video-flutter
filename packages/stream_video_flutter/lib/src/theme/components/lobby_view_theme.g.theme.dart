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
      maxOverlaidControls: t < 0.5
          ? a.maxOverlaidControls
          : b.maxOverlaidControls,
      joinButtonWidth: lerpDouble$(a.joinButtonWidth, b.joinButtonWidth, t),
    );
  }

  StreamLobbyViewStyle copyWith({
    StreamParticipantTileStyle? previewTileStyle,
    double? smallPreviewAspectRatio,
    Size? largePreviewSize,
    int? maxOverlaidControls,
    double? joinButtonWidth,
  }) {
    final _this = (this as StreamLobbyViewStyle);

    return StreamLobbyViewStyle(
      previewTileStyle: previewTileStyle ?? _this.previewTileStyle,
      smallPreviewAspectRatio:
          smallPreviewAspectRatio ?? _this.smallPreviewAspectRatio,
      largePreviewSize: largePreviewSize ?? _this.largePreviewSize,
      maxOverlaidControls: maxOverlaidControls ?? _this.maxOverlaidControls,
      joinButtonWidth: joinButtonWidth ?? _this.joinButtonWidth,
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
      previewTileStyle:
          _this.previewTileStyle?.merge(other.previewTileStyle) ??
          other.previewTileStyle,
      smallPreviewAspectRatio: other.smallPreviewAspectRatio,
      largePreviewSize: other.largePreviewSize,
      maxOverlaidControls: other.maxOverlaidControls,
      joinButtonWidth: other.joinButtonWidth,
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

    return _other.previewTileStyle == _this.previewTileStyle &&
        _other.smallPreviewAspectRatio == _this.smallPreviewAspectRatio &&
        _other.largePreviewSize == _this.largePreviewSize &&
        _other.maxOverlaidControls == _this.maxOverlaidControls &&
        _other.joinButtonWidth == _this.joinButtonWidth;
  }

  @override
  int get hashCode {
    final _this = (this as StreamLobbyViewStyle);

    return Object.hash(
      runtimeType,
      _this.previewTileStyle,
      _this.smallPreviewAspectRatio,
      _this.largePreviewSize,
      _this.maxOverlaidControls,
      _this.joinButtonWidth,
    );
  }
}
