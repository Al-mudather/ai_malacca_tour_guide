import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';

class DestinationCard extends StatelessWidget {
  final Place place;

  const DestinationCard({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.PLACE_DETAILS,
        arguments: {'place': place},
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: place.imageUrl != null && place.imageUrl!.startsWith('/')
                ? NetworkImage("http://localhost:5000${place.imageUrl!}")
                    as ImageProvider
                : const AssetImage('assets/images/default_place.jpg'),
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
                    '4.5', // You might want to add a rating field to your Place model
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                place.name,
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
                      place.location,
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
      ),
    );
  }
}
