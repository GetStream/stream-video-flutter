// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_calls_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallsRequest extends QueryCallsRequest {
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
  @override
  final bool? watch;

  factory _$QueryCallsRequest(
          [void Function(QueryCallsRequestBuilder)? updates]) =>
      (QueryCallsRequestBuilder()..update(updates))._build();

  _$QueryCallsRequest._(
      {this.filterConditions,
      this.limit,
      this.next,
      this.prev,
      this.sort,
      this.watch})
      : super._();
  @override
  QueryCallsRequest rebuild(void Function(QueryCallsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallsRequestBuilder toBuilder() =>
      QueryCallsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallsRequest &&
        filterConditions == other.filterConditions &&
        limit == other.limit &&
        next == other.next &&
        prev == other.prev &&
        sort == other.sort &&
        watch == other.watch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filterConditions.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, prev.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, watch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallsRequest')
          ..add('filterConditions', filterConditions)
          ..add('limit', limit)
          ..add('next', next)
          ..add('prev', prev)
          ..add('sort', sort)
          ..add('watch', watch))
        .toString();
  }
}

class QueryCallsRequestBuilder
    implements Builder<QueryCallsRequest, QueryCallsRequestBuilder> {
  _$QueryCallsRequest? _$v;

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

  bool? _watch;
  bool? get watch => _$this._watch;
  set watch(bool? watch) => _$this._watch = watch;

  QueryCallsRequestBuilder() {
    QueryCallsRequest._defaults(this);
  }

  QueryCallsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filterConditions = $v.filterConditions?.toBuilder();
      _limit = $v.limit;
      _next = $v.next;
      _prev = $v.prev;
      _sort = $v.sort?.toBuilder();
      _watch = $v.watch;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallsRequest other) {
    _$v = other as _$QueryCallsRequest;
  }

  @override
  void update(void Function(QueryCallsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallsRequest build() => _build();

  _$QueryCallsRequest _build() {
    _$QueryCallsRequest _$result;
    try {
      _$result = _$v ??
          _$QueryCallsRequest._(
            filterConditions: _filterConditions?.build(),
            limit: limit,
            next: next,
            prev: prev,
            sort: _sort?.build(),
            watch: watch,
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
            r'QueryCallsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
