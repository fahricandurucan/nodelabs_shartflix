import 'package:nodelabs_shartflix/features/movies/data/models/movie_model.dart';

import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetMoviesUseCase {
  final MoviesRepository repository;

  GetMoviesUseCase(this.repository);

  Future<List<MovieModel>> call({int page = 1}) async {
    return await repository.getMovieList(page: page);
  }
} 