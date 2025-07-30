// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_stats_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallStatsRequest extends QueryCallStatsRequest {
  @override
  final BuiltMap<String, JsonObject?>? filterConditions;
  @override
  final int? limit;
  @override
  final String? next;
  @override
  final String? prev;
  @override
  final BuiltList<SortParamRequest?>? sort;

  factory _$QueryCallStatsRequest(
          [void Function(QueryCallStatsRequestBuilder)? updates]) =>
      (QueryCallStatsRequestBuilder()..update(updates))._build();

  _$QueryCallStatsRequest._(
      {this.filterConditions, this.limit, this.next, this.prev, this.sort})
      : super._();
  @override
  QueryCallStatsRequest rebuild(
          void Function(QueryCallStatsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallStatsRequestBuilder toBuilder() =>
      QueryCallStatsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallStatsRequest &&
        filterConditions == other.filterConditions &&
        limit == other.limit &&
        next == other.next &&
        prev == other.prev &&
        sort == other.sort;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filterConditions.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, prev.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallStatsRequest')
          ..add('filterConditions', filterConditions)
          ..add('limit', limit)
          ..add('next', next)
          ..add('prev', prev)
          ..add('sort', sort))
        .toString();
  }
}

class QueryCallStatsRequestBuilder
    implements Builder<QueryCallStatsRequest, QueryCallStatsRequestBuilder> {
  _$QueryCallStatsRequest? _$v;

  MapBuilder<String, JsonObject?>? _filterConditions;
  MapBuilder<String, JsonObject?> get filterConditions =>
      _$this._filterConditions ??= MapBuilder<String, JsonObject?>();
  set filterConditions(MapBuilder<String, JsonObject?>? filterConditions) =>
      _$this._filterConditions = filterConditions;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _prev;
  String? get prev => _$this._prev;
  set prev(String? prev) => _$this._prev = prev;

  ListBuilder<SortParamRequest?>? _sort;
  ListBuilder<SortParamRequest?> get sort =>
      _$this._sort ??= ListBuilder<SortParamRequest?>();
  set sort(ListBuilder<SortParamRequest?>? sort) => _$this._sort = sort;

  QueryCallStatsRequestBuilder() {
    QueryCallStatsRequest._defaults(this);
  }

  QueryCallStatsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filterConditions = $v.filterConditions?.toBuilder();
      _limit = $v.limit;
      _next = $v.next;
      _prev = $v.prev;
      _sort = $v.sort?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallStatsRequest other) {
    _$v = other as _$QueryCallStatsRequest;
  }

  @override
  void update(void Function(QueryCallStatsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallStatsRequest build() => _build();

  _$QueryCallStatsRequest _build() {
    _$QueryCallStatsRequest _$result;
    try {
      _$result = _$v ??
          _$QueryCallStatsRequest._(
            filterConditions: _filterConditions?.build(),
            limit: limit,
            next: next,
            prev: prev,
            sort: _sort?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filterConditions';
        _filterConditions?.build();

        _$failedField = 'sort';
        _sort?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryCallStatsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
