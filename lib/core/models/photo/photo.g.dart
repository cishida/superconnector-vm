// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      created: Photo._dateTimeFromTimestamp(json['created'] as Timestamp),
      url: json['url'] as String? ?? '',
      connectionId: json['connectionId'] as String? ?? '',
      superuserId: json['superuserId'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      filter: json['filter'] as String? ?? '',
      status: json['status'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
      unwatchedIds: (json['unwatchedIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'url': instance.url,
      'superuserId': instance.superuserId,
      'connectionId': instance.connectionId,
      'caption': instance.caption,
      'filter': instance.filter,
      'status': instance.status,
      'deleted': instance.deleted,
      'unwatchedIds': instance.unwatchedIds,
      'created': Photo._dateTimeAsIs(instance.created),
    };
