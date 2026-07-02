// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListOptions _$BlockListOptionsFromJson(Map<String, dynamic> json) =>
    BlockListOptions(
      behavior: $enumDecode(
        _$BlockListOptionsBehaviorEnumMap,
        json['behavior'],
        unknownValue: BlockListOptionsBehavior.unknown,
      ),
      blocklist: json['blocklist'] as String,
    );

Map<String, dynamic> _$BlockListOptionsToJson(BlockListOptions instance) =>
    <String, dynamic>{
      'behavior': _$BlockListOptionsBehaviorEnumMap[instance.behavior]!,
      'blocklist': instance.blocklist,
    };

const _$BlockListOptionsBehaviorEnumMap = {
  BlockListOptionsBehavior.block: 'block',
  BlockListOptionsBehavior.flag: 'flag',
  BlockListOptionsBehavior.shadowBlock: 'shadow_block',
  BlockListOptionsBehavior.unknown: '_unknown',
};
