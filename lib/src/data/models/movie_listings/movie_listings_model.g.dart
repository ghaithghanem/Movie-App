// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_listings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListingsModel _$MovieListingsModelFromJson(Map<String, dynamic> json) =>
    MovieListingsModel(
      page: (json['page'] as num?)?.toInt(),
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      totalResults: (json['totalResults'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieListingsModelToJson(MovieListingsModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'movies': instance.movies,
      'totalPages': instance.totalPages,
      'totalResults': instance.totalResults,
    };
