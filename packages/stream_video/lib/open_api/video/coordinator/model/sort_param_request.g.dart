// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_param_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SortParamRequest extends SortParamRequest {
  @override
  final int? direction;
  @override
  final String? field;

  factory _$SortParamRequest(
          [void Function(SortParamRequestBuilder)? updates]) =>
      (SortParamRequestBuilder()..update(updates))._build();

  _$SortParamRequest._({this.direction, this.field}) : super._();
  @override
  SortParamRequest rebuild(void Function(SortParamRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SortParamRequestBuilder toBuilder() =>
      SortParamRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SortParamRequest &&
        direction == other.direction &&
        field == other.field;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SortParamRequest')
          ..add('direction', direction)
          ..add('field', field))
        .toString();
  }
}

class SortParamRequestBuilder
    implements Builder<SortParamRequest, SortParamRequestBuilder> {
  _$SortParamRequest? _$v;

  int? _direction;
  int? get direction => _$this._direction;
  set direction(int? direction) => _$this._direction = direction;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  SortParamRequestBuilder() {
    SortParamRequest._defaults(this);
  }

  SortParamRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _direction = $v.direction;
      _field = $v.field;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SortParamRequest other) {
    _$v = other as _$SortParamRequest;
  }

  @override
  void update(void Function(SortParamRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SortParamRequest build() => _build();

  _$SortParamRequest _build() {
    final _$result = _$v ??
        _$SortParamRequest._(
          direction: direction,
          field: field,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
