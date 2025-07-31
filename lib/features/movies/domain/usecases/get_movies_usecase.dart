import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetMoviesUseCase {
  final MoviesRepository repository;

  GetMoviesUseCase(this.repository);

  Future<List<Movie>> call({int page = 1}) async {
    return await repository.getMovieList(page: page);
  }
} 