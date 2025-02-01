import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/location_header.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/search_bar_widget.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/category_section.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/home_bottom_nav.dart';
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

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final selectedCategory = homeController.selectedCategory;
                      return Text(
                        selectedCategory == null
                            ? 'All Destinations'
                            : '${selectedCategory.name} Destinations',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (homeController.isLoading) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      if (homeController.error.isNotEmpty) {
                        return _buildEmptyState(
                          homeController.error,
                          Icons.error_outline,
                        );
                      }

                      if (homeController.places.isEmpty) {
                        return _buildEmptyState(
                          homeController.selectedCategory == null
                              ? 'No destinations available'
                              : 'No destinations found in ${homeController.selectedCategory!.name} category',
                          Icons.location_off_outlined,
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: homeController.places.length,
                        itemBuilder: (context, index) {
                          final place = homeController.places[index];
                          return _buildDestinationCard(
                            place.name,
                            place.location,
                            '4.5', // You might want to add a rating field to your Place model
                            place.imageUrl ?? 'assets/images/default_place.jpg',
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
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

  Widget _buildDestinationCard(
    String name,
    String location,
    String rating,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: imagePath.startsWith('http')
              ? NetworkImage(imagePath) as ImageProvider
              : AssetImage(imagePath),
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
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
