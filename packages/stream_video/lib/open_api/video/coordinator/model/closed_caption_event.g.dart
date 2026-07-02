// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closed_caption_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClosedCaptionEvent _$ClosedCaptionEventFromJson(Map<String, dynamic> json) =>
    ClosedCaptionEvent(
      callCid: json['call_cid'] as String,
      closedCaption: CallClosedCaption.fromJson(
        json['closed_caption'] as Map<String, dynamic>,
      ),
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ClosedCaptionEventToJson(ClosedCaptionEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'closed_caption': instance.closedCaption.toJson(),
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
    };
