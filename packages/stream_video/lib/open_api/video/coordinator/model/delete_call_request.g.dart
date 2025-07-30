// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_call_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteCallRequest extends DeleteCallRequest {
  @override
  final bool? hard;

  factory _$DeleteCallRequest(
          [void Function(DeleteCallRequestBuilder)? updates]) =>
      (DeleteCallRequestBuilder()..update(updates))._build();

  _$DeleteCallRequest._({this.hard}) : super._();
  @override
  DeleteCallRequest rebuild(void Function(DeleteCallRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteCallRequestBuilder toBuilder() =>
      DeleteCallRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteCallRequest && hard == other.hard;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hard.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteCallRequest')
          ..add('hard', hard))
        .toString();
  }
}

class DeleteCallRequestBuilder
    implements Builder<DeleteCallRequest, DeleteCallRequestBuilder> {
  _$DeleteCallRequest? _$v;

  bool? _hard;
  bool? get hard => _$this._hard;
  set hard(bool? hard) => _$this._hard = hard;

  DeleteCallRequestBuilder() {
    DeleteCallRequest._defaults(this);
  }

  DeleteCallRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hard = $v.hard;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteCallRequest other) {
    _$v = other as _$DeleteCallRequest;
  }

  @override
  void update(void Function(DeleteCallRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteCallRequest build() => _build();

  _$DeleteCallRequest _build() {
    final _$result = _$v ??
        _$DeleteCallRequest._(
          hard: hard,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
