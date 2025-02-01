import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/location_header.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/search_bar_widget.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/category_section.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/home_bottom_nav.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/destinations_section.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/planner_widget.dart';
import 'package:ai_malacca_tour_guide/features/account/view/account_view.dart';
import '../controllers/home_controller.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(child: LocationHeader()),
                    SizedBox(width: 16),
                    PlannerWidget(),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBarWidget(),
              ),
              const SizedBox(height: 24),
              const CategorySection(),
              const SizedBox(height: 24),
              const DestinationsSection(),
              const SizedBox(height: 24), // Add bottom padding
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
