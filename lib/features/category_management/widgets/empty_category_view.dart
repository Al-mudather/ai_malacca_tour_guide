import 'package:flutter/material.dart';

class EmptyCategoryView extends StatelessWidget {
  const EmptyCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No categories found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
