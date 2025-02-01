import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/services/category_service.dart';
import 'package:ai_malacca_tour_guide/models/category_model.dart';
import '../controllers/home_controller.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  IconData _getIconData(String? iconCode) {
    if (iconCode == null || iconCode.isEmpty) {
      return Icons.category;
    }
    try {
      return IconData(
        int.parse(iconCode),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryService = Get.find<CategoryService>();
    final homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<CategoryModel>>(
            future: categoryService.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading categories',
                    style: TextStyle(color: Colors.red[400]),
                  ),
                );
              }

              final categories = snapshot.data ?? [];

              // Add "All" category at the beginning
              final allCategories = [
                CategoryModel(name: 'All', icon: '0xe148'), // Icons.category
                ...categories,
              ];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Row(
                    children: allCategories.asMap().entries.map((entry) {
                      final category = entry.value;
                      final isSelected =
                          homeController.selectedCategory?.id == category.id ||
                              (homeController.selectedCategory == null &&
                                  category.name == 'All');

                      return Padding(
                        padding: EdgeInsets.only(
                          right: entry.key == allCategories.length - 1 ? 0 : 24,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            homeController.selectCategory(
                              category.name == 'All' ? null : category,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getIconData(category.icon),
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
