import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/place_model.dart';
import '../../../models/category_model.dart';
import '../../../services/place_service.dart';
import '../../../services/category_service.dart';
import '../../../config/app_colors.dart';
import 'edit_place_dialog.dart';
import 'delete_place_dialog.dart';

class PlaceTable extends StatefulWidget {
  final List<Place> places;
  final PlaceService placeService;
  final VoidCallback onPlaceDeleted;

  const PlaceTable({
    super.key,
    required this.places,
    required this.placeService,
    required this.onPlaceDeleted,
  });

  @override
  State<PlaceTable> createState() => _PlaceTableState();
}

class _PlaceTableState extends State<PlaceTable> {
  CategoryModel? _selectedCategory;

  List<Place> get _filteredPlaces {
    if (_selectedCategory == null) return widget.places;
    return widget.places
        .where((place) => place.category?.id == _selectedCategory!.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: FutureBuilder<List<CategoryModel>>(
              future: Get.find<CategoryService>().getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.2),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Error loading categories',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }

                final categories = snapshot.data ?? [];

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.filter_list_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Filter by Category:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CategoryModel?>(
                            value: _selectedCategory,
                            hint: const Text('All Categories'),
                            items: [
                              const DropdownMenuItem<CategoryModel?>(
                                value: null,
                                child: Text('All Categories'),
                              ),
                              ...categories.map((category) {
                                return DropdownMenuItem<CategoryModel>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                    AppColors.primary.withOpacity(0.1)),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Opening Hours')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredPlaces.map((place) {
                  return DataRow(
                    cells: [
                      DataCell(Text(place.name)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            place.category?.name ?? 'Uncategorized',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(place.openingDuration)),
                      DataCell(Text(place.isFree
                          ? 'Free'
                          : 'RM ${place.price?.toStringAsFixed(2) ?? "N/A"}')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.primary),
                              onPressed: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (context) => EditPlaceDialog(
                                    place: place,
                                    placeService: widget.placeService,
                                  ),
                                );
                                if (result == true) {
                                  widget.onPlaceDeleted(); // Refresh after edit
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (context) => DeletePlaceDialog(
                                    place: place,
                                    placeService: widget.placeService,
                                  ),
                                );
                                if (result == true) {
                                  widget
                                      .onPlaceDeleted(); // Refresh after delete
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
