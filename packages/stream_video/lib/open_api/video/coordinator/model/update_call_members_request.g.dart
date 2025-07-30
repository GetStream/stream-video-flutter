// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_call_members_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCallMembersRequest extends UpdateCallMembersRequest {
  @override
  final BuiltList<String>? removeMembers;
  @override
  final BuiltList<MemberRequest>? updateMembers;

  factory _$UpdateCallMembersRequest(
          [void Function(UpdateCallMembersRequestBuilder)? updates]) =>
      (UpdateCallMembersRequestBuilder()..update(updates))._build();

  _$UpdateCallMembersRequest._({this.removeMembers, this.updateMembers})
      : super._();
  @override
  UpdateCallMembersRequest rebuild(
          void Function(UpdateCallMembersRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCallMembersRequestBuilder toBuilder() =>
      UpdateCallMembersRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCallMembersRequest &&
        removeMembers == other.removeMembers &&
        updateMembers == other.updateMembers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, removeMembers.hashCode);
    _$hash = $jc(_$hash, updateMembers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCallMembersRequest')
          ..add('removeMembers', removeMembers)
          ..add('updateMembers', updateMembers))
        .toString();
  }
}

class UpdateCallMembersRequestBuilder
    implements
        Builder<UpdateCallMembersRequest, UpdateCallMembersRequestBuilder> {
  _$UpdateCallMembersRequest? _$v;

  ListBuilder<String>? _removeMembers;
  ListBuilder<String> get removeMembers =>
      _$this._removeMembers ??= ListBuilder<String>();
  set removeMembers(ListBuilder<String>? removeMembers) =>
      _$this._removeMembers = removeMembers;

  ListBuilder<MemberRequest>? _updateMembers;
  ListBuilder<MemberRequest> get updateMembers =>
      _$this._updateMembers ??= ListBuilder<MemberRequest>();
  set updateMembers(ListBuilder<MemberRequest>? updateMembers) =>
      _$this._updateMembers = updateMembers;

  UpdateCallMembersRequestBuilder() {
    UpdateCallMembersRequest._defaults(this);
  }

  UpdateCallMembersRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _removeMembers = $v.removeMembers?.toBuilder();
      _updateMembers = $v.updateMembers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCallMembersRequest other) {
    _$v = other as _$UpdateCallMembersRequest;
  }

  @override
  void update(void Function(UpdateCallMembersRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCallMembersRequest build() => _build();

  _$UpdateCallMembersRequest _build() {
    _$UpdateCallMembersRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateCallMembersRequest._(
            removeMembers: _removeMembers?.build(),
            updateMembers: _updateMembers?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'removeMembers';
        _removeMembers?.build();
        _$failedField = 'updateMembers';
        _updateMembers?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateCallMembersRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
