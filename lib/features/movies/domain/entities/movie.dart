import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final bool isFavorite;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String director;
  final String writer;
  final String actors;
  final String language;
  final String country;
  final String awards;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String response;
  final List<String> images;
  final bool comingSoon;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    this.isFavorite = false,
    this.year = '',
    this.rated = '',
    this.released = '',
    this.runtime = '',
    this.director = '',
    this.writer = '',
    this.actors = '',
    this.language = '',
    this.country = '',
    this.awards = '',
    this.metascore = '',
    this.imdbRating = '',
    this.imdbVotes = '',
    this.imdbID = '',
    this.type = '',
    this.response = '',
    this.images = const [],
    this.comingSoon = false,
  });

  Movie copyWith({
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
    return Movie(
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

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        genres,
        isFavorite,
        year,
        rated,
        released,
        runtime,
        director,
        writer,
        actors,
        language,
        country,
        awards,
        metascore,
        imdbRating,
        imdbVotes,
        imdbID,
        type,
        response,
        images,
        comingSoon,
      ];
} 