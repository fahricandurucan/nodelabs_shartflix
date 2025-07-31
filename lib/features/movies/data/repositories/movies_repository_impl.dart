import '../../../../core/services/api_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../models/movie_model.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final ApiService _apiService;

  MoviesRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getMovieList({int page = 1}) async {
    try {
      print('🎬 Repository: Getting movies for page $page');
      final response = await _apiService.getMovieList(page: page);
      
      // Debug: Print response structure
      print('📦 Repository Response for page $page:');
      print('   Response Type: ${response.runtimeType}');
      print('   Response Keys: ${response.keys.toList()}');
      print('   Full Response: $response');
      
      // Handle different response structures
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
          print('   🎬 Processing movie: ${movieJson['Title'] ?? movieJson['title'] ?? 'Unknown'}');
          return MovieModel.fromApiResponse(movieJson);
        } catch (e) {
          print('❌ Error parsing movie: $movieJson, Error: $e');
          // Return a default movie if parsing fails
          return MovieModel(
            id: movieJson['id']?.toString() ?? '0',
            title: movieJson['Title'] ?? movieJson['title'] ?? 'Unknown Movie',
            overview: movieJson['description'] ?? movieJson['Description'] ?? 'No description available',
            posterPath: movieJson['Poster'] ?? movieJson['posterUrl'] ?? '',
            backdropPath: movieJson['backdropUrl'] ?? '',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            genres: const ['Unknown'],
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