// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_count_by_minute_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ParticipantCountByMinuteResponse
    extends ParticipantCountByMinuteResponse {
  @override
  final int first;
  @override
  final int last;
  @override
  final int max;
  @override
  final int min;
  @override
  final DateTime startTs;

  factory _$ParticipantCountByMinuteResponse(
          [void Function(ParticipantCountByMinuteResponseBuilder)? updates]) =>
      (ParticipantCountByMinuteResponseBuilder()..update(updates))._build();

  _$ParticipantCountByMinuteResponse._(
      {required this.first,
      required this.last,
      required this.max,
      required this.min,
      required this.startTs})
      : super._();
  @override
  ParticipantCountByMinuteResponse rebuild(
          void Function(ParticipantCountByMinuteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParticipantCountByMinuteResponseBuilder toBuilder() =>
      ParticipantCountByMinuteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParticipantCountByMinuteResponse &&
        first == other.first &&
        last == other.last &&
        max == other.max &&
        min == other.min &&
        startTs == other.startTs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, first.hashCode);
    _$hash = $jc(_$hash, last.hashCode);
    _$hash = $jc(_$hash, max.hashCode);
    _$hash = $jc(_$hash, min.hashCode);
    _$hash = $jc(_$hash, startTs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParticipantCountByMinuteResponse')
          ..add('first', first)
          ..add('last', last)
          ..add('max', max)
          ..add('min', min)
          ..add('startTs', startTs))
        .toString();
  }
}

class ParticipantCountByMinuteResponseBuilder
    implements
        Builder<ParticipantCountByMinuteResponse,
            ParticipantCountByMinuteResponseBuilder> {
  _$ParticipantCountByMinuteResponse? _$v;

  int? _first;
  int? get first => _$this._first;
  set first(int? first) => _$this._first = first;

  int? _last;
  int? get last => _$this._last;
  set last(int? last) => _$this._last = last;

  int? _max;
  int? get max => _$this._max;
  set max(int? max) => _$this._max = max;

  int? _min;
  int? get min => _$this._min;
  set min(int? min) => _$this._min = min;

  DateTime? _startTs;
  DateTime? get startTs => _$this._startTs;
  set startTs(DateTime? startTs) => _$this._startTs = startTs;

  ParticipantCountByMinuteResponseBuilder() {
    ParticipantCountByMinuteResponse._defaults(this);
  }

  ParticipantCountByMinuteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _first = $v.first;
      _last = $v.last;
      _max = $v.max;
      _min = $v.min;
      _startTs = $v.startTs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParticipantCountByMinuteResponse other) {
    _$v = other as _$ParticipantCountByMinuteResponse;
  }

  @override
  void update(void Function(ParticipantCountByMinuteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParticipantCountByMinuteResponse build() => _build();

  _$ParticipantCountByMinuteResponse _build() {
    final _$result = _$v ??
        _$ParticipantCountByMinuteResponse._(
          first: BuiltValueNullFieldError.checkNotNull(
              first, r'ParticipantCountByMinuteResponse', 'first'),
          last: BuiltValueNullFieldError.checkNotNull(
              last, r'ParticipantCountByMinuteResponse', 'last'),
          max: BuiltValueNullFieldError.checkNotNull(
              max, r'ParticipantCountByMinuteResponse', 'max'),
          min: BuiltValueNullFieldError.checkNotNull(
              min, r'ParticipantCountByMinuteResponse', 'min'),
          startTs: BuiltValueNullFieldError.checkNotNull(
              startTs, r'ParticipantCountByMinuteResponse', 'startTs'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
