import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import 'day_selector.dart';
import 'itinerary_map.dart';
import 'places_section.dart';
import 'trip_info_section.dart';

class ItineraryContent extends GetView<ItineraryController> {
  const ItineraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: TripInfoSection()),
        const SliverToBoxAdapter(child: DaySelector()),
        const SliverToBoxAdapter(child: PlacesSection()),
      ],
    );
  }
}
