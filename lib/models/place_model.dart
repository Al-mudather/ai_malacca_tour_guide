// lib/models/place_model.dart
import 'dart:convert';
import '../utils/types.dart';
import 'category_model.dart';

class Place {
  final int? id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final String openingDuration;
  final bool isFree;
  final double? price;
  final String description;
  final String? imageUrl;
  final int categoryId;
  final CategoryModel? category;

  Place({
    this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.openingDuration,
    required this.isFree,
    this.price,
    required this.description,
    this.imageUrl,
    required this.categoryId,
    this.category,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      openingDuration: json['opening_duration']?.toString() ?? '',
      isFree: json['is_free'] ?? false,
      price: json['price']?.toDouble(),
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      categoryId: json['category_id'] is String
          ? int.parse(json['category_id'])
          : (json['category_id'] ?? 0),
      category: json['Category'] != null
          ? CategoryModel.fromJson(json['Category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'opening_duration': openingDuration,
      'is_free': isFree,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'category_id': categoryId,
    };
  }

  Place copyWith({
    int? id,
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
    CategoryModel? category,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingDuration: openingDuration ?? this.openingDuration,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
    );
  }

  // Add static method to parse a list of places from JSON string
  static List<Place> listFromJson(String jsonStr) {
    try {
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing place list: $e');
      return [];
    }
  }

  // Add static method to parse a list of places from JSON list
  static List<Place> listFromJsonList(List<dynamic> jsonList) {
    try {
      return jsonList.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing place list: $e');
      return [];
    }
  }

  // Optional: Add method to create a JSON string from a list of places
  static String listToJson(List<Place> places) {
    return json.encode(places.map((place) => place.toJson()).toList());
  }
}
