// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Superuser _$SuperuserFromJson(Map<String, dynamic> json) {
  return Superuser(
    phoneNumber: json['phoneNumber'] as String? ?? '',
    displayName: json['displayName'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    username: json['username'] as String? ?? '',
    photoUrl: json['photoUrl'] as String? ?? '',
    socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, e as String),
        ) ??
        {},
    fcmTokens: (json['fcmTokens'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    unseenNotificationCount: json['unseenNotificationCount'] as int? ?? 0,
    numContacts: json['numContacts'] as int? ?? 0,
    onboarded: json['onboarded'] as bool? ?? false,
    homeOnboarding: json['homeOnboarding'] as bool? ?? false,
    recordOnboarding: json['recordOnboarding'] as bool? ?? false,
    contactsOnboarding: json['contactsOnboarding'] as bool? ?? false,
    created: Superuser._dateTimeFromTimestamp(json['created'] as Timestamp),
  );
}

Map<String, dynamic> _$SuperuserToJson(Superuser instance) => <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'fullName': instance.fullName,
      'username': instance.username,
      'photoUrl': instance.photoUrl,
      'socialLinks': instance.socialLinks,
      'fcmTokens': instance.fcmTokens,
      'unseenNotificationCount': instance.unseenNotificationCount,
      'numContacts': instance.numContacts,
      'onboarded': instance.onboarded,
      'homeOnboarding': instance.homeOnboarding,
      'recordOnboarding': instance.recordOnboarding,
      'contactsOnboarding': instance.contactsOnboarding,
      'created': Superuser._dateTimeAsIs(instance.created),
    };
