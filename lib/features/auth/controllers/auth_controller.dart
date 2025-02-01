import 'package:ai_malacca_tour_guide/models/user_model.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/services/user_service.dart';
import 'package:ai_malacca_tour_guide/services/api_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {
  final SharedPreferences appStorage;
  final UserService _userService = Get.find<UserService>();
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  AuthController({required this.appStorage}) {
    // Check if user is already logged in
    final user = _userService.currentUser;
    if (user != null) {
      currentUser.value = user;
    }
  }

  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      error.value = 'Please fill in all fields';
      return false;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final user = await _userService.login(
        email: email,
        password: password,
      );

      currentUser.value = user;
      Get.offAllNamed(Routes.HOME);
      return true;
    } on HttpException catch (e) {
      print('Response status: ${e.statusCode}');
      print('Response message: ${e.message}');

      switch (e.statusCode) {
        case 401:
          error.value = 'The email or password you entered is incorrect';
          break;
        case 404:
          error.value = 'No account found with this email';
          break;
        case 400:
          if (e.message.contains('Invalid credentials')) {
            error.value = 'The email or password you entered is incorrect';
          } else {
            error.value = 'Invalid login details';
          }
          break;
        case 500:
          error.value = 'Server error. Please try again later.';
          break;
        default:
          error.value = 'Unable to sign in. Please try again later.';
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      error.value = 'An unexpected error occurred. Please try again later.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp(String email, String password, String fullName) async {
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      error.value = 'Please fill in all fields';
      return false;
    }

    try {
      isLoading.value = true;
      error.value = '';

      await _userService.register(
        email: email,
        password: password,
        fullName: fullName,
        username: email.split('@')[0],
      );

      Get.snackbar(
        'Success',
        'Account created successfully! Please login.',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        duration: const Duration(seconds: 3),
      );

      Get.offNamed(Routes.SIGN_IN);
      return true;
    } on DioError catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        // Handle email already registered error
        if (responseData is Map &&
            responseData['error'] == 'Email already registered') {
          error.value = 'This email is already registered';
        } else {
          switch (e.response?.statusCode) {
            case 409:
              error.value = 'Email already exists';
              break;
            case 400:
              error.value = responseData is Map
                  ? responseData['error'] ?? 'Invalid input data'
                  : 'Invalid input data';
              break;
            case 422:
              error.value = 'Invalid email format';
              break;
            default:
              error.value = 'Registration failed. Please try again.';
          }
        }
      } else if (e.type == DioErrorType.connectionTimeout) {
        error.value = 'Connection timeout. Please check your internet.';
      } else {
        error.value = 'Network error. Please check your connection.';
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      if (e.toString().contains('Email already registered')) {
        error.value = 'This email is already registered';
      } else {
        error.value = 'An unexpected error occurred';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _userService.logout();
      currentUser.value = null;
      Get.offAllNamed(Routes.WELCOME);
    } catch (e) {
      error.value = 'Error signing out';
    }
  }

  // Helper method to check if user is logged in
  bool get isLoggedIn => _userService.isLoggedIn;
}
