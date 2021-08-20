import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';

part 'video.g.dart';

@JsonSerializable()
class Video {
  @JsonKey(ignore: true)
  String id;
  String? uploadId;
  @JsonKey(defaultValue: '')
  String superuserId;
  @JsonKey(defaultValue: '')
  String connectionId;
  @JsonKey(defaultValue: '')
  String caption;
  @JsonKey(defaultValue: [])
  List<String> playbackIds;
  @JsonKey(defaultValue: '')
  String status;
  @JsonKey(defaultValue: '')
  String assetId;
  @JsonKey(defaultValue: 0)
  int views;
  @JsonKey(defaultValue: 0.0)
  double duration;
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

  Video({
    this.id = '',
    required this.created,
    this.uploadId,
    this.connectionId = '',
    this.superuserId = '',
    this.caption = '',
    this.playbackIds = const [],
    this.status = '',
    this.assetId = '',
    this.views = 0,
    this.duration = 0.0,
    this.deleted = false,
    this.unwatchedIds = const [],
  });

  factory Video.fromJson(String id, Map<String, dynamic> json) =>
      _$VideoFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  Future update() async {
    await VideoService().updateVideo(this.id, this.toJson());
  }

  Future incrementViewCount() {
    return FirebaseFirestore.instance.collection('videos').doc(id).update(
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
