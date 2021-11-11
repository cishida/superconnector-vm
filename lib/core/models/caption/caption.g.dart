// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Caption _$CaptionFromJson(Map<String, dynamic> json) => Caption(
      value: json['value'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );

Map<String, dynamic> _$CaptionToJson(Caption instance) => <String, dynamic>{
      'value': instance.value,
      'order': instance.order,
    };
