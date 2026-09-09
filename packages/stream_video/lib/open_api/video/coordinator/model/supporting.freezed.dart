// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supporting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Supporting {
  List<Incident> get deliveryIncidentWindows;
  List<String> get edgeOutlierZones;
  List<TimeWindow> get sourceDropWindows;

  /// Create a copy of Supporting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportingCopyWith<Supporting> get copyWith =>
      _$SupportingCopyWithImpl<Supporting>(this as Supporting, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Supporting &&
            const DeepCollectionEquality().equals(
              other.deliveryIncidentWindows,
              deliveryIncidentWindows,
            ) &&
            const DeepCollectionEquality().equals(
              other.edgeOutlierZones,
              edgeOutlierZones,
            ) &&
            const DeepCollectionEquality().equals(
              other.sourceDropWindows,
              sourceDropWindows,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(deliveryIncidentWindows),
    const DeepCollectionEquality().hash(edgeOutlierZones),
    const DeepCollectionEquality().hash(sourceDropWindows),
  );

  @override
  String toString() {
    return 'Supporting(deliveryIncidentWindows: $deliveryIncidentWindows, edgeOutlierZones: $edgeOutlierZones, sourceDropWindows: $sourceDropWindows)';
  }
}

/// @nodoc
abstract mixin class $SupportingCopyWith<$Res> {
  factory $SupportingCopyWith(
    Supporting value,
    $Res Function(Supporting) _then,
  ) = _$SupportingCopyWithImpl;
  @useResult
  $Res call({
    List<Incident> deliveryIncidentWindows,
    List<String> edgeOutlierZones,
    List<TimeWindow> sourceDropWindows,
  });
}

/// @nodoc
class _$SupportingCopyWithImpl<$Res> implements $SupportingCopyWith<$Res> {
  _$SupportingCopyWithImpl(this._self, this._then);

  final Supporting _self;
  final $Res Function(Supporting) _then;

  /// Create a copy of Supporting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryIncidentWindows = null,
    Object? edgeOutlierZones = null,
    Object? sourceDropWindows = null,
  }) {
    return _then(
      Supporting(
        deliveryIncidentWindows: null == deliveryIncidentWindows
            ? _self.deliveryIncidentWindows
            : deliveryIncidentWindows // ignore: cast_nullable_to_non_nullable
                  as List<Incident>,
        edgeOutlierZones: null == edgeOutlierZones
            ? _self.edgeOutlierZones
            : edgeOutlierZones // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sourceDropWindows: null == sourceDropWindows
            ? _self.sourceDropWindows
            : sourceDropWindows // ignore: cast_nullable_to_non_nullable
                  as List<TimeWindow>,
      ),
    );
  }
}
