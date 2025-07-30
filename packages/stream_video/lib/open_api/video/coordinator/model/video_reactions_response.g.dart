// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_reactions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VideoReactionsResponse extends VideoReactionsResponse {
  @override
  final VideoReactionOverTimeResponse? countOverTime;
  @override
  final String reaction;

  factory _$VideoReactionsResponse(
          [void Function(VideoReactionsResponseBuilder)? updates]) =>
      (VideoReactionsResponseBuilder()..update(updates))._build();

  _$VideoReactionsResponse._({this.countOverTime, required this.reaction})
      : super._();
  @override
  VideoReactionsResponse rebuild(
          void Function(VideoReactionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoReactionsResponseBuilder toBuilder() =>
      VideoReactionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoReactionsResponse &&
        countOverTime == other.countOverTime &&
        reaction == other.reaction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, countOverTime.hashCode);
    _$hash = $jc(_$hash, reaction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VideoReactionsResponse')
          ..add('countOverTime', countOverTime)
          ..add('reaction', reaction))
        .toString();
  }
}

class VideoReactionsResponseBuilder
    implements Builder<VideoReactionsResponse, VideoReactionsResponseBuilder> {
  _$VideoReactionsResponse? _$v;

  VideoReactionOverTimeResponseBuilder? _countOverTime;
  VideoReactionOverTimeResponseBuilder get countOverTime =>
      _$this._countOverTime ??= VideoReactionOverTimeResponseBuilder();
  set countOverTime(VideoReactionOverTimeResponseBuilder? countOverTime) =>
      _$this._countOverTime = countOverTime;

  String? _reaction;
  String? get reaction => _$this._reaction;
  set reaction(String? reaction) => _$this._reaction = reaction;

  VideoReactionsResponseBuilder() {
    VideoReactionsResponse._defaults(this);
  }

  VideoReactionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _countOverTime = $v.countOverTime?.toBuilder();
      _reaction = $v.reaction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoReactionsResponse other) {
    _$v = other as _$VideoReactionsResponse;
  }

  @override
  void update(void Function(VideoReactionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VideoReactionsResponse build() => _build();

  _$VideoReactionsResponse _build() {
    _$VideoReactionsResponse _$result;
    try {
      _$result = _$v ??
          _$VideoReactionsResponse._(
            countOverTime: _countOverTime?.build(),
            reaction: BuiltValueNullFieldError.checkNotNull(
                reaction, r'VideoReactionsResponse', 'reaction'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'countOverTime';
        _countOverTime?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VideoReactionsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
