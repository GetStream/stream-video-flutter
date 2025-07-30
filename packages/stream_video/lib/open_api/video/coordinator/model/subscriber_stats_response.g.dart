// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriber_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriberStatsResponse extends SubscriberStatsResponse {
  @override
  final int total;
  @override
  final int totalSubscribedDurationSeconds;
  @override
  final int unique;

  factory _$SubscriberStatsResponse(
          [void Function(SubscriberStatsResponseBuilder)? updates]) =>
      (SubscriberStatsResponseBuilder()..update(updates))._build();

  _$SubscriberStatsResponse._(
      {required this.total,
      required this.totalSubscribedDurationSeconds,
      required this.unique})
      : super._();
  @override
  SubscriberStatsResponse rebuild(
          void Function(SubscriberStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriberStatsResponseBuilder toBuilder() =>
      SubscriberStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriberStatsResponse &&
        total == other.total &&
        totalSubscribedDurationSeconds ==
            other.totalSubscribedDurationSeconds &&
        unique == other.unique;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, totalSubscribedDurationSeconds.hashCode);
    _$hash = $jc(_$hash, unique.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriberStatsResponse')
          ..add('total', total)
          ..add(
              'totalSubscribedDurationSeconds', totalSubscribedDurationSeconds)
          ..add('unique', unique))
        .toString();
  }
}

class SubscriberStatsResponseBuilder
    implements
        Builder<SubscriberStatsResponse, SubscriberStatsResponseBuilder> {
  _$SubscriberStatsResponse? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _totalSubscribedDurationSeconds;
  int? get totalSubscribedDurationSeconds =>
      _$this._totalSubscribedDurationSeconds;
  set totalSubscribedDurationSeconds(int? totalSubscribedDurationSeconds) =>
      _$this._totalSubscribedDurationSeconds = totalSubscribedDurationSeconds;

  int? _unique;
  int? get unique => _$this._unique;
  set unique(int? unique) => _$this._unique = unique;

  SubscriberStatsResponseBuilder() {
    SubscriberStatsResponse._defaults(this);
  }

  SubscriberStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _totalSubscribedDurationSeconds = $v.totalSubscribedDurationSeconds;
      _unique = $v.unique;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriberStatsResponse other) {
    _$v = other as _$SubscriberStatsResponse;
  }

  @override
  void update(void Function(SubscriberStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriberStatsResponse build() => _build();

  _$SubscriberStatsResponse _build() {
    final _$result = _$v ??
        _$SubscriberStatsResponse._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'SubscriberStatsResponse', 'total'),
          totalSubscribedDurationSeconds: BuiltValueNullFieldError.checkNotNull(
              totalSubscribedDurationSeconds,
              r'SubscriberStatsResponse',
              'totalSubscribedDurationSeconds'),
          unique: BuiltValueNullFieldError.checkNotNull(
              unique, r'SubscriberStatsResponse', 'unique'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
