import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';

part 'connection.g.dart';

@JsonSerializable()
class Connection {
  @JsonKey(ignore: true)
  List<Superuser> superusers = [];

  @JsonKey(ignore: true)
  String id;
  @JsonKey(defaultValue: [])
  List<String> userIds;

  // Deleted ids are users who have deleted the connection
  @JsonKey(defaultValue: [])
  List<String> deletedIds;

  // Tags map each user to their respective tag for the connection
  @JsonKey(defaultValue: {})
  Map<String, String> tags;
  @JsonKey(defaultValue: {})
  Map<String, String> tagCategories;

  // For preusers we map added phone numbers to the contact name
  @JsonKey(defaultValue: {})
  Map<String, String> phoneNumberNameMap;
  @JsonKey(defaultValue: 0)
  int streakCount;
  @JsonKey(defaultValue: 0)
  int videoCount;

  // Each new user creates an example connection that is handled differently
  // than standard connections
  @JsonKey(defaultValue: false)
  bool isExampleConversation;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeAsIs)
  DateTime? mostRecentActivity;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeAsIs)
  DateTime? created;

  static DateTime? _dateTimeAsIs(DateTime? dateTime) =>
      dateTime; //<-- pass through no need for generated code to perform any formatting

  static DateTime? _dateTimeFromTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return null;
    }
    return DateTime.parse(timestamp.toDate().toString());
  }

  // static Timestamp _timestampFromEpochUs(int us) =>
  //     us == null ? null : Timestamp.fromMicrosecondsSinceEpoch(us);
  // static int _timestampToEpochUs(Timestamp timestamp) =>
  //     timestamp?.microsecondsSinceEpoch;

  Connection({
    this.id = '',
    this.userIds = const [],
    this.deletedIds = const [],
    this.tags = const {},
    this.tagCategories = const {},
    this.phoneNumberNameMap = const {},
    this.streakCount = 0,
    this.videoCount = 0,
    this.isExampleConversation = false,
    this.mostRecentActivity,
    this.created,
  });

  factory Connection.fromJson(String id, Map<String, dynamic> json) =>
      _$ConnectionFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$ConnectionToJson(this);

  Future update() async {
    await ConnectionService().update(
      this.id,
      this.toJson(),
    );
  }
}
