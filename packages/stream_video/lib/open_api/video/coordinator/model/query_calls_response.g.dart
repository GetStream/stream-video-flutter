// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_calls_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallsResponse extends QueryCallsResponse {
  @override
  final BuiltList<CallStateResponseFields> calls;
  @override
  final String duration;
  @override
  final String? next;
  @override
  final String? prev;

  factory _$QueryCallsResponse(
          [void Function(QueryCallsResponseBuilder)? updates]) =>
      (QueryCallsResponseBuilder()..update(updates))._build();

  _$QueryCallsResponse._(
      {required this.calls, required this.duration, this.next, this.prev})
      : super._();
  @override
  QueryCallsResponse rebuild(
          void Function(QueryCallsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallsResponseBuilder toBuilder() =>
      QueryCallsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallsResponse &&
        calls == other.calls &&
        duration == other.duration &&
        next == other.next &&
        prev == other.prev;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, calls.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, prev.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallsResponse')
          ..add('calls', calls)
          ..add('duration', duration)
          ..add('next', next)
          ..add('prev', prev))
        .toString();
  }
}

class QueryCallsResponseBuilder
    implements Builder<QueryCallsResponse, QueryCallsResponseBuilder> {
  _$QueryCallsResponse? _$v;

  ListBuilder<CallStateResponseFields>? _calls;
  ListBuilder<CallStateResponseFields> get calls =>
      _$this._calls ??= ListBuilder<CallStateResponseFields>();
  set calls(ListBuilder<CallStateResponseFields>? calls) =>
      _$this._calls = calls;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _prev;
  String? get prev => _$this._prev;
  set prev(String? prev) => _$this._prev = prev;

  QueryCallsResponseBuilder() {
    QueryCallsResponse._defaults(this);
  }

  QueryCallsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _calls = $v.calls.toBuilder();
      _duration = $v.duration;
      _next = $v.next;
      _prev = $v.prev;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallsResponse other) {
    _$v = other as _$QueryCallsResponse;
  }

  @override
  void update(void Function(QueryCallsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallsResponse build() => _build();

  _$QueryCallsResponse _build() {
    _$QueryCallsResponse _$result;
    try {
      _$result = _$v ??
          _$QueryCallsResponse._(
            calls: calls.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'QueryCallsResponse', 'duration'),
            next: next,
            prev: prev,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'calls';
        calls.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryCallsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
