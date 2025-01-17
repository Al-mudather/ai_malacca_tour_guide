import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import 'place_card.dart';

class PlacesSection extends GetView<ItineraryController> {
  const PlacesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PlacesSectionHeader(),
        SizedBox(
          height: 320,
          child: Obx(() {
            if (controller.currentDayPlaces.isEmpty) {
              return const Center(
                child: Text('No places added for this day yet'),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.currentDayPlaces.length,
              itemBuilder: (context, index) {
                final place = controller.currentDayPlaces[index];
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 16),
                  child: PlaceCard(place: place),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class PlacesSectionHeader extends StatelessWidget {
  const PlacesSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Places to Visit',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          // TextButton.icon(
          //   onPressed: () {
          //     // TODO: Add new place
          //   },
          //   icon: const Icon(Icons.add),
          //   label: const Text('Add Place'),
          // ),
        ],
      ),
    );
  }
}
