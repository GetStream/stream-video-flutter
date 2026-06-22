// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
  fixedHeight: ImageData.fromJson(json['fixed_height'] as Map<String, dynamic>),
  fixedHeightDownsampled: ImageData.fromJson(
    json['fixed_height_downsampled'] as Map<String, dynamic>,
  ),
  fixedHeightStill: ImageData.fromJson(
    json['fixed_height_still'] as Map<String, dynamic>,
  ),
  fixedWidth: ImageData.fromJson(json['fixed_width'] as Map<String, dynamic>),
  fixedWidthDownsampled: ImageData.fromJson(
    json['fixed_width_downsampled'] as Map<String, dynamic>,
  ),
  fixedWidthStill: ImageData.fromJson(
    json['fixed_width_still'] as Map<String, dynamic>,
  ),
  original: ImageData.fromJson(json['original'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
  'fixed_height': instance.fixedHeight,
  'fixed_height_downsampled': instance.fixedHeightDownsampled,
  'fixed_height_still': instance.fixedHeightStill,
  'fixed_width': instance.fixedWidth,
  'fixed_width_downsampled': instance.fixedWidthDownsampled,
  'fixed_width_still': instance.fixedWidthStill,
  'original': instance.original,
};
