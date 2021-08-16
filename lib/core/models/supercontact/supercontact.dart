import 'package:json_annotation/json_annotation.dart';

part 'supercontact.g.dart';

@JsonSerializable()
class Supercontact {
  @JsonKey(ignore: true, defaultValue: '')
  String id;

  @JsonKey(defaultValue: '')
  String phoneNumber;
  @JsonKey(defaultValue: '')
  String ownerUserId;
  @JsonKey(defaultValue: '')
  String targetUserId;
  @JsonKey(defaultValue: '')
  String fullName;
  @JsonKey(defaultValue: '')
  String username;
  @JsonKey(defaultValue: '')
  String photoUrl;
  @JsonKey(defaultValue: false)
  bool isSuperuser;

  // @JsonKey(
  //   fromJson: _dateTimeFromTimestamp,
  //   toJson: _dateTimeAsIs,
  // )
  // DateTime created;

  // static DateTime _dateTimeAsIs(DateTime dateTime) =>
  //     dateTime; //<-- pass through no need for generated code to perform any formatting

  // static DateTime _dateTimeFromTimestamp(Timestamp timestamp) {
  //   return DateTime.parse(timestamp.toDate().toString());
  // }

  Supercontact({
    this.id = '',
    this.phoneNumber = '',
    this.ownerUserId = '',
    this.targetUserId = '',
    this.fullName = '',
    this.username = '',
    this.photoUrl = '',
    this.isSuperuser = false,
    // required this.created,
  });

  factory Supercontact.fromJson(String id, Map<String, dynamic> json) =>
      _$SupercontactFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$SupercontactToJson(this);
}
