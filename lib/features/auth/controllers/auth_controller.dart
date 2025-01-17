import 'dart:convert';

import 'package:ai_malacca_tour_guide/config/app_constants.dart';
import 'package:ai_malacca_tour_guide/database/crud/users_crud.dart';
import 'package:ai_malacca_tour_guide/models/user_model.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final _usersCRUD = UsersCRUD();
  final SharedPreferences appStorage;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  AuthController({required this.appStorage}) {
    String? user = appStorage.getString(AppConstants.userKey);
    if (user != null) {
      currentUser.value = UserModel.fromMap(jsonDecode(user));
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      final user = await _usersCRUD.authenticateUser(email, password);

      if (user != null) {
        appStorage.setString(AppConstants.userKey, jsonEncode(user.toMap()));
        currentUser.value = user;
        Get.offAllNamed(Routes.HOME);
        return true;
      } else {
        error.value = 'Invalid email or password';
        return false;
      }
    } catch (e) {
      error.value = 'An error occurred during sign in';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Check if email already exists
      final exists = await _usersCRUD.isEmailExists(email);
      if (exists) {
        error.value = 'Email already exists';
        return false;
      }

      // Create new user
      final user = UserModel(
        email: email,
        password: password,
        name: name,
        defaultBudget: 1000, // Default budget for new users
      );

      final createdUser = await _usersCRUD.createUser(user);
      if (createdUser.id != null) {
        // Auto sign in after successful registration
        currentUser.value = createdUser;
        Get.offAllNamed(Routes.HOME);
        return true;
      } else {
        error.value = 'Failed to create account';
        return false;
      }
    } catch (e) {
      error.value = 'An error occurred during sign up';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void signOut() {
    currentUser.value = null;
    appStorage.remove(AppConstants.userKey);
    Get.offAllNamed(Routes.WELCOME);
  }
}
