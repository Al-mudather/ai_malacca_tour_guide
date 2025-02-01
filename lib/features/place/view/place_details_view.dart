import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:ai_malacca_tour_guide/features/place/controllers/place_details_controller.dart';
import 'package:ai_malacca_tour_guide/features/place/widgets/place_action_buttons.dart';
import 'package:ai_malacca_tour_guide/features/place/widgets/place_info_section.dart';
import 'package:ai_malacca_tour_guide/features/place/widgets/place_description.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';

class PlaceDetailsView extends StatelessWidget {
  final Place place;
  late final PlaceDetailsController controller;

  PlaceDetailsView({super.key, required this.place}) {
    controller = Get.put(PlaceDetailsController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.accent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PlaceInfoSection(
                  isFree: place.isFree,
                  price: place.price,
                  openingDuration: place.openingDuration,
                ),
                PlaceDescription(description: place.description),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(
                    () => controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PlaceActionButtons(
                            place: place,
                            controller: controller,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          place.imageUrl ?? 'https://via.placeholder.com/400',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/placeholder.png',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
    );
  }
}
