// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_rtmp_broadcasts_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartRTMPBroadcastsRequest extends StartRTMPBroadcastsRequest {
  @override
  final BuiltList<RTMPBroadcastRequest> broadcasts;

  factory _$StartRTMPBroadcastsRequest(
          [void Function(StartRTMPBroadcastsRequestBuilder)? updates]) =>
      (StartRTMPBroadcastsRequestBuilder()..update(updates))._build();

  _$StartRTMPBroadcastsRequest._({required this.broadcasts}) : super._();
  @override
  StartRTMPBroadcastsRequest rebuild(
          void Function(StartRTMPBroadcastsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartRTMPBroadcastsRequestBuilder toBuilder() =>
      StartRTMPBroadcastsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartRTMPBroadcastsRequest &&
        broadcasts == other.broadcasts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, broadcasts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StartRTMPBroadcastsRequest')
          ..add('broadcasts', broadcasts))
        .toString();
  }
}

class StartRTMPBroadcastsRequestBuilder
    implements
        Builder<StartRTMPBroadcastsRequest, StartRTMPBroadcastsRequestBuilder> {
  _$StartRTMPBroadcastsRequest? _$v;

  ListBuilder<RTMPBroadcastRequest>? _broadcasts;
  ListBuilder<RTMPBroadcastRequest> get broadcasts =>
      _$this._broadcasts ??= ListBuilder<RTMPBroadcastRequest>();
  set broadcasts(ListBuilder<RTMPBroadcastRequest>? broadcasts) =>
      _$this._broadcasts = broadcasts;

  StartRTMPBroadcastsRequestBuilder() {
    StartRTMPBroadcastsRequest._defaults(this);
  }

  StartRTMPBroadcastsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _broadcasts = $v.broadcasts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartRTMPBroadcastsRequest other) {
    _$v = other as _$StartRTMPBroadcastsRequest;
  }

  @override
  void update(void Function(StartRTMPBroadcastsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartRTMPBroadcastsRequest build() => _build();

  _$StartRTMPBroadcastsRequest _build() {
    _$StartRTMPBroadcastsRequest _$result;
    try {
      _$result = _$v ??
          _$StartRTMPBroadcastsRequest._(
            broadcasts: broadcasts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'broadcasts';
        broadcasts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StartRTMPBroadcastsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
