import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/features/home/controllers/home_controller.dart';
import 'package:ai_malacca_tour_guide/features/home/widgets/destination_card.dart';

class DestinationsSection extends StatelessWidget {
  const DestinationsSection({super.key});

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

    return Padding(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: homeController.places.length,
              itemBuilder: (context, index) {
                final place = homeController.places[index];
                return DestinationCard(place: place);
              },
            );
          }),
        ],
      ),
    );
  }
}
