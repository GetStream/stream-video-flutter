// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_members_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallMembersRequest extends QueryCallMembersRequest {
  @override
  final BuiltMap<String, JsonObject?>? filterConditions;
  @override
  final String id;
  @override
  final int? limit;
  @override
  final String? next;
  @override
  final String? prev;
  @override
  final BuiltList<SortParamRequest?>? sort;
  @override
  final String type;

  factory _$QueryCallMembersRequest(
          [void Function(QueryCallMembersRequestBuilder)? updates]) =>
      (QueryCallMembersRequestBuilder()..update(updates))._build();

  _$QueryCallMembersRequest._(
      {this.filterConditions,
      required this.id,
      this.limit,
      this.next,
      this.prev,
      this.sort,
      required this.type})
      : super._();
  @override
  QueryCallMembersRequest rebuild(
          void Function(QueryCallMembersRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallMembersRequestBuilder toBuilder() =>
      QueryCallMembersRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallMembersRequest &&
        filterConditions == other.filterConditions &&
        id == other.id &&
        limit == other.limit &&
        next == other.next &&
        prev == other.prev &&
        sort == other.sort &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filterConditions.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, prev.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallMembersRequest')
          ..add('filterConditions', filterConditions)
          ..add('id', id)
          ..add('limit', limit)
          ..add('next', next)
          ..add('prev', prev)
          ..add('sort', sort)
          ..add('type', type))
        .toString();
  }
}

class QueryCallMembersRequestBuilder
    implements
        Builder<QueryCallMembersRequest, QueryCallMembersRequestBuilder> {
  _$QueryCallMembersRequest? _$v;

  MapBuilder<String, JsonObject?>? _filterConditions;
  MapBuilder<String, JsonObject?> get filterConditions =>
      _$this._filterConditions ??= MapBuilder<String, JsonObject?>();
  set filterConditions(MapBuilder<String, JsonObject?>? filterConditions) =>
      _$this._filterConditions = filterConditions;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  QueryCallMembersRequestBuilder() {
    QueryCallMembersRequest._defaults(this);
  }

  QueryCallMembersRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filterConditions = $v.filterConditions?.toBuilder();
      _id = $v.id;
      _limit = $v.limit;
      _next = $v.next;
      _prev = $v.prev;
      _sort = $v.sort?.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallMembersRequest other) {
    _$v = other as _$QueryCallMembersRequest;
  }

  @override
  void update(void Function(QueryCallMembersRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallMembersRequest build() => _build();

  _$QueryCallMembersRequest _build() {
    _$QueryCallMembersRequest _$result;
    try {
      _$result = _$v ??
          _$QueryCallMembersRequest._(
            filterConditions: _filterConditions?.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'QueryCallMembersRequest', 'id'),
            limit: limit,
            next: next,
            prev: prev,
            sort: _sort?.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'QueryCallMembersRequest', 'type'),
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
            r'QueryCallMembersRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
