import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';

// Events
abstract class FavoriteMoviesEvent {}

class LoadFavoriteMovies extends FavoriteMoviesEvent {}

// States
abstract class FavoriteMoviesState {}

class FavoriteMoviesInitial extends FavoriteMoviesState {}

class FavoriteMoviesLoading extends FavoriteMoviesState {}

class FavoriteMoviesLoaded extends FavoriteMoviesState {
  final List<Movie> favoriteMovies;
  FavoriteMoviesLoaded(this.favoriteMovies);
}

class FavoriteMoviesError extends FavoriteMoviesState {
  final String message;
  FavoriteMoviesError(this.message);
}

// Bloc
class FavoriteMoviesBloc extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  final MoviesRepository moviesRepository;

  FavoriteMoviesBloc(this.moviesRepository) : super(FavoriteMoviesInitial()) {
    on<LoadFavoriteMovies>((event, emit) async {
      emit(FavoriteMoviesLoading());
      try {
        final favorites = await moviesRepository.getFavoriteMovies();
        emit(FavoriteMoviesLoaded(favorites));
      } catch (e) {
        emit(FavoriteMoviesError(e.toString()));
      }
    });
  }
}