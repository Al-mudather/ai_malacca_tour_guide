import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:flutter/material.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
          color: AppColors.white,
          shadows: const [
            Shadow(
              blurRadius: 15.0,
              color: Colors.black54,
              offset: Offset(0, 0),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          'Malacca, Malaysia',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                blurRadius: 15.0,
                color: Colors.black54,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
