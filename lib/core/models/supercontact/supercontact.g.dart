// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supercontact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supercontact _$SupercontactFromJson(Map<String, dynamic> json) => Supercontact(
      phoneNumber: json['phoneNumber'] as String? ?? '',
      ownerUserId: json['ownerUserId'] as String? ?? '',
      targetUserId: json['targetUserId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      username: json['username'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      isSuperuser: json['isSuperuser'] as bool? ?? false,
    );

Map<String, dynamic> _$SupercontactToJson(Supercontact instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'ownerUserId': instance.ownerUserId,
      'targetUserId': instance.targetUserId,
      'fullName': instance.fullName,
      'username': instance.username,
      'photoUrl': instance.photoUrl,
      'isSuperuser': instance.isSuperuser,
    };
