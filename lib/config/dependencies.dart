import 'package:ai_malacca_tour_guide/controllers/agent_controller.dart';
import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:ai_malacca_tour_guide/services/api_service.dart';
import 'package:ai_malacca_tour_guide/services/user_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  print('Initializing dependencies...');

  // Initialize AgentController as a permanent instance
  try {
    final agentController = AgentController();
    final sharedPreferences = await SharedPreferences.getInstance();
    // Get.lazyPut(() => AuthController(), fenix: true);
    Get.put(ApiService());
    // Register dependencies
    Get.put(UserService(prefs: sharedPreferences));
    Get.lazyPut(() => sharedPreferences, fenix: true);
    Get.lazyPut(() => AuthController(appStorage: Get.find()), fenix: true);
    Get.put<AgentController>(agentController, permanent: true);
  } catch (e) {
    print('Error initializing AgentController: $e');
  }
}
