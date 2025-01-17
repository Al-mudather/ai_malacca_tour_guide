import 'package:ai_malacca_tour_guide/config/app_theme.dart';
import 'package:ai_malacca_tour_guide/config/env.dart';
import 'package:ai_malacca_tour_guide/database/base/database_helper.dart';
import 'package:ai_malacca_tour_guide/config/dependencies.dart' as dep;
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await Environment.initialize();

  // Initialize database by just accessing it once
  await DatabaseHelper.instance.database;

  // Load the dependences
  await dep.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Malecca AI Tour',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
