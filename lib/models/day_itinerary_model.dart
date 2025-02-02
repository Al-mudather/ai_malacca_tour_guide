import 'dart:convert';
import 'package:ai_malacca_tour_guide/models/itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/place_itinerary_model.dart';

class DayItineraryModel {
  final int? id;
  final int dayNumber;
  final int itineraryId;
  final ItineraryModel? itinerary;
  final List<PlaceItineraryModel> places;
  final DateTime date;
  final String? createdAt;
  final String? updatedAt;

  DayItineraryModel({
    this.id,
    required this.dayNumber,
    required this.itineraryId,
    this.itinerary,
    this.places = const [],
    DateTime? date,
    this.createdAt,
    this.updatedAt,
  }) : date = date ?? DateTime.now();

  factory DayItineraryModel.fromJson(Map<String, dynamic> json) {
    return DayItineraryModel(
      id: json['id'],
      dayNumber: json['day_number'],
      itineraryId: json['itinerary_id'],
      itinerary: json['ItineraryModel'] != null
          ? ItineraryModel.fromJson(json['ItineraryModel'])
          : null,
      places: json['PlaceItineraryModels'] != null
          ? (json['PlaceItineraryModels'] as List)
              .map((place) => PlaceItineraryModel.fromJson(place))
              .toList()
          : [],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_number': dayNumber,
      'itinerary_id': itineraryId,
      'date': date.toIso8601String(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itinerary_id': itineraryId,
      'date': date.toIso8601String(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static DayItineraryModel fromMap(Map<String, dynamic> map) {
    return DayItineraryModel(
      id: map['id'] as int?,
      dayNumber: map['day_number'] as int,
      itineraryId: map['itinerary_id'] as int,
      itinerary: map['ItineraryModel'] != null
          ? ItineraryModel.fromJson(map['ItineraryModel'])
          : null,
      places: map['PlaceItineraryModels'] != null
          ? (map['PlaceItineraryModels'] as List)
              .map((place) => PlaceItineraryModel.fromJson(place))
              .toList()
          : [],
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now(),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  DayItineraryModel copyWith({
    int? id,
    int? dayNumber,
    int? itineraryId,
    ItineraryModel? itinerary,
    List<PlaceItineraryModel>? places,
    DateTime? date,
    String? createdAt,
    String? updatedAt,
  }) {
    return DayItineraryModel(
      id: id ?? this.id,
      dayNumber: dayNumber ?? this.dayNumber,
      itineraryId: itineraryId ?? this.itineraryId,
      itinerary: itinerary ?? this.itinerary,
      places: places ?? this.places,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  int get numberOfPlaces => places.length;

  bool get hasRestaurant =>
      places.any((place) => place.placeType == 'restaurant');

  List<PlaceItineraryModel> get attractions =>
      places.where((place) => place.placeType == 'attraction').toList();

  List<PlaceItineraryModel> get restaurants =>
      places.where((place) => place.placeType == 'restaurant').toList();

  String get firstPlaceTime => places.first.time;

  String get lastPlaceTime => places.last.time;
}
