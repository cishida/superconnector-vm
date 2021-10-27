import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superconnector_vm/core/services/photo/photo_service.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  @JsonKey(ignore: true)
  String id;
  @JsonKey(defaultValue: '')
  String url;
  @JsonKey(defaultValue: '')
  String superuserId;
  @JsonKey(defaultValue: '')
  String connectionId;

  @JsonKey(defaultValue: '')
  String caption;
  @JsonKey(defaultValue: '')
  String filter;

  @JsonKey(defaultValue: '')
  String status;
  @JsonKey(defaultValue: false)
  bool deleted;
  @JsonKey(defaultValue: [])
  List<String> unwatchedIds;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeAsIs)
  DateTime created;

  static DateTime _dateTimeAsIs(DateTime dateTime) =>
      dateTime; //<-- pass through no need for generated code to perform any formatting

  static DateTime _dateTimeFromTimestamp(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  Photo({
    this.id = '',
    required this.created,
    this.url = '',
    this.connectionId = '',
    this.superuserId = '',
    this.caption = '',
    this.filter = '',
    this.status = '',
    this.deleted = false,
    this.unwatchedIds = const [],
  });

  factory Photo.fromJson(String id, Map<String, dynamic> json) =>
      _$PhotoFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  Future update() async {
    await PhotoService().updatePhoto(this.id, this.toJson());
  }

  Future create() async {
    await PhotoService().createPhoto(this.id, this.toJson());
  }

  Future incrementViewCount() {
    return FirebaseFirestore.instance.collection('photos').doc(id).update(
      {
        'views': FieldValue.increment(1),
      },
    );
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'caption':
        return caption;
      // case 'hashtags':
      //   return hashtags;
      default:
        return '';
    }
  }

  void operator []=(String key, dynamic value) {
    switch (key) {
      case 'caption':
        caption = value;
        break;
      default:
    }
  }
}
