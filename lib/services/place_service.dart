import '../models/place_model.dart';
import '../models/category_model.dart';
import 'api_service.dart';
import 'category_service.dart';
import 'package:get/get.dart';

class PlaceService {
  final ApiService _api;
  late final CategoryService _categoryService;

  PlaceService({ApiService? api}) : _api = api ?? ApiService() {
    _categoryService = Get.find<CategoryService>();
  }

  // Create a new place
  Future<Place> createPlace({
    required String name,
    required String location,
    required double latitude,
    required double longitude,
    required String openingDuration,
    required bool isFree,
    double? price,
    required String description,
    String? imageUrl,
    required int categoryId,
  }) async {
    final response = await _api.post('/api/places/create', {
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'opening_duration': openingDuration,
      'is_free': isFree,
      if (price != null) 'price': price,
      'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      'category_id': categoryId,
    });
    return Place.fromJson(response);
  }

  // Get all places
  Future<List<Place>> getAllPlaces() async {
    final response = await _api.get('/api/places');
    final List<dynamic> data = response['data'] as List;

    // First, get all categories to avoid multiple API calls
    final categories = await _categoryService.getAllCategories();
    final categoryMap = {for (var cat in categories) cat.id: cat};

    return data.asMap().entries.map((entry) {
      final json = entry.value;
      if (json is Map<String, dynamic>) {
        // Get the category from our map using category_id
        final categoryId = json['category_id'] is String
            ? int.parse(json['category_id'])
            : json['category_id'] as int?;

        print('Processing place with category_id: $categoryId');

        // Add category to the JSON if we found it
        if (categoryId != null && categoryMap.containsKey(categoryId)) {
          final category = categoryMap[categoryId]!;
          // Use the proper toJson method from CategoryModel
          json['Category'] = category.toJson();
          print('Added category to place: ${json['Category']}');
        } else {
          print('Category not found for id: $categoryId');
        }

        final place = Place.fromJson(json);
        print('Created place with category: ${place.category?.name}');
        return place;
      }
      throw FormatException('Invalid place data format at index ${entry.key}');
    }).toList();
  }

  // Get place by ID
  Future<Place> getPlaceById(int id) async {
    final response = await _api.get('/api/places/$id');
    final json = response;

    // Get the category data
    final categoryId = json['category_id'] is String
        ? int.parse(json['category_id'])
        : json['category_id'] as int?;

    if (categoryId != null) {
      final category = await _categoryService.getCategoryById(categoryId);
      json['category'] = category.toJson();
    }

    return Place.fromJson(json);
  }

  // Update place
  Future<Place> updatePlace({
    required int id,
    String? name,
    String? location,
    double? latitude,
    double? longitude,
    String? openingDuration,
    bool? isFree,
    double? price,
    String? description,
    String? imageUrl,
    int? categoryId,
  }) async {
    final Map<String, dynamic> data = {
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (openingDuration != null) 'opening_duration': openingDuration,
      if (isFree != null) 'is_free': isFree,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (categoryId != null) 'category_id': categoryId,
    };

    final response = await _api.put('/api/places/update/$id', data);
    return Place.fromJson(response);
  }

  // Delete place
  Future<void> deletePlace(int id) async {
    await _api.delete('/api/places/delete/$id');
  }

  // Get places by category
  Future<List<Place>> getPlacesByCategory(int categoryId) async {
    final response = await _api.get('/api/places?category_id=$categoryId');
    final List<dynamic> data = response['data'] as List;

    // Get the category once since all places have the same category
    final category = await _categoryService.getCategoryById(categoryId);

    return data.map((json) {
      if (json is Map<String, dynamic>) {
        json['category'] = category.toJson();
        return Place.fromJson(json);
      }
      throw FormatException('Invalid place data format');
    }).toList();
  }

  // Search places
  Future<List<Place>> searchPlaces(String query) async {
    final response = await _api.get('/api/places/search?q=$query');
    final List<dynamic> data = response['data'] as List;
    return data.map((json) {
      if (json is Map<String, dynamic>) {
        return Place.fromJson(json);
      }
      throw FormatException('Invalid place data format');
    }).toList();
  }

  // Get nearby places
  Future<List<Place>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    final response = await _api.get(
        '/api/places/nearby?latitude=$latitude&longitude=$longitude&radius=$radiusInKm');
    final List<dynamic> data = response['data'] as List;
    return data.map((json) {
      if (json is Map<String, dynamic>) {
        return Place.fromJson(json);
      }
      throw FormatException('Invalid place data format');
    }).toList();
  }
}
