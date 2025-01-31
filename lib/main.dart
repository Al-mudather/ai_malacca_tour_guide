import 'package:ai_malacca_tour_guide/config/app_theme.dart';
import 'package:ai_malacca_tour_guide/config/env.dart';
import 'package:ai_malacca_tour_guide/database/base/database_helper.dart';
import 'package:ai_malacca_tour_guide/config/dependencies.dart' as dep;
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await Environment.initialize();

  // Initialize database by just accessing it once
  await DatabaseHelper.instance.initializeMockData();

  // Load the dependences
  await dep.init();

  // Check if user is logged in
  final authController = Get.find<AuthController>();
  final initialRoute =
      authController.currentUser.value != null ? Routes.HOME : Routes.WELCOME;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Malecca AI Tour',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
