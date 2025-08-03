import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class ApiService {
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
     
        }
        handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(AppConstants.loginEndpoint, data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(String email, String name, String password) async {
    try {
      final response = await _dio.post(AppConstants.registerEndpoint, data: {
        'email': email,
        'name': name,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(AppConstants.profileEndpoint);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> uploadPhoto(String filePath) async {
    try {
      print('📤 Uploading photo from: $filePath');
      print('🔗 API URL: ${AppConstants.baseUrl}${AppConstants.uploadPhotoEndpoint}');
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post(AppConstants.uploadPhotoEndpoint, data: formData);
      
      print('✅ Upload response:');
      print('   Status Code: ${response.statusCode}');
      print('   Data: ${response.data}');
      
      return response.data;
    } catch (e) {
      print('❌ Upload error: $e');
      throw _handleError(e);
    }
  }

  // Movie Methods
  Future<Map<String, dynamic>> getMovieList({int page = 1}) async {
    try {
      print('🔍 API Call: Getting movies for page $page');
      print('🔗 API URL: ${AppConstants.baseUrl}${AppConstants.movieListEndpoint}');
      print('📋 Query Parameters: {"page": $page}');
      
      final response = await _dio.get(AppConstants.movieListEndpoint, queryParameters: {
        'page': page,
      });
      
      // Debug: Print response to understand structure
      print('📡 Movie List Response for page $page:');
      print('   Status Code: ${response.statusCode}');
      print('   Data Type: ${response.data.runtimeType}');
      print('   Data: ${response.data}');
      
      return response.data;
    } catch (e) {
      print('❌ API Error for page $page: $e');
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getFavoriteMovies() async {
    try {
      final response = await _dio.get(AppConstants.movieFavoritesEndpoint);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> toggleFavorite(String movieId) async {
    try {
      final response = await _dio.post('${AppConstants.toggleFavoriteEndpoint}/$movieId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Bağlantı zaman aşımı');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          
          String message = 'Bir hata oluştu';
          if (responseData != null) {
            if (responseData['response'] != null) {
              message = responseData['response']['message'] ?? message;
            } else if (responseData['message'] != null) {
              message = responseData['message'];
            }
          }
          
          return Exception('Hata $statusCode: $message');
        case DioExceptionType.cancel:
          return Exception('İstek iptal edildi');
        default:
          return Exception('Ağ hatası');
      }
    }
    return Exception('Beklenmeyen hata');
  }
} 