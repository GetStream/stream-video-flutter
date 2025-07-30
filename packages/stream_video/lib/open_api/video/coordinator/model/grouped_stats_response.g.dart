// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupedStatsResponse extends GroupedStatsResponse {
  @override
  final String name;
  @override
  final int unique;

  factory _$GroupedStatsResponse(
          [void Function(GroupedStatsResponseBuilder)? updates]) =>
      (GroupedStatsResponseBuilder()..update(updates))._build();

  _$GroupedStatsResponse._({required this.name, required this.unique})
      : super._();
  @override
  GroupedStatsResponse rebuild(
          void Function(GroupedStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupedStatsResponseBuilder toBuilder() =>
      GroupedStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupedStatsResponse &&
        name == other.name &&
        unique == other.unique;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, unique.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupedStatsResponse')
          ..add('name', name)
          ..add('unique', unique))
        .toString();
  }
}

class GroupedStatsResponseBuilder
    implements Builder<GroupedStatsResponse, GroupedStatsResponseBuilder> {
  _$GroupedStatsResponse? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _unique;
  int? get unique => _$this._unique;
  set unique(int? unique) => _$this._unique = unique;

  GroupedStatsResponseBuilder() {
    GroupedStatsResponse._defaults(this);
  }

  GroupedStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _unique = $v.unique;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupedStatsResponse other) {
    _$v = other as _$GroupedStatsResponse;
  }

  @override
  void update(void Function(GroupedStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupedStatsResponse build() => _build();

  _$GroupedStatsResponse _build() {
    final _$result = _$v ??
        _$GroupedStatsResponse._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GroupedStatsResponse', 'name'),
          unique: BuiltValueNullFieldError.checkNotNull(
              unique, r'GroupedStatsResponse', 'unique'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
