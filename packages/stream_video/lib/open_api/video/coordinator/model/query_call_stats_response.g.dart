// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallStatsResponse extends QueryCallStatsResponse {
  @override
  final String duration;
  @override
  final String? next;
  @override
  final String? prev;
  @override
  final BuiltList<CallStatsReportSummaryResponse> reports;

  factory _$QueryCallStatsResponse(
          [void Function(QueryCallStatsResponseBuilder)? updates]) =>
      (QueryCallStatsResponseBuilder()..update(updates))._build();

  _$QueryCallStatsResponse._(
      {required this.duration, this.next, this.prev, required this.reports})
      : super._();
  @override
  QueryCallStatsResponse rebuild(
          void Function(QueryCallStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallStatsResponseBuilder toBuilder() =>
      QueryCallStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallStatsResponse &&
        duration == other.duration &&
        next == other.next &&
        prev == other.prev &&
        reports == other.reports;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, prev.hashCode);
    _$hash = $jc(_$hash, reports.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallStatsResponse')
          ..add('duration', duration)
          ..add('next', next)
          ..add('prev', prev)
          ..add('reports', reports))
        .toString();
  }
}

class QueryCallStatsResponseBuilder
    implements Builder<QueryCallStatsResponse, QueryCallStatsResponseBuilder> {
  _$QueryCallStatsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _prev;
  String? get prev => _$this._prev;
  set prev(String? prev) => _$this._prev = prev;

  ListBuilder<CallStatsReportSummaryResponse>? _reports;
  ListBuilder<CallStatsReportSummaryResponse> get reports =>
      _$this._reports ??= ListBuilder<CallStatsReportSummaryResponse>();
  set reports(ListBuilder<CallStatsReportSummaryResponse>? reports) =>
      _$this._reports = reports;

  QueryCallStatsResponseBuilder() {
    QueryCallStatsResponse._defaults(this);
  }

  QueryCallStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _next = $v.next;
      _prev = $v.prev;
      _reports = $v.reports.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallStatsResponse other) {
    _$v = other as _$QueryCallStatsResponse;
  }

  @override
  void update(void Function(QueryCallStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallStatsResponse build() => _build();

  _$QueryCallStatsResponse _build() {
    _$QueryCallStatsResponse _$result;
    try {
      _$result = _$v ??
          _$QueryCallStatsResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'QueryCallStatsResponse', 'duration'),
            next: next,
            prev: prev,
            reports: reports.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reports';
        reports.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryCallStatsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
