import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  @override
  final String year;
  @override
  final String rated;
  @override
  final String released;
  @override
  final String runtime;
  @override
  final String director;
  @override
  final String writer;
  @override
  final String actors;
  @override
  final String language;
  @override
  final String country;
  @override
  final String awards;
  @override
  final String metascore;
  @override
  final String imdbRating;
  @override
  final String imdbVotes;
  @override
  final String imdbID;
  @override
  final String type;
  @override
  final String response;
  @override
  final List<String> images;
  @override
  final bool comingSoon;

  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genres,
    required super.isFavorite,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.director,
    required this.writer,
    required this.actors,
    required this.language,
    required this.country,
    required this.awards,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.response,
    required this.images,
    required this.comingSoon,
  });

   @override
  MovieModel copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    String? releaseDate,
    List<String>? genres,
    bool? isFavorite,
    String? year,
    String? rated,
    String? released,
    String? runtime,
    String? director,
    String? writer,
    String? actors,
    String? language,
    String? country,
    String? awards,
    String? metascore,
    String? imdbRating,
    String? imdbVotes,
    String? imdbID,
    String? type,
    String? response,
    List<String>? images,
    bool? comingSoon,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      rated: rated ?? this.rated,
      released: released ?? this.released,
      runtime: runtime ?? this.runtime,
      director: director ?? this.director,
      writer: writer ?? this.writer,
      actors: actors ?? this.actors,
      language: language ?? this.language,
      country: country ?? this.country,
      awards: awards ?? this.awards,
      metascore: metascore ?? this.metascore,
      imdbRating: imdbRating ?? this.imdbRating,
      imdbVotes: imdbVotes ?? this.imdbVotes,
      imdbID: imdbID ?? this.imdbID,
      type: type ?? this.type,
      response: response ?? this.response,
      images: images ?? this.images,
      comingSoon: comingSoon ?? this.comingSoon,
    );
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) => _$MovieModelFromJson(json);
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromApiResponse(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id']?.toString() ?? '',
      title: json['Title'] ?? json['title'] ?? '',
      overview: json['Plot'] ?? json['description'] ?? json['Description'] ?? '',
      posterPath: json['Poster'] ?? json['posterUrl'] ?? '',
      backdropPath: json['backdropUrl'] ?? '',
      voteAverage: double.tryParse(json['imdbRating']?.toString() ?? '0') ?? 0.0,
      releaseDate: json['Released'] ?? json['releaseDate'] ?? '2024-01-01',
      genres: (json['Genre'] ?? '').toString().split(', ').where((g) => g.isNotEmpty).toList(),
      isFavorite: json['isFavorite'] ?? false,
      year: json['Year']?.toString() ?? '',
      rated: json['Rated']?.toString() ?? '',
      released: json['Released']?.toString() ?? '',
      runtime: json['Runtime']?.toString() ?? '',
      director: json['Director']?.toString() ?? '',
      writer: json['Writer']?.toString() ?? '',
      actors: json['Actors']?.toString() ?? '',
      language: json['Language']?.toString() ?? '',
      country: json['Country']?.toString() ?? '',
      awards: json['Awards']?.toString() ?? '',
      metascore: json['Metascore']?.toString() ?? '',
      imdbRating: json['imdbRating']?.toString() ?? '',
      imdbVotes: json['imdbVotes']?.toString() ?? '',
      imdbID: json['imdbID']?.toString() ?? '',
      type: json['Type']?.toString() ?? '',
      response: json['Response']?.toString() ?? '',
      images: (json['Images'] as List<dynamic>?)?.cast<String>() ?? [],
      comingSoon: json['ComingSoon'] ?? false,
    );
  }
} 