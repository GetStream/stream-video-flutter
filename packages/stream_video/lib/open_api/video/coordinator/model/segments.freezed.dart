// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'segments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Segments {
  List<BroadcastSegment> get byBrowser;
  List<BroadcastSegment> get byCountry;
  String get byCountryReason;
  List<DeliveryZoneSegment> get byDeliveryZone;
  List<BroadcastSegment> get byOs;
  List<BroadcastSegment> get bySdk;

  /// Create a copy of Segments
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SegmentsCopyWith<Segments> get copyWith =>
      _$SegmentsCopyWithImpl<Segments>(this as Segments, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Segments &&
            const DeepCollectionEquality().equals(other.byBrowser, byBrowser) &&
            const DeepCollectionEquality().equals(other.byCountry, byCountry) &&
            (identical(other.byCountryReason, byCountryReason) ||
                other.byCountryReason == byCountryReason) &&
            const DeepCollectionEquality().equals(
              other.byDeliveryZone,
              byDeliveryZone,
            ) &&
            const DeepCollectionEquality().equals(other.byOs, byOs) &&
            const DeepCollectionEquality().equals(other.bySdk, bySdk));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(byBrowser),
    const DeepCollectionEquality().hash(byCountry),
    byCountryReason,
    const DeepCollectionEquality().hash(byDeliveryZone),
    const DeepCollectionEquality().hash(byOs),
    const DeepCollectionEquality().hash(bySdk),
  );

  @override
  String toString() {
    return 'Segments(byBrowser: $byBrowser, byCountry: $byCountry, byCountryReason: $byCountryReason, byDeliveryZone: $byDeliveryZone, byOs: $byOs, bySdk: $bySdk)';
  }
}

/// @nodoc
abstract mixin class $SegmentsCopyWith<$Res> {
  factory $SegmentsCopyWith(Segments value, $Res Function(Segments) _then) =
      _$SegmentsCopyWithImpl;
  @useResult
  $Res call({
    List<BroadcastSegment> byBrowser,
    List<BroadcastSegment> byCountry,
    String byCountryReason,
    List<DeliveryZoneSegment> byDeliveryZone,
    List<BroadcastSegment> byOs,
    List<BroadcastSegment> bySdk,
  });
}

/// @nodoc
class _$SegmentsCopyWithImpl<$Res> implements $SegmentsCopyWith<$Res> {
  _$SegmentsCopyWithImpl(this._self, this._then);

  final Segments _self;
  final $Res Function(Segments) _then;

  /// Create a copy of Segments
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? byBrowser = null,
    Object? byCountry = null,
    Object? byCountryReason = null,
    Object? byDeliveryZone = null,
    Object? byOs = null,
    Object? bySdk = null,
  }) {
    return _then(
      Segments(
        byBrowser: null == byBrowser
            ? _self.byBrowser
            : byBrowser // ignore: cast_nullable_to_non_nullable
                  as List<BroadcastSegment>,
        byCountry: null == byCountry
            ? _self.byCountry
            : byCountry // ignore: cast_nullable_to_non_nullable
                  as List<BroadcastSegment>,
        byCountryReason: null == byCountryReason
            ? _self.byCountryReason
            : byCountryReason // ignore: cast_nullable_to_non_nullable
                  as String,
        byDeliveryZone: null == byDeliveryZone
            ? _self.byDeliveryZone
            : byDeliveryZone // ignore: cast_nullable_to_non_nullable
                  as List<DeliveryZoneSegment>,
        byOs: null == byOs
            ? _self.byOs
            : byOs // ignore: cast_nullable_to_non_nullable
                  as List<BroadcastSegment>,
        bySdk: null == bySdk
            ? _self.bySdk
            : bySdk // ignore: cast_nullable_to_non_nullable
                  as List<BroadcastSegment>,
      ),
    );
  }
}
