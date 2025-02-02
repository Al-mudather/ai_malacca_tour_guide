import 'dart:convert';
import 'dart:developer' as developer;
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
        _prefs = prefs {
    // Set token if it exists
    final token = this.token;
    if (token != null) {
      _api.updateToken(token);
    }
  }

  // Register a new user
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _api.post('/api/auth/register', {
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    });

    // For registration, we might just want to return success without user data
    // since we'll redirect to login anyway
    return UserModel(
      email: email,
      password: password,
      name: fullName,
    );
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

    try {
      final response = await _api.put('/api/auth/profile/update', data);

      // Create updated user model
      final updatedUser = UserModel.fromMap(response);

      // Get the current stored user
      final currentStoredUser = currentUser;
      if (currentStoredUser != null) {
        // Merge the updated data with existing data to ensure we don't lose any fields
        final mergedUser = UserModel(
          id: updatedUser.id ?? currentStoredUser.id,
          email: updatedUser.email ?? currentStoredUser.email,
          name: updatedUser.name ?? currentStoredUser.name,
          password: currentStoredUser.password, // Keep the existing password
          isAdmin: updatedUser.isAdmin ?? currentStoredUser.isAdmin,
        );

        // Save the merged user data
        await _saveUser(mergedUser);
        return mergedUser;
      }

      // If no current user exists, just save the updated user
      await _saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
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
    try {
      developer.log('Fetching all users...');
      final response = await _api.get('/api/users');
      developer.log('Raw API response: $response');

      List<dynamic> usersList;
      if (response is List) {
        usersList = response;
      } else if (response is Map<String, dynamic> &&
          response.containsKey('data')) {
        final data = response['data'];
        if (data is! List) {
          throw Exception('Data is not a list');
        }
        usersList = data;
      } else {
        developer.log('Unexpected response format: $response');
        throw Exception('Unexpected response format');
      }

      final users = usersList.map((json) {
        developer.log('Processing user data: $json');
        if (json is! Map<String, dynamic>) {
          developer.log('Invalid user data format: $json');
          throw Exception('Invalid user data format');
        }
        return UserModel.fromMap(json);
      }).toList();

      developer.log('Successfully processed ${users.length} users');
      return users;
    } catch (e, stackTrace) {
      developer.log(
        'Error in getAllUsers',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
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
    _api.updateToken(token);
    await _saveUser(user);
  }

  Future<void> _saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toMap()));
  }
}
