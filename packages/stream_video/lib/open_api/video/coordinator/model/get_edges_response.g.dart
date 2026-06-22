// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_edges_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEdgesResponse _$GetEdgesResponseFromJson(Map<String, dynamic> json) =>
    GetEdgesResponse(
      duration: json['duration'] as String,
      edges:
          (json['edges'] as List<dynamic>?)
              ?.map((e) => EdgeResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetEdgesResponseToJson(GetEdgesResponse instance) =>
    <String, dynamic>{'duration': instance.duration, 'edges': instance.edges};
