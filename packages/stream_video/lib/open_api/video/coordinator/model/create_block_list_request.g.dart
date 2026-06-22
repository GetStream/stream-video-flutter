// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_block_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBlockListRequest _$CreateBlockListRequestFromJson(
  Map<String, dynamic> json,
) => CreateBlockListRequest(
  isLeetCheckEnabled: json['is_leet_check_enabled'] as bool?,
  isPluralCheckEnabled: json['is_plural_check_enabled'] as bool?,
  name: json['name'] as String,
  team: json['team'] as String?,
  type: $enumDecodeNullable(
    _$CreateBlockListRequestTypeEnumMap,
    json['type'],
    unknownValue: CreateBlockListRequestType.unknown,
  ),
  words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateBlockListRequestToJson(
  CreateBlockListRequest instance,
) => <String, dynamic>{
  'is_leet_check_enabled': instance.isLeetCheckEnabled,
  'is_plural_check_enabled': instance.isPluralCheckEnabled,
  'name': instance.name,
  'team': instance.team,
  'type': _$CreateBlockListRequestTypeEnumMap[instance.type],
  'words': instance.words,
};

const _$CreateBlockListRequestTypeEnumMap = {
  CreateBlockListRequestType.domain: 'domain',
  CreateBlockListRequestType.domainAllowlist: 'domain_allowlist',
  CreateBlockListRequestType.email: 'email',
  CreateBlockListRequestType.emailAllowlist: 'email_allowlist',
  CreateBlockListRequestType.regex: 'regex',
  CreateBlockListRequestType.word: 'word',
  CreateBlockListRequestType.unknown: '_unknown',
};
