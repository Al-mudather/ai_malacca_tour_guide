// lib/models/place_model.dart
import 'dart:convert';
import '../utils/types.dart';

class Place {
  final int? id;
  final String name;
  final String description;
  final PlaceType type;
  final double estimatedCost;
  final String openingHours;
  final double rating;
  final String? imageUrl;
  final Metadata details;
  final String location;
  final Coordinates coordinates;

  Place({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.estimatedCost,
    required this.openingHours,
    required this.rating,
    this.imageUrl,
    this.details = const {},
    required this.location,
    required this.coordinates,
  });

  factory Place.fromJson(JsonMap json) {
    return Place(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: TypeHelpers.stringToPlaceType(json['type']),
      estimatedCost: json['estimated_cost']?.toDouble() ?? 0.0,
      openingHours: json['opening_hours'],
      rating: json['rating']?.toDouble() ?? 0.0,
      imageUrl: json['image_url'],
      details: json['details'] ?? TypeConstants.defaultMetadata,
      location: json['location'],
      coordinates: Map<String, double>.from(
        json['coordinates'] ?? TypeConstants.defaultCoordinates,
      ),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': TypeHelpers.enumToString(type),
      'estimated_cost': estimatedCost,
      'opening_hours': openingHours,
      'rating': rating,
      'image_url': imageUrl,
      'details': details,
      'location': location,
      'coordinates': coordinates,
    };
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
