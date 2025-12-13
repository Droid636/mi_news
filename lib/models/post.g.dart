// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  excerpt: json['excerpt'] as String,
  content: json['content'] as String,
  link: json['link'] as String,
  date: DateTime.parse(json['date'] as String),
  featuredImage: json['featuredImage'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'link': instance.link,
      'date': instance.date.toIso8601String(),
      'featuredImage': instance.featuredImage,
      'categories': instance.categories,
    };
