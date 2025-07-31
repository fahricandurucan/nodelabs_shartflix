import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      final userData = response['data'];
      
      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, userData['token']);
      
      return UserModel.fromApiResponse(userData);
    } catch (e) {
      throw Exception('Giriş başarısız: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String email, String name, String password) async {
    try {
      final response = await _apiService.register(email, name, password);
      
      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, response['token']);
      
      return UserModel.fromApiResponse(response['user']);
    } catch (e) {
      throw Exception('Kayıt başarısız: ${e.toString()}');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      final userData = response['data'];
      return UserModel.fromApiResponse(userData);
    } catch (e) {
      throw Exception('Profil bilgileri alınamadı: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    try {
      final response = await _apiService.uploadPhoto(filePath);
      return response['data']['photoUrl'];
    } catch (e) {
      throw Exception('Fotoğraf yüklenemedi: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return token != null;
  }
} 