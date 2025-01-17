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
    if (kDebugMode)
      GetPage(
        name: '/debug',
        page: () => const DebugMenu(),
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
}
