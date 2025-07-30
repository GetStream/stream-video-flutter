// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_participants_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallParticipantsRequest extends QueryCallParticipantsRequest {
  @override
  final BuiltMap<String, JsonObject?>? filterConditions;

  factory _$QueryCallParticipantsRequest(
          [void Function(QueryCallParticipantsRequestBuilder)? updates]) =>
      (QueryCallParticipantsRequestBuilder()..update(updates))._build();

  _$QueryCallParticipantsRequest._({this.filterConditions}) : super._();
  @override
  QueryCallParticipantsRequest rebuild(
          void Function(QueryCallParticipantsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallParticipantsRequestBuilder toBuilder() =>
      QueryCallParticipantsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallParticipantsRequest &&
        filterConditions == other.filterConditions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filterConditions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallParticipantsRequest')
          ..add('filterConditions', filterConditions))
        .toString();
  }
}

class QueryCallParticipantsRequestBuilder
    implements
        Builder<QueryCallParticipantsRequest,
            QueryCallParticipantsRequestBuilder> {
  _$QueryCallParticipantsRequest? _$v;

  MapBuilder<String, JsonObject?>? _filterConditions;
  MapBuilder<String, JsonObject?> get filterConditions =>
      _$this._filterConditions ??= MapBuilder<String, JsonObject?>();
  set filterConditions(MapBuilder<String, JsonObject?>? filterConditions) =>
      _$this._filterConditions = filterConditions;

  QueryCallParticipantsRequestBuilder() {
    QueryCallParticipantsRequest._defaults(this);
  }

  QueryCallParticipantsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filterConditions = $v.filterConditions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallParticipantsRequest other) {
    _$v = other as _$QueryCallParticipantsRequest;
  }

  @override
  void update(void Function(QueryCallParticipantsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallParticipantsRequest build() => _build();

  _$QueryCallParticipantsRequest _build() {
    _$QueryCallParticipantsRequest _$result;
    try {
      _$result = _$v ??
          _$QueryCallParticipantsRequest._(
            filterConditions: _filterConditions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filterConditions';
        _filterConditions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryCallParticipantsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
