import 'package:ai_malacca_tour_guide/features/itinerary/controllers/itinerary_controller.dart';
import 'package:ai_malacca_tour_guide/models/chat_response_model.dart';
import 'package:ai_malacca_tour_guide/utils/place_images.dart';
import 'package:ai_malacca_tour_guide/database/crud/itineraries_crud.dart';
import 'package:ai_malacca_tour_guide/database/crud/day_itineraries_crud.dart';
import 'package:ai_malacca_tour_guide/database/crud/place_itineraries_crud.dart';
import 'package:ai_malacca_tour_guide/models/itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/day_itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/place_itinerary_model.dart';
import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ItineraryCard extends StatelessWidget {
  final DayPlan dayPlan;

  const ItineraryCard({
    super.key,
    required this.dayPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '${dayPlan.day} : ${dayPlan.title}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(
          height: 420,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dayPlan.activities.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 270,
                child: ActivityCard(
                  activity: dayPlan.activities[index],
                  dayNumber:
                      int.tryParse(dayPlan.day.replaceAll('Day ', '')) ?? 1,
                  showSwipeIndicator:
                      index == 0 && dayPlan.activities.length > 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final int dayNumber;
  final bool showSwipeIndicator;

  final _itineraryController = Get.find<ItineraryController>();

  ActivityCard({
    super.key,
    required this.activity,
    required this.dayNumber,
    this.showSwipeIndicator = false,
  });

  Widget _buildRatingBar(double rating) {
    return Row(
      children: [
        Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _addToTrip(BuildContext context) async {
    try {
      _itineraryController.addActivityToTrip(activity, dayNumber);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place added to your trip successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add place to trip. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              FutureBuilder<String?>(
                future: PlaceImages().getUnsplashImage(activity.name),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.network(
                      snapshot.data!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    );
                  }
                  return Container(
                    height: 140,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              if (showSwipeIndicator)
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swipe, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Swipe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity.description,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  if (activity.entranceFee != null ||
                      activity.rating != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (activity.entranceFee != null)
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.confirmation_number, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    activity.entranceFee!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (activity.rating != null)
                          _buildRatingBar(activity.rating!),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (activity.duration != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            activity.duration!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (activity.tips != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              activity.tips!,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToTrip(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add To Trip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
