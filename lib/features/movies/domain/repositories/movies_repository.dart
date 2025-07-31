import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getMovieList({int page});
  Future<bool> toggleFavorite(String movieId);
} 