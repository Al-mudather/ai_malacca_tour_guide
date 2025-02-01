import 'package:shared_preferences/shared_preferences.dart';
import 'services/user_service.dart';
import 'services/api_service.dart';

class Dependencies {
  static late final UserService userService;
  static late final ApiService apiService;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    apiService = ApiService();
    userService = UserService(api: apiService, prefs: prefs);
  }
}
