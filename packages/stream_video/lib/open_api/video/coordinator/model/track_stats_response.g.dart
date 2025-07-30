// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrackStatsResponse extends TrackStatsResponse {
  @override
  final int durationSeconds;
  @override
  final String trackType;

  factory _$TrackStatsResponse(
          [void Function(TrackStatsResponseBuilder)? updates]) =>
      (TrackStatsResponseBuilder()..update(updates))._build();

  _$TrackStatsResponse._(
      {required this.durationSeconds, required this.trackType})
      : super._();
  @override
  TrackStatsResponse rebuild(
          void Function(TrackStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrackStatsResponseBuilder toBuilder() =>
      TrackStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrackStatsResponse &&
        durationSeconds == other.durationSeconds &&
        trackType == other.trackType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, trackType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrackStatsResponse')
          ..add('durationSeconds', durationSeconds)
          ..add('trackType', trackType))
        .toString();
  }
}

class TrackStatsResponseBuilder
    implements Builder<TrackStatsResponse, TrackStatsResponseBuilder> {
  _$TrackStatsResponse? _$v;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  String? _trackType;
  String? get trackType => _$this._trackType;
  set trackType(String? trackType) => _$this._trackType = trackType;

  TrackStatsResponseBuilder() {
    TrackStatsResponse._defaults(this);
  }

  TrackStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _durationSeconds = $v.durationSeconds;
      _trackType = $v.trackType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrackStatsResponse other) {
    _$v = other as _$TrackStatsResponse;
  }

  @override
  void update(void Function(TrackStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrackStatsResponse build() => _build();

  _$TrackStatsResponse _build() {
    final _$result = _$v ??
        _$TrackStatsResponse._(
          durationSeconds: BuiltValueNullFieldError.checkNotNull(
              durationSeconds, r'TrackStatsResponse', 'durationSeconds'),
          trackType: BuiltValueNullFieldError.checkNotNull(
              trackType, r'TrackStatsResponse', 'trackType'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
