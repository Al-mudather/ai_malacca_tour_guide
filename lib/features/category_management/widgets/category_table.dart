import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/category_model.dart';
import '../../../services/category_service.dart';
import '../../../config/app_colors.dart';
import 'edit_category_dialog.dart';
import 'delete_category_dialog.dart';

class CategoryTable extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryService categoryService;

  const CategoryTable({
    super.key,
    required this.categories,
    required this.categoryService,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Get.forceAppUpdate();
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(AppColors.background),
                dataRowHeight: 72,
                horizontalMargin: 24,
                columnSpacing: 32,
                columns: [
                  DataColumn(
                    label: _buildColumnHeader('Name', Icons.label_outline),
                  ),
                  DataColumn(
                    label: _buildColumnHeader(
                        'Description', Icons.description_outlined),
                  ),
                  DataColumn(
                    label: _buildColumnHeader('Icon', Icons.image_outlined),
                  ),
                  const DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
                rows: categories.map((category) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                category.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            category.description ?? '-',
                            style: TextStyle(
                              color: category.description != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      DataCell(
                        category.icon != null
                            ? Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  IconData(
                                    int.parse(category.icon!),
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              )
                            : const Text(
                                '-',
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                              ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildActionButton(
                              icon: Icons.edit_outlined,
                              color: AppColors.primary,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => EditCategoryDialog(
                                  category: category,
                                  categoryService: categoryService,
                                ),
                              ),
                              tooltip: 'Edit Category',
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              icon: Icons.delete_outline,
                              color: Colors.red,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => DeleteCategoryDialog(
                                  category: category,
                                  categoryService: categoryService,
                                ),
                              ),
                              tooltip: 'Delete Category',
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
        ),
      ),
    );
  }

  Widget _buildColumnHeader(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
