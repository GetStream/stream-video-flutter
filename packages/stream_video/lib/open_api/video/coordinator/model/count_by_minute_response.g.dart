// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_by_minute_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CountByMinuteResponse extends CountByMinuteResponse {
  @override
  final int count;
  @override
  final DateTime startTs;

  factory _$CountByMinuteResponse(
          [void Function(CountByMinuteResponseBuilder)? updates]) =>
      (CountByMinuteResponseBuilder()..update(updates))._build();

  _$CountByMinuteResponse._({required this.count, required this.startTs})
      : super._();
  @override
  CountByMinuteResponse rebuild(
          void Function(CountByMinuteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CountByMinuteResponseBuilder toBuilder() =>
      CountByMinuteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CountByMinuteResponse &&
        count == other.count &&
        startTs == other.startTs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, startTs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CountByMinuteResponse')
          ..add('count', count)
          ..add('startTs', startTs))
        .toString();
  }
}

class CountByMinuteResponseBuilder
    implements Builder<CountByMinuteResponse, CountByMinuteResponseBuilder> {
  _$CountByMinuteResponse? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  DateTime? _startTs;
  DateTime? get startTs => _$this._startTs;
  set startTs(DateTime? startTs) => _$this._startTs = startTs;

  CountByMinuteResponseBuilder() {
    CountByMinuteResponse._defaults(this);
  }

  CountByMinuteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _startTs = $v.startTs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CountByMinuteResponse other) {
    _$v = other as _$CountByMinuteResponse;
  }

  @override
  void update(void Function(CountByMinuteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CountByMinuteResponse build() => _build();

  _$CountByMinuteResponse _build() {
    final _$result = _$v ??
        _$CountByMinuteResponse._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'CountByMinuteResponse', 'count'),
          startTs: BuiltValueNullFieldError.checkNotNull(
              startTs, r'CountByMinuteResponse', 'startTs'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
