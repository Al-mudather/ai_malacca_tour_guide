import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import '../widgets/empty_itinerary_view.dart';
import '../widgets/itinerary_list_card.dart';
import '../widgets/delete_itinerary_dialog.dart';
import '../../../config/app_colors.dart';

class ItineraryView extends GetView<ItineraryController> {
  ItineraryView({super.key}) {
    controller.loadUserItineraries();
  }

  void _handleDelete(BuildContext context, int itineraryId) {
    Get.dialog(
      DeleteItineraryDialog(
        onConfirm: () => controller.deleteItinerary(itineraryId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Your Itineraries',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => controller.loadUserItineraries(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userItineraries.isEmpty) {
            return const EmptyItineraryView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.userItineraries.length,
            itemBuilder: (context, index) {
              final itinerary = controller.userItineraries[index];
              return ItineraryListCard(
                itinerary: itinerary,
                onDelete: (id) => _handleDelete(context, id),
              );
            },
          );
        }),
      ),
    );
  }
}
