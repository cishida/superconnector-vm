import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'superuser.g.dart';

class SuperFirebaseUser {
  String id;

  SuperFirebaseUser({
    required this.id,
  });
}

enum HomeOnboardingStage {
  connections,
  contacts,
  settings,
  newVM,
  completed,
}

extension HomeOnboardingStageExtension on HomeOnboardingStage {
  static HomeOnboardingStage fromString(String string) {
    switch (string) {
      case 'connections':
        return HomeOnboardingStage.connections;
      case 'contacts':
        return HomeOnboardingStage.contacts;
      case 'settings':
        return HomeOnboardingStage.settings;
      case 'newVM':
        return HomeOnboardingStage.newVM;
      case 'completed':
        return HomeOnboardingStage.completed;
      default:
        return HomeOnboardingStage.completed;
    }
  }

  String toShortString() {
    return this.toString().split('.').last;
  }
}

@JsonSerializable()
class Superuser {
  @JsonKey(ignore: true, defaultValue: '')
  String id;

  @JsonKey(defaultValue: '')
  String phoneNumber;
  @JsonKey(defaultValue: '')
  String displayName;
  @JsonKey(defaultValue: '')
  String fullName;
  @JsonKey(defaultValue: '')
  String username;
  @JsonKey(defaultValue: '')
  String photoUrl;

  @JsonKey(defaultValue: {})
  Map<String, String> socialLinks;

  @JsonKey(defaultValue: [])
  List<String> fcmTokens;
  @JsonKey(defaultValue: 0)
  int unseenNotificationCount;
  @JsonKey(defaultValue: 0)
  int numContacts;

  @JsonKey(defaultValue: false)
  bool onboarded;
  @JsonKey(defaultValue: HomeOnboardingStage.completed)
  HomeOnboardingStage homeOnboardingStage;
  @JsonKey(defaultValue: false)
  bool recordOnboarding;
  @JsonKey(defaultValue: false)
  bool contactsOnboarding;

  @JsonKey(
    fromJson: _dateTimeFromTimestamp,
    toJson: _dateTimeAsIs,
  )
  DateTime created;

  static DateTime _dateTimeAsIs(DateTime dateTime) =>
      dateTime; //<-- pass through no need for generated code to perform any formatting

  static DateTime _dateTimeFromTimestamp(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  Superuser({
    this.id = '',
    this.phoneNumber = '',
    this.displayName = '',
    this.fullName = '',
    this.username = '',
    this.photoUrl = '',
    this.socialLinks = const {},
    this.fcmTokens = const [],
    this.unseenNotificationCount = 0,
    this.numContacts = 0,
    this.onboarded = false,
    this.homeOnboardingStage = HomeOnboardingStage.completed,
    this.recordOnboarding = false,
    this.contactsOnboarding = false,
    required this.created,
  });

  factory Superuser.fromJson(String id, Map<String, dynamic> json) =>
      _$SuperuserFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$SuperuserToJson(this);

  Future update() async {
    await SuperuserService(id: this.id).updateSuperuser(this.toJson());
  }

  String operator [](String key) {
    switch (key) {
      case 'fullName':
        return fullName;
      case 'username':
        return username;
      case 'photoUrl':
        return photoUrl;
      default:
        return '';
    }
  }

  void operator []=(String key, String value) {
    switch (key) {
      case 'fullName':
        fullName = value;
        break;
      case 'username':
        username = value;
        break;
      case 'photoUrl':
        photoUrl = value;
        break;
      default:
    }
  }
}
