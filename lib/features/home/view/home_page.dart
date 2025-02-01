import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/location_header.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/search_bar_widget.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/category_section.dart';
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: LocationHeader(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBarWidget(),
              ),
              const SizedBox(height: 24),
              // Category Section
              const CategorySection(),
              const SizedBox(height: 24),
              // Destinations Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDestinationCard(
                          'Borobudur',
                          'Jawa Tengah, INA',
                          '4.5',
                          'assets/images/borobudur.jpg',
                        ),
                        _buildDestinationCard(
                          'Kuta Beach',
                          'Bali, INA',
                          '4.9',
                          'assets/images/kuta_beach.jpg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

  Widget _buildDestinationCard(
    String name,
    String location,
    String rating,
    String imagePath,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.overlayGradient,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
