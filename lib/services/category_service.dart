import '../models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _api;

  CategoryService({ApiService? api}) : _api = api ?? ApiService();

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _api.get('/api/categories');
    if (response is List) {
      return response.map((json) => CategoryModel.fromJson(json)).toList();
    } else if (response is Map<String, dynamic> &&
        response.containsKey('data')) {
      return (response['data'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  // Create a new category
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    String? icon,
  }) async {
    final response = await _api.post('/api/categories/create', {
      'name': name,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (icon != null && icon.isNotEmpty) 'icon': icon,
    });
    return CategoryModel.fromJson(response);
  }

  // Update an existing category
  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    String? description,
    String? icon,
  }) async {
    final response = await _api.put('/api/categories/update/$id', {
      'name': name,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (icon != null && icon.isNotEmpty) 'icon': icon,
    });
    return CategoryModel.fromJson(response);
  }

  // Delete a category
  Future<void> deleteCategory(int id) async {
    await _api.delete('/api/categories/delete/$id');
  }

  // Get category by ID
  Future<CategoryModel> getCategoryById(int id) async {
    final response = await _api.get('/api/categories/$id');
    return CategoryModel.fromJson(response);
  }

  // Get places by category
  Future<List<CategoryModel>> getPlacesByCategory(int categoryId) async {
    final response = await _api.get('/api/categories/$categoryId/places');
    return (response['data'] as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
