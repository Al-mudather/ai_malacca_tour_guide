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
      case 1: // Itinerary List
        Get.toNamed(Routes.ITINERARY);
        break;
      case 2: // Account
        Get.to(() => const AccountView());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: LocationHeader()),
                    SizedBox(width: 16),
                    PlannerWidget(),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: SearchBarWidget(),
              // ),
              SizedBox(height: 24),
              CategorySection(),
              SizedBox(height: 24),
              DestinationsSection(),
              SizedBox(height: 24), // Add bottom padding
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
