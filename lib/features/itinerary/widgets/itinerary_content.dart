import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import 'day_selector.dart';
import 'itinerary_map.dart';
import 'places_section.dart';
import 'trip_info_section.dart';
import 'empty_itinerary_message.dart';

class ItineraryContent extends GetView<ItineraryController> {
  const ItineraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.days.isEmpty) {
        return const EmptyItineraryMessage();
      }

      return const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: TripInfoSection()),
          SliverToBoxAdapter(child: DaySelector()),
          SliverToBoxAdapter(child: PlacesSection()),
        ],
      );
    });
  }
}
