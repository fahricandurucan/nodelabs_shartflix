class AppConstants {
  // API Constants
  static const String baseUrl = 'https://caseapi.servicelabs.tech';
  static const String apiKey = 'YOUR_API_KEY';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  
  // App Constants
  static const String appName = 'ShartFlix';
  static const int moviesPerPage = 5;
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  
  // API Endpoints
  static const String loginEndpoint = '/user/login';
  static const String registerEndpoint = '/user/register';
  static const String profileEndpoint = '/user/profile';
  static const String uploadPhotoEndpoint = '/user/upload_photo';
  static const String movieListEndpoint = '/movie/list';
  static const String movieFavoritesEndpoint = '/movie/favorites';
  static const String toggleFavoriteEndpoint = '/movie/favorite';
} 