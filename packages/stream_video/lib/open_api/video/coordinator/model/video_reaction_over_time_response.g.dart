// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_reaction_over_time_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VideoReactionOverTimeResponse extends VideoReactionOverTimeResponse {
  @override
  final BuiltList<CountByMinuteResponse?>? byMinute;

  factory _$VideoReactionOverTimeResponse(
          [void Function(VideoReactionOverTimeResponseBuilder)? updates]) =>
      (VideoReactionOverTimeResponseBuilder()..update(updates))._build();

  _$VideoReactionOverTimeResponse._({this.byMinute}) : super._();
  @override
  VideoReactionOverTimeResponse rebuild(
          void Function(VideoReactionOverTimeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoReactionOverTimeResponseBuilder toBuilder() =>
      VideoReactionOverTimeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoReactionOverTimeResponse && byMinute == other.byMinute;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byMinute.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VideoReactionOverTimeResponse')
          ..add('byMinute', byMinute))
        .toString();
  }
}

class VideoReactionOverTimeResponseBuilder
    implements
        Builder<VideoReactionOverTimeResponse,
            VideoReactionOverTimeResponseBuilder> {
  _$VideoReactionOverTimeResponse? _$v;

  ListBuilder<CountByMinuteResponse?>? _byMinute;
  ListBuilder<CountByMinuteResponse?> get byMinute =>
      _$this._byMinute ??= ListBuilder<CountByMinuteResponse?>();
  set byMinute(ListBuilder<CountByMinuteResponse?>? byMinute) =>
      _$this._byMinute = byMinute;

  VideoReactionOverTimeResponseBuilder() {
    VideoReactionOverTimeResponse._defaults(this);
  }

  VideoReactionOverTimeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byMinute = $v.byMinute?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoReactionOverTimeResponse other) {
    _$v = other as _$VideoReactionOverTimeResponse;
  }

  @override
  void update(void Function(VideoReactionOverTimeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VideoReactionOverTimeResponse build() => _build();

  _$VideoReactionOverTimeResponse _build() {
    _$VideoReactionOverTimeResponse _$result;
    try {
      _$result = _$v ??
          _$VideoReactionOverTimeResponse._(
            byMinute: _byMinute?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byMinute';
        _byMinute?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VideoReactionOverTimeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
