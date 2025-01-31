import '../models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _api;

  CategoryService({ApiService? api}) : _api = api ?? ApiService();

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _api.get('/api/categories');
    return (response['data'] as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  // Create a new category
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    String? icon,
  }) async {
    final response = await _api.post('/api/categories', {
      'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
    });
    return CategoryModel.fromJson(response);
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
