import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:ai_malacca_tour_guide/features/auth/view/sign_in_view.dart';
import 'package:ai_malacca_tour_guide/features/auth/view/sign_up_view.dart';
import 'package:ai_malacca_tour_guide/features/chat/bindings/chat_binding.dart';
import 'package:ai_malacca_tour_guide/features/chat/view/chat_view.dart';
import 'package:ai_malacca_tour_guide/features/home/view/home_page.dart';
import 'package:ai_malacca_tour_guide/features/welcome/view/welcome_view.dart';
import 'package:ai_malacca_tour_guide/features/itinerary/view/itinerary_view.dart';
import 'package:ai_malacca_tour_guide/features/itinerary/view/itinerary_details_view.dart';
import 'package:ai_malacca_tour_guide/features/itinerary/bindings/itinerary_binding.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:ai_malacca_tour_guide/features/debug/debug_menu.dart';
import 'package:ai_malacca_tour_guide/features/map/view/map_screen.dart';
import 'package:ai_malacca_tour_guide/features/settings/view/settings_view.dart';
import 'package:ai_malacca_tour_guide/features/settings/bindings/settings_binding.dart';
import 'package:ai_malacca_tour_guide/features/user_management/view/user_management_view.dart';
import 'package:ai_malacca_tour_guide/features/user_management/bindings/user_management_binding.dart';
import 'package:ai_malacca_tour_guide/features/category_management/view/category_management_view.dart';
import 'package:ai_malacca_tour_guide/features/category_management/bindings/category_management_binding.dart';
import 'package:ai_malacca_tour_guide/features/place_management/view/place_management_view.dart';
import 'package:ai_malacca_tour_guide/features/place_management/bindings/place_management_binding.dart';
import 'package:ai_malacca_tour_guide/features/database_management/view/database_management_view.dart';
import 'package:ai_malacca_tour_guide/features/database_management/bindings/database_management_binding.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => SignInView(),
    ),
    GetPage(
      name: Routes.SIGN_UP,
      page: () => const SignUpView(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.ITINERARY,
      page: () => ItineraryView(),
      binding: ItineraryBinding(),
    ),
    GetPage(
      name: Routes.ITINERARY_DETAILS,
      page: () => const ItineraryDetailsView(),
      binding: ItineraryBinding(),
    ),
    GetPage(
      name: Routes.MAP,
      page: () => MapScreen(
        destinationLatitude: Get.arguments['latitude'] as double,
        destinationLongitude: Get.arguments['longitude'] as double,
      ),
    ),
    if (kDebugMode)
      GetPage(
        name: '/debug',
        page: () => const DebugMenu(),
      ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.USER_MANAGEMENT,
      page: () => const UserManagementView(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY_MANAGEMENT,
      page: () => const CategoryManagementView(),
      binding: CategoryManagementBinding(),
    ),
    GetPage(
      name: Routes.PLACE_MANAGEMENT,
      page: () => const PlaceManagementView(),
      binding: PlaceManagementBinding(),
    ),
  ];
}

abstract class Routes {
  Routes._();
  static const WELCOME = '/welcome';
  static const HOME = '/home';
  static const SIGN_IN = '/sign-in';
  static const SIGN_UP = '/sign-up';
  static const CHAT = '/chat';
  static const ITINERARY = '/itinerary';
  static const ITINERARY_DETAILS = '/itinerary/details';
  static const MAP = '/map';
  static const SETTINGS = '/settings';
  static const USER_MANAGEMENT = '/user-management';
  static const CATEGORY_MANAGEMENT = '/category-management';
  static const PLACE_MANAGEMENT = '/place-management';
  static const DATABASE_MANAGEMENT = '/database-management';
}
