import 'package:ai_malacca_tour_guide/models/user_model.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/services/user_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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
    } catch (e) {
      print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      print(e);
      print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      error.value = 'Invalid credentials or connection error';
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
        username: email.split('@')[0], // Generate username from email
      );

      // Instead of setting currentUser and redirecting to home,
      // show success message and redirect to login
      Get.snackbar(
        'Success',
        'Account created successfully! Please login.',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        duration: const Duration(seconds: 3),
      );

      Get.offNamed(Routes.SIGN_IN); // Redirect to login instead of home
      return true;
    } catch (e) {
      error.value = 'Registration failed. Please try again.';
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
