// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublisherStatsResponse extends PublisherStatsResponse {
  @override
  final BuiltList<TrackStatsResponse?>? byTrack;
  @override
  final int total;
  @override
  final int unique;

  factory _$PublisherStatsResponse(
          [void Function(PublisherStatsResponseBuilder)? updates]) =>
      (PublisherStatsResponseBuilder()..update(updates))._build();

  _$PublisherStatsResponse._(
      {this.byTrack, required this.total, required this.unique})
      : super._();
  @override
  PublisherStatsResponse rebuild(
          void Function(PublisherStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublisherStatsResponseBuilder toBuilder() =>
      PublisherStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublisherStatsResponse &&
        byTrack == other.byTrack &&
        total == other.total &&
        unique == other.unique;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byTrack.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, unique.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublisherStatsResponse')
          ..add('byTrack', byTrack)
          ..add('total', total)
          ..add('unique', unique))
        .toString();
  }
}

class PublisherStatsResponseBuilder
    implements Builder<PublisherStatsResponse, PublisherStatsResponseBuilder> {
  _$PublisherStatsResponse? _$v;

  ListBuilder<TrackStatsResponse?>? _byTrack;
  ListBuilder<TrackStatsResponse?> get byTrack =>
      _$this._byTrack ??= ListBuilder<TrackStatsResponse?>();
  set byTrack(ListBuilder<TrackStatsResponse?>? byTrack) =>
      _$this._byTrack = byTrack;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _unique;
  int? get unique => _$this._unique;
  set unique(int? unique) => _$this._unique = unique;

  PublisherStatsResponseBuilder() {
    PublisherStatsResponse._defaults(this);
  }

  PublisherStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byTrack = $v.byTrack?.toBuilder();
      _total = $v.total;
      _unique = $v.unique;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublisherStatsResponse other) {
    _$v = other as _$PublisherStatsResponse;
  }

  @override
  void update(void Function(PublisherStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublisherStatsResponse build() => _build();

  _$PublisherStatsResponse _build() {
    _$PublisherStatsResponse _$result;
    try {
      _$result = _$v ??
          _$PublisherStatsResponse._(
            byTrack: _byTrack?.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PublisherStatsResponse', 'total'),
            unique: BuiltValueNullFieldError.checkNotNull(
                unique, r'PublisherStatsResponse', 'unique'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byTrack';
        _byTrack?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublisherStatsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
