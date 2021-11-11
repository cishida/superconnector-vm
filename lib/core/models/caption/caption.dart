import 'package:json_annotation/json_annotation.dart';

part 'caption.g.dart';

@JsonSerializable()
class Caption {
  @JsonKey(ignore: true, defaultValue: '')
  String id;

  @JsonKey(defaultValue: '')
  String value;
  @JsonKey(defaultValue: 0)
  int order;

  Caption({
    this.id = '',
    this.value = '',
    this.order = 0,
  });

  factory Caption.fromJson(String id, Map<String, dynamic> json) =>
      _$CaptionFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$CaptionToJson(this);
}
