// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_user_feedback_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectUserFeedbackRequest extends CollectUserFeedbackRequest {
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final int rating;
  @override
  final String? reason;
  @override
  final String sdk;
  @override
  final String sdkVersion;
  @override
  final String? userSessionId;

  factory _$CollectUserFeedbackRequest(
          [void Function(CollectUserFeedbackRequestBuilder)? updates]) =>
      (CollectUserFeedbackRequestBuilder()..update(updates))._build();

  _$CollectUserFeedbackRequest._(
      {this.custom,
      required this.rating,
      this.reason,
      required this.sdk,
      required this.sdkVersion,
      this.userSessionId})
      : super._();
  @override
  CollectUserFeedbackRequest rebuild(
          void Function(CollectUserFeedbackRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CollectUserFeedbackRequestBuilder toBuilder() =>
      CollectUserFeedbackRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectUserFeedbackRequest &&
        custom == other.custom &&
        rating == other.rating &&
        reason == other.reason &&
        sdk == other.sdk &&
        sdkVersion == other.sdkVersion &&
        userSessionId == other.userSessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, sdk.hashCode);
    _$hash = $jc(_$hash, sdkVersion.hashCode);
    _$hash = $jc(_$hash, userSessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CollectUserFeedbackRequest')
          ..add('custom', custom)
          ..add('rating', rating)
          ..add('reason', reason)
          ..add('sdk', sdk)
          ..add('sdkVersion', sdkVersion)
          ..add('userSessionId', userSessionId))
        .toString();
  }
}

class CollectUserFeedbackRequestBuilder
    implements
        Builder<CollectUserFeedbackRequest, CollectUserFeedbackRequestBuilder> {
  _$CollectUserFeedbackRequest? _$v;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _sdk;
  String? get sdk => _$this._sdk;
  set sdk(String? sdk) => _$this._sdk = sdk;

  String? _sdkVersion;
  String? get sdkVersion => _$this._sdkVersion;
  set sdkVersion(String? sdkVersion) => _$this._sdkVersion = sdkVersion;

  String? _userSessionId;
  String? get userSessionId => _$this._userSessionId;
  set userSessionId(String? userSessionId) =>
      _$this._userSessionId = userSessionId;

  CollectUserFeedbackRequestBuilder() {
    CollectUserFeedbackRequest._defaults(this);
  }

  CollectUserFeedbackRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _rating = $v.rating;
      _reason = $v.reason;
      _sdk = $v.sdk;
      _sdkVersion = $v.sdkVersion;
      _userSessionId = $v.userSessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectUserFeedbackRequest other) {
    _$v = other as _$CollectUserFeedbackRequest;
  }

  @override
  void update(void Function(CollectUserFeedbackRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectUserFeedbackRequest build() => _build();

  _$CollectUserFeedbackRequest _build() {
    _$CollectUserFeedbackRequest _$result;
    try {
      _$result = _$v ??
          _$CollectUserFeedbackRequest._(
            custom: _custom?.build(),
            rating: BuiltValueNullFieldError.checkNotNull(
                rating, r'CollectUserFeedbackRequest', 'rating'),
            reason: reason,
            sdk: BuiltValueNullFieldError.checkNotNull(
                sdk, r'CollectUserFeedbackRequest', 'sdk'),
            sdkVersion: BuiltValueNullFieldError.checkNotNull(
                sdkVersion, r'CollectUserFeedbackRequest', 'sdkVersion'),
            userSessionId: userSessionId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CollectUserFeedbackRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
