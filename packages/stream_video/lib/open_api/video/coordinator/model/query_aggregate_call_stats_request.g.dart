// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_aggregate_call_stats_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryAggregateCallStatsRequest extends QueryAggregateCallStatsRequest {
  @override
  final String? from;
  @override
  final BuiltList<String>? reportTypes;
  @override
  final String? to;

  factory _$QueryAggregateCallStatsRequest(
          [void Function(QueryAggregateCallStatsRequestBuilder)? updates]) =>
      (QueryAggregateCallStatsRequestBuilder()..update(updates))._build();

  _$QueryAggregateCallStatsRequest._({this.from, this.reportTypes, this.to})
      : super._();
  @override
  QueryAggregateCallStatsRequest rebuild(
          void Function(QueryAggregateCallStatsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryAggregateCallStatsRequestBuilder toBuilder() =>
      QueryAggregateCallStatsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryAggregateCallStatsRequest &&
        from == other.from &&
        reportTypes == other.reportTypes &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, reportTypes.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryAggregateCallStatsRequest')
          ..add('from', from)
          ..add('reportTypes', reportTypes)
          ..add('to', to))
        .toString();
  }
}

class QueryAggregateCallStatsRequestBuilder
    implements
        Builder<QueryAggregateCallStatsRequest,
            QueryAggregateCallStatsRequestBuilder> {
  _$QueryAggregateCallStatsRequest? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  ListBuilder<String>? _reportTypes;
  ListBuilder<String> get reportTypes =>
      _$this._reportTypes ??= ListBuilder<String>();
  set reportTypes(ListBuilder<String>? reportTypes) =>
      _$this._reportTypes = reportTypes;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  QueryAggregateCallStatsRequestBuilder() {
    QueryAggregateCallStatsRequest._defaults(this);
  }

  QueryAggregateCallStatsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _reportTypes = $v.reportTypes?.toBuilder();
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryAggregateCallStatsRequest other) {
    _$v = other as _$QueryAggregateCallStatsRequest;
  }

  @override
  void update(void Function(QueryAggregateCallStatsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryAggregateCallStatsRequest build() => _build();

  _$QueryAggregateCallStatsRequest _build() {
    _$QueryAggregateCallStatsRequest _$result;
    try {
      _$result = _$v ??
          _$QueryAggregateCallStatsRequest._(
            from: from,
            reportTypes: _reportTypes?.build(),
            to: to,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reportTypes';
        _reportTypes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryAggregateCallStatsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
