import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/api_service.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies_usecase.dart';

// Events
abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MoviesEvent {
  final int page;

  const LoadMovies({this.page = 0});

  @override
  List<Object?> get props => [page];
}

class RefreshMovies extends MoviesEvent {}

class ToggleFavorite extends MoviesEvent {
  final String movieId;

  const ToggleFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class LoadFavoriteMovies extends MoviesEvent {}

// States
abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax;

  const MoviesLoaded({
    required this.movies,
    required this.currentPage,
    required this.hasReachedMax,
  });

  MoviesLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [movies, currentPage, hasReachedMax];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteMoviesLoaded extends MoviesState {
  final List<Movie> favoriteMovies;
  const FavoriteMoviesLoaded(this.favoriteMovies);
  @override
  List<Object?> get props => [favoriteMovies];
}

// BLoC
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final MoviesRepositoryImpl _moviesRepository;
  int? _lastRequestedPage;
  List<Movie> _favoriteMovies = [];

  MoviesBloc()
      : _moviesRepository = MoviesRepositoryImpl(ApiService()),
        _getMoviesUseCase = GetMoviesUseCase(MoviesRepositoryImpl(ApiService())),
        super(MoviesInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MoviesState> emit,
  ) async {
    print('🎬 BLoC: Loading movies for page ${event.page}');
    
    // Check if we're already loading this page
    if (_lastRequestedPage == event.page) {
      print('⏳ BLoC: Already loading page ${event.page}, skipping...');
      return;
    }
    
    _lastRequestedPage = event.page;
    
    if (event.page == 0) {
      print('🔄 BLoC: Emitting loading state');
      emit(MoviesLoading());
    }

    try {
      final movies = await _getMoviesUseCase(page: event.page);
      print('📦 BLoC: Received ${movies.length} movies for page ${event.page}');
      
      if (event.page == 0) {
        print('🔄 BLoC: First page - emitting MoviesLoaded with ${movies.length} movies');
        emit(MoviesLoaded(
          movies: movies,
          currentPage: event.page,
          hasReachedMax: movies.isEmpty,
        ));
      } else {
        final currentState = state as MoviesLoaded;
        print('🔄 BLoC: Appending ${movies.length} movies to existing ${currentState.movies.length} movies');
        final updatedMovies = [...currentState.movies, ...movies];
        print('📊 BLoC: Total movies after append: ${updatedMovies.length}');
        emit(MoviesLoaded(
          movies: updatedMovies,
          currentPage: event.page,
          hasReachedMax: movies.isEmpty,
        ));
      }
    } catch (e) {
      print('❌ BLoC Error: $e');
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<MoviesState> emit,
  ) async {
    print('🔄 BLoC: Refreshing movies');
    _lastRequestedPage = null; // Reset last requested page
    add(const LoadMovies(page: 0));
  }

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final response = await _moviesRepository.getFavoriteMovies();
      _favoriteMovies = response;
      emit(FavoriteMoviesLoaded(_favoriteMovies));
    } catch (e) {
      emit(MoviesError('Favori filmler yüklenemedi: $e'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      try {
        final movieId = event.movieId;
        await _moviesRepository.toggleFavorite(movieId);
        add(LoadFavoriteMovies());
        final currentState = state as MoviesLoaded;
        final updatedMovies = currentState.movies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(isFavorite: !movie.isFavorite);
          }
          return movie;
        }).toList();
        emit(MoviesLoaded(
          movies: updatedMovies,
          currentPage: currentState.currentPage,
          hasReachedMax: currentState.hasReachedMax,
        ));
      } catch (e) {
        // Handle error silently or show snackbar
      }
    }
  }
} 