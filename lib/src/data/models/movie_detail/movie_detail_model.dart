import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/movie_detail/movie_detail_entity.dart';
import '../../datasources/_mappers/entity_convertable.dart';

part 'movie_detail_model.g.dart';

@JsonSerializable()
class MovieModel extends Equatable with EntityConvertible<MovieModel, MovieDetailEntity> {
  @JsonKey(name: '_id') // Adjusted key name to match the response
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'rate')
  final double rate;
  @JsonKey(name: 'year')
  final int year;
  @JsonKey(name: 'moviePhoto') // Adjusted key name to match the response
  final String? moviePhoto;

  const MovieModel({
    required this.id,
    this.moviePhoto,
    required this.title,
    required this.description,
    required this.rate,
    required this.year,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return _$MovieModelFromJson(json);
  }

  @override
  MovieDetailEntity toEntity() => MovieDetailEntity(
    id: id,
    title: title,
    description: description,
    rate: rate,
    year: year,
    moviePhoto: moviePhoto,
  );

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      rate,
      year,
      moviePhoto,
    ];
  }
}