// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['posterPath'] as String,
      backdropPath: json['backdropPath'] as String,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      releaseDate: json['releaseDate'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      isFavorite: json['isFavorite'] as bool,
      year: json['year'] as String,
      rated: json['rated'] as String,
      released: json['released'] as String,
      runtime: json['runtime'] as String,
      director: json['director'] as String,
      writer: json['writer'] as String,
      actors: json['actors'] as String,
      language: json['language'] as String,
      country: json['country'] as String,
      awards: json['awards'] as String,
      metascore: json['metascore'] as String,
      imdbRating: json['imdbRating'] as String,
      imdbVotes: json['imdbVotes'] as String,
      imdbID: json['imdbID'] as String,
      type: json['type'] as String,
      response: json['response'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      comingSoon: json['comingSoon'] as bool,
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'posterPath': instance.posterPath,
      'backdropPath': instance.backdropPath,
      'voteAverage': instance.voteAverage,
      'releaseDate': instance.releaseDate,
      'genres': instance.genres,
      'isFavorite': instance.isFavorite,
      'year': instance.year,
      'rated': instance.rated,
      'released': instance.released,
      'runtime': instance.runtime,
      'director': instance.director,
      'writer': instance.writer,
      'actors': instance.actors,
      'language': instance.language,
      'country': instance.country,
      'awards': instance.awards,
      'metascore': instance.metascore,
      'imdbRating': instance.imdbRating,
      'imdbVotes': instance.imdbVotes,
      'imdbID': instance.imdbID,
      'type': instance.type,
      'response': instance.response,
      'images': instance.images,
      'comingSoon': instance.comingSoon,
    };
