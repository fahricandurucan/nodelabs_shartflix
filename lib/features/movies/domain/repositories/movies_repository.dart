import 'package:nodelabs_shartflix/features/movies/data/models/movie_model.dart';

import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<MovieModel>> getMovieList({int page});
  Future<bool> toggleFavorite(String movieId);
  Future<List<Movie>> getFavoriteMovies();
} 