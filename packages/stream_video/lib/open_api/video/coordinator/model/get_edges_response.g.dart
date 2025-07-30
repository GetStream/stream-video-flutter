// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_edges_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetEdgesResponse extends GetEdgesResponse {
  @override
  final String duration;
  @override
  final BuiltList<EdgeResponse> edges;

  factory _$GetEdgesResponse(
          [void Function(GetEdgesResponseBuilder)? updates]) =>
      (GetEdgesResponseBuilder()..update(updates))._build();

  _$GetEdgesResponse._({required this.duration, required this.edges})
      : super._();
  @override
  GetEdgesResponse rebuild(void Function(GetEdgesResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetEdgesResponseBuilder toBuilder() =>
      GetEdgesResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetEdgesResponse &&
        duration == other.duration &&
        edges == other.edges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, edges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetEdgesResponse')
          ..add('duration', duration)
          ..add('edges', edges))
        .toString();
  }
}

class GetEdgesResponseBuilder
    implements Builder<GetEdgesResponse, GetEdgesResponseBuilder> {
  _$GetEdgesResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<EdgeResponse>? _edges;
  ListBuilder<EdgeResponse> get edges =>
      _$this._edges ??= ListBuilder<EdgeResponse>();
  set edges(ListBuilder<EdgeResponse>? edges) => _$this._edges = edges;

  GetEdgesResponseBuilder() {
    GetEdgesResponse._defaults(this);
  }

  GetEdgesResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _edges = $v.edges.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetEdgesResponse other) {
    _$v = other as _$GetEdgesResponse;
  }

  @override
  void update(void Function(GetEdgesResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetEdgesResponse build() => _build();

  _$GetEdgesResponse _build() {
    _$GetEdgesResponse _$result;
    try {
      _$result = _$v ??
          _$GetEdgesResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'GetEdgesResponse', 'duration'),
            edges: edges.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'edges';
        edges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetEdgesResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
