// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      created: Video._dateTimeFromTimestamp(json['created'] as Timestamp),
      uploadId: json['uploadId'] as String?,
      connectionId: json['connectionId'] as String? ?? '',
      superuserId: json['superuserId'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      playbackIds: (json['playbackIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: json['status'] as String? ?? '',
      assetId: json['assetId'] as String? ?? '',
      views: json['views'] as int? ?? 0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      deleted: json['deleted'] as bool? ?? false,
      unwatchedIds: (json['unwatchedIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'uploadId': instance.uploadId,
      'superuserId': instance.superuserId,
      'connectionId': instance.connectionId,
      'caption': instance.caption,
      'playbackIds': instance.playbackIds,
      'status': instance.status,
      'assetId': instance.assetId,
      'views': instance.views,
      'duration': instance.duration,
      'deleted': instance.deleted,
      'unwatchedIds': instance.unwatchedIds,
      'created': Video._dateTimeAsIs(instance.created),
    };
