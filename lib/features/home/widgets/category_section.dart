import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.hotel, 'label': 'Hotel'},
      {'icon': Icons.restaurant, 'label': 'Restaurant'},
      {'icon': Icons.flight, 'label': 'Flight'},
      {'icon': Icons.car_rental, 'label': 'Rental Car'},
      {'icon': Icons.tour, 'label': 'Tours'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories
            .map(
              (category) => Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['label'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
