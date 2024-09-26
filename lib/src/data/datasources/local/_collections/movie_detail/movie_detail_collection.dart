// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

import '../../../../../domain/entities/movie_detail/movie_detail_entity.dart';
import '../../../_mappers/entity_convertable.dart';

part 'movie_detail_collection.g.dart';

@collection
class MovieDetailCollection with EntityConvertible<MovieDetailCollection, MovieDetailEntity> {
  final Id? idisar;
  final String? id;
  final String? title;
  final String? description;
  final double? rate;
  final int? year;
  final String? moviePhoto;

  MovieDetailCollection({
    this.idisar,
    this.id,
    this.moviePhoto,
    this.title,
    this.description,
    this.rate,
    this.year,
  });

  @override
  MovieDetailEntity toEntity() {
    return MovieDetailEntity(
        id: id,
        title: title,
        description: description,
        rate: rate,
        year: year,
        moviePhoto: moviePhoto
    );
  }

  @override
  MovieDetailCollection fromEntity(MovieDetailEntity? model) {
    return MovieDetailCollection(
      id: model?.id,
      title: model?.title,
      description: model?.description,
      rate: model?.rate,
      year: model?.year,
      moviePhoto: model?.moviePhoto,
    );
  }
}
