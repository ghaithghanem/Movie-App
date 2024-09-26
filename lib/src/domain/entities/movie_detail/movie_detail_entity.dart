import 'package:equatable/equatable.dart';

class MovieDetailEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final double? rate;
  final int? year;
  final String? moviePhoto;

  MovieDetailEntity({
    this.id,
    this.title,
    this.description,
    this.rate,
    this.year,
    this.moviePhoto
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      rate,
      year,
      moviePhoto
    ];
  }

}