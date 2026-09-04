// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noise_cancellation_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoiseCancellationSettings _$NoiseCancellationSettingsFromJson(
  Map<String, dynamic> json,
) => NoiseCancellationSettings(
  mode: NoiseCancellationSettingsMode.fromJson(json['mode'] as String),
);

Map<String, dynamic> _$NoiseCancellationSettingsToJson(
  NoiseCancellationSettings instance,
) => <String, dynamic>{'mode': instance.mode.toJson()};
