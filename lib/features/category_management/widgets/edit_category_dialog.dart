import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import '../../../models/category_model.dart';
import '../../../services/category_service.dart';
import '../../../config/app_colors.dart';
import 'category_icon_selector.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryModel category;
  final CategoryService categoryService;

  const EditCategoryDialog({
    super.key,
    required this.category,
    required this.categoryService,
  });

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late String selectedIconCode;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
    descriptionController =
        TextEditingController(text: widget.category.description);
    selectedIconCode =
        widget.category.icon ?? CategoryIconSelector.predefinedIcons[0].code;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category name
              Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Category',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.category.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Name field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  hintText: 'Enter category name',
                  hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  prefixIcon: Icon(
                    Icons.label_outline,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              // Description field
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  hintText: 'Enter category description',
                  hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: AppColors.background,
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              // Icon selector
              CategoryIconSelector(
                initialValue: selectedIconCode,
                onChanged: (code) {
                  setState(() {
                    selectedIconCode = code;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed:
                          isLoading ? null : () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: AppColors.textSecondary.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.textSecondary,
                        disabledForegroundColor:
                            AppColors.textSecondary.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (nameController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Category name is required',
                                  backgroundColor: Colors.red,
                                  colorText: AppColors.white,
                                );
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              try {
                                await widget.categoryService.updateCategory(
                                  id: widget.category.id!,
                                  name: nameController.text.trim(),
                                  description:
                                      descriptionController.text.trim(),
                                  icon: selectedIconCode,
                                );
                                Get.back();
                                Get.snackbar(
                                  'Success',
                                  'Category updated successfully',
                                  backgroundColor: Colors.green,
                                  colorText: AppColors.white,
                                );
                                Get.forceAppUpdate();
                              } catch (e) {
                                developer.log('Error updating category',
                                    error: e);
                                Get.snackbar(
                                  'Error',
                                  'Failed to update category: $e',
                                  backgroundColor: Colors.red,
                                  colorText: AppColors.white,
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.6),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
