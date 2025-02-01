import 'package:flutter/material.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';

class PlaceInfoSection extends StatelessWidget {
  final bool isFree;
  final double? price;
  final String openingDuration;

  const PlaceInfoSection({
    super.key,
    required this.isFree,
    this.price,
    required this.openingDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildInfoCard(
              icon: Icons.attach_money,
              title: 'Price',
              content: isFree ? 'Free' : 'MYR ${price?.toStringAsFixed(2)}',
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            _buildInfoCard(
              icon: Icons.access_time,
              title: 'Opening Hours',
              content: openingDuration,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
