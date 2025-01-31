import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class UserService {
  final ApiService _api;
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  UserService({ApiService? api, required SharedPreferences prefs})
      : _api = api ?? ApiService(),
        _prefs = prefs;

  // Register a new user
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _api.post('/auth/register', {
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    });

    final user = UserModel.fromMap(response['user']);
    await _saveAuthData(response['token'], user);
    return user;
  }

  // Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/api/auth/login', {
      'email': email,
      'password': password,
    });

    final user = UserModel.fromMap(response['user']);
    await _saveAuthData(response['token'], user);
    return user;
  }

  // Get current user profile
  Future<UserModel> getCurrentUser() async {
    final response = await _api.get('/auth/profile');
    final user = UserModel.fromMap(response);
    await _saveUser(user);
    return user;
  }

  // Update user profile
  Future<UserModel> updateProfile({
    String? username,
    String? fullName,
    String? phoneNumber,
  }) async {
    final Map<String, dynamic> data = {
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };

    final response = await _api.put('/api/auth/profile/update', data);
    final user = UserModel.fromMap(response);
    await _saveUser(user);
    return user;
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _api.put('/api/auth/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // Get user by ID
  Future<UserModel> getUserById(int id) async {
    final response = await _api.get('/api/users/$id');
    return UserModel.fromMap(response);
  }

  // Get all users (admin only)
  Future<List<UserModel>> getAllUsers() async {
    final response = await _api.get('/api/users');
    return (response['data'] as List)
        .map((json) => UserModel.fromMap(json))
        .toList();
  }

  // Update user (admin only)
  Future<UserModel> updateUser({
    required int id,
    String? username,
    String? email,
    String? fullName,
    String? phoneNumber,
    bool? isAdmin,
  }) async {
    final Map<String, dynamic> data = {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (fullName != null) 'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (isAdmin != null) 'is_admin': isAdmin,
    };

    final response = await _api.put('/api/users/update/$id', data);
    return UserModel.fromMap(response);
  }

  // Delete user (admin only)
  Future<void> deleteUser(int id) async {
    await _api.delete('/api/users/delete/$id');
  }

  // Logout user
  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }

  // Check if user is logged in
  bool get isLoggedIn => _prefs.getString(_tokenKey) != null;

  // Get stored user
  UserModel? get currentUser {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromMap(jsonDecode(userJson));
  }

  // Get auth token
  String? get token => _prefs.getString(_tokenKey);

  // Private methods
  Future<void> _saveAuthData(String token, UserModel user) async {
    await _prefs.setString(_tokenKey, token);
    await _saveUser(user);
  }

  Future<void> _saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toMap()));
  }
}
