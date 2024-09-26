// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      id: json['_id'] as String,
      moviePhoto: json['moviePhoto'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      rate: (json['rate'] as num).toDouble(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'rate': instance.rate,
      'year': instance.year,
      'moviePhoto': instance.moviePhoto,
    };
