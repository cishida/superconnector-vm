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
    homeOnboardingStage: _$enumDecodeNullable(
            _$HomeOnboardingStageEnumMap, json['homeOnboardingStage']) ??
        HomeOnboardingStage.completed,
    recordOnboarding: json['recordOnboarding'] as bool? ?? false,
    contactsOnboarding: json['contactsOnboarding'] as bool? ?? false,
    blockedUsers: (json['blockedUsers'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, DateTime.parse(e as String)),
        ) ??
        {},
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
      'homeOnboardingStage':
          _$HomeOnboardingStageEnumMap[instance.homeOnboardingStage],
      'recordOnboarding': instance.recordOnboarding,
      'contactsOnboarding': instance.contactsOnboarding,
      'blockedUsers':
          instance.blockedUsers.map((k, e) => MapEntry(k, e.toIso8601String())),
      'created': Superuser._dateTimeAsIs(instance.created),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$HomeOnboardingStageEnumMap = {
  HomeOnboardingStage.connections: 'connections',
  HomeOnboardingStage.contacts: 'contacts',
  HomeOnboardingStage.settings: 'settings',
  HomeOnboardingStage.newVM: 'newVM',
  HomeOnboardingStage.completed: 'completed',
};
