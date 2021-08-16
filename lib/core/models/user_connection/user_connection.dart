import 'package:json_annotation/json_annotation.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';

part 'user_connection.g.dart';

@JsonSerializable()
class UserConnection {
  @JsonKey(ignore: true)
  String id;

  // Map structure 'phoneNumber': {name: '', }
  @JsonKey(defaultValue: {})
  Map<String, Map<String, String>> users;

  @JsonKey(ignore: true)
  Connection? connection;

  UserConnection({
    this.id = '',
    this.users = const {},
    this.connection,
  });

  factory UserConnection.fromJson(String id, Map<String, dynamic> json) =>
      _$UserConnectionFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$UserConnectionToJson(this);
}
