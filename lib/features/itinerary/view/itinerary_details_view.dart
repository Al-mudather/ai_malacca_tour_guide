import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/itinerary_content.dart';

class ItineraryDetailsView extends GetView<ItineraryController> {
  const ItineraryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCurrentItinerary();
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingView();
        }

        if (controller.currentItinerary.value == null) {
          return const ErrorView();
        }

        return const ItineraryContent();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: Obx(
        () => Text(controller.currentItinerary.value?.title ?? 'Itinerary'),
      ),
    );
  }
}
