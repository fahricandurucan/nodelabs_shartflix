import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String name, String password);
  Future<User> getProfile();
  Future<String> uploadPhoto(String filePath);
  Future<void> logout();
  Future<bool> isLoggedIn();
} 