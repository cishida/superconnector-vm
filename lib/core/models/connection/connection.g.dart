// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      deletedIds: (json['deletedIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      tagCategories: (json['tagCategories'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      phoneNumberNameMap:
          (json['phoneNumberNameMap'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              {},
      streakCount: json['streakCount'] as int? ?? 0,
      videoCount: json['videoCount'] as int? ?? 0,
      isExampleConversation: json['isExampleConversation'] as bool? ?? false,
      mostRecentActivity: Connection._dateTimeFromTimestamp(
          json['mostRecentActivity'] as Timestamp?),
      created: Connection._dateTimeFromTimestamp(json['created'] as Timestamp?),
    )..superuser = json['superuser'] == null
        ? null
        : Superuser.fromJson(json['superuser'] as Map<String, dynamic>);

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'superuser': instance.superuser,
      'userIds': instance.userIds,
      'deletedIds': instance.deletedIds,
      'tags': instance.tags,
      'tagCategories': instance.tagCategories,
      'phoneNumberNameMap': instance.phoneNumberNameMap,
      'streakCount': instance.streakCount,
      'videoCount': instance.videoCount,
      'isExampleConversation': instance.isExampleConversation,
      'mostRecentActivity':
          Connection._dateTimeAsIs(instance.mostRecentActivity),
      'created': Connection._dateTimeAsIs(instance.created),
    };
