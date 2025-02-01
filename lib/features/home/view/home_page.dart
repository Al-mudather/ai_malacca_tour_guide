import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/features/debug/debug_menu.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/location_header.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/welcome_card.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/home_bottom_nav.dart';
import 'package:ai_malacca_tour_guide/features/account/view/account_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        break;
      case 1: // Chat/New Itinerary
        Get.toNamed(Routes.CHAT);
        break;
      case 2: // Itinerary List
        Get.toNamed(Routes.ITINERARY);
        break;
      case 3: // Account
        Get.to(() => const AccountView());
        break;
      case 4: // Settings
        Get.toNamed(Routes.SETTINGS);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Background Image with Location Header
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/default_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: LocationHeader(),
              ),
            ),
          ),

          // Welcome Card
          const Expanded(
            child: WelcomeCard(),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
