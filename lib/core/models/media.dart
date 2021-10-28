import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/video/video.dart';

class Media {
  Media({
    this.photo,
    this.video,
  });

  Photo? photo;
  Video? video;

  DateTime get created => video != null ? video!.created : photo!.created;
}
