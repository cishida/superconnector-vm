// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConnection _$UserConnectionFromJson(Map<String, dynamic> json) =>
    UserConnection(
      users: (json['users'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
          ) ??
          {},
    );

Map<String, dynamic> _$UserConnectionToJson(UserConnection instance) =>
    <String, dynamic>{
      'users': instance.users,
    };
