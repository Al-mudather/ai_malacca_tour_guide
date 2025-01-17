import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import '../widgets/itinerary_app_bar.dart';
import '../widgets/empty_itinerary_view.dart';
import '../widgets/itinerary_list_item.dart';

class ItineraryView extends GetView<ItineraryController> {
  ItineraryView({super.key}) {
    controller.loadUserItineraries();
  }

  void _handleAddNewTrip() {
    // TODO: Implement add new trip
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ItineraryAppBar(onAddPressed: _handleAddNewTrip),
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.userItineraries.isEmpty) {
              return SliverFillRemaining(
                child: EmptyItineraryView(
                  onCreatePressed: _handleAddNewTrip,
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final itinerary = controller.userItineraries[index];
                    return ItineraryListItem(itinerary: itinerary);
                  },
                  childCount: controller.userItineraries.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
