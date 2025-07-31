import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genres,
    super.isFavorite = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => _$MovieModelFromJson(json);
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromApiResponse(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id']?.toString() ?? '',
      title: json['Title'] ?? json['title'] ?? '',
      overview: json['description'] ?? json['Description'] ?? '',
      posterPath: json['Poster'] ?? json['posterUrl'] ?? '',
      backdropPath: json['backdropUrl'] ?? '',
      voteAverage: (json['voteAverage'] ?? json['rating'] ?? 7.5).toDouble(),
      releaseDate: json['releaseDate'] ?? '2024-01-01',
      genres: (json['Genre'] ?? '').toString().split(', ').where((g) => g.isNotEmpty).toList(),
      isFavorite: false,
    );
  }
} 