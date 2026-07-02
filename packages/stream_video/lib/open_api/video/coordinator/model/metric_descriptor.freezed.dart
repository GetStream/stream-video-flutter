// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric_descriptor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetricDescriptor {
  String? get description;
  String get label;
  String? get unit;

  /// Create a copy of MetricDescriptor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MetricDescriptorCopyWith<MetricDescriptor> get copyWith =>
      _$MetricDescriptorCopyWithImpl<MetricDescriptor>(
        this as MetricDescriptor,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MetricDescriptor &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, label, unit);

  @override
  String toString() {
    return 'MetricDescriptor(description: $description, label: $label, unit: $unit)';
  }
}

/// @nodoc
abstract mixin class $MetricDescriptorCopyWith<$Res> {
  factory $MetricDescriptorCopyWith(
    MetricDescriptor value,
    $Res Function(MetricDescriptor) _then,
  ) = _$MetricDescriptorCopyWithImpl;
  @useResult
  $Res call({String? description, String label, String? unit});
}

/// @nodoc
class _$MetricDescriptorCopyWithImpl<$Res>
    implements $MetricDescriptorCopyWith<$Res> {
  _$MetricDescriptorCopyWithImpl(this._self, this._then);

  final MetricDescriptor _self;
  final $Res Function(MetricDescriptor) _then;

  /// Create a copy of MetricDescriptor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? label = null,
    Object? unit = freezed,
  }) {
    return _then(
      MetricDescriptor(
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: freezed == unit
            ? _self.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
