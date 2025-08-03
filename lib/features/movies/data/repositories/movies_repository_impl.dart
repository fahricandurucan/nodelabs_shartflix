import '../../../../core/services/api_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../models/movie_model.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final ApiService _apiService;

  MoviesRepositoryImpl(this._apiService);

  @override
  Future<List<MovieModel>> getMovieList({int page = 1}) async {
    try {
      print('🎬 Repository: Getting movies for page $page');
      final response = await _apiService.getMovieList(page: page);

      print('📦 Repository Response for page $page:');
      print('   Response Type: ${response.runtimeType}');
      print('   Response Keys: ${response.keys.toList()}');
      print('   Full Response: $response');

      List<dynamic> moviesData;

      if (response['data'] != null && response['data']['movies'] != null) {
        moviesData = response['data']['movies'] as List;
        print('   📋 Found movies in data.movies: ${moviesData.length} items');
      } else if (response['movies'] != null) {
        moviesData = response['movies'] as List;
        print('   📋 Found movies in movies: ${moviesData.length} items');
      } else if (response is List) {
        moviesData = response as List;
        print('   📋 Found movies in root list: ${moviesData.length} items');
      } else {
        print('❌ Unexpected response structure: $response');
        return [];
      }

      print('🎭 Processing ${moviesData.length} movies for page $page');

      final movies = moviesData.map((movieJson) {
        try {
          print(
              '   --------  isFavorite = ${movieJson['isFavorite']}   🎬 Processing movie: ${movieJson['Title'] ?? movieJson['title'] ?? 'Unknown.'}');
          return MovieModel.fromApiResponse(movieJson);
        } catch (e) {
          print('❌ Error parsing movie: $movieJson, Error: $e');
          // Return a default movie if parsing fails
          return MovieModel(
            id: movieJson['id']?.toString() ?? '0',
            title: movieJson['Title'] ?? movieJson['title'] ?? 'Unknown Movie',
            overview:
                movieJson['description'] ?? movieJson['Description'] ?? 'No description available',
            posterPath: movieJson['Poster'] ?? movieJson['posterUrl'] ?? '',
            backdropPath: movieJson['backdropUrl'] ?? '',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            genres: const ['Unknown'],
            isFavorite: movieJson['isFavorite'],
            year: movieJson['year']?.toString() ?? '',
            rated: movieJson['rated'] ?? '',
            released: movieJson['Released'] ?? '',
            runtime: movieJson['Runtime'] ?? '',
            director: movieJson['Director'] ?? '',
            writer: movieJson['Writer'] ?? '',
            actors: movieJson['Actors'] ?? '',
            language: movieJson['Language'] ?? '',
            country: movieJson['Country'] ?? '',
            awards: movieJson['Awards'] ?? '',
            metascore: movieJson['Metascore']?.toString() ?? '',
            imdbRating: movieJson['imdbRating']?.toString() ?? '',
            imdbVotes: movieJson['imdbVotes']?.toString() ?? '',
            imdbID: movieJson['imdbID'] ?? '',
            type: movieJson['Type'] ?? '',
            response: movieJson['Response'] ?? '',
            images:
                (movieJson['Images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
            comingSoon: movieJson['comingSoon'] ?? false,
          );
        }
      }).toList();

      print('✅ Successfully processed ${movies.length} movies for page $page');
      return movies;
    } catch (e) {
      print('❌ Repository Error for page $page: $e');
      throw Exception('Film listesi alınamadı: ${e.toString()}');
    }
  }

  @override
  Future<bool> toggleFavorite(String movieId) async {
    try {
      final response = await _apiService.toggleFavorite(movieId);
      return response['success'] ?? false;
    } catch (e) {
      throw Exception('Favori durumu değiştirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    try {
      final response = await _apiService.getFavoriteMovies();
      List<dynamic> moviesData = [];
      if (response['data'] != null && response['data'] is List) {
        moviesData = response['data'] as List;
      } else {
        return [];
      }
      return moviesData.map((movieJson) {
        final movie = MovieModel.fromApiResponse(movieJson);
        return movie.copyWith(isFavorite: true);
      }).toList();
    } catch (e) {
      throw Exception('Favori filmler alınamadı: ${e.toString()}');
    }
  }
}
