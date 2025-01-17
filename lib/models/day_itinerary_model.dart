import 'dart:convert';
import 'package:ai_malacca_tour_guide/models/place_itinerary_model.dart';

class DayItineraryModel {
  final int? id;
  final int itineraryId;
  final String date;
  final int totalCost;
  final List<PlaceItineraryModel>? places;
  final String status; // planned, in-progress, completed
  final String weatherInfo; // JSON string

  DayItineraryModel({
    this.id,
    required this.itineraryId,
    required this.date,
    required this.totalCost,
    this.places,
    this.status = 'planned',
    Map<String, dynamic>? weatherInfo,
  }) : this.weatherInfo = json.encode(weatherInfo ?? {});

  factory DayItineraryModel.fromMap(Map<String, dynamic> map) {
    return DayItineraryModel(
      id: map['id'] as int?,
      itineraryId: map['itinerary_id'] as int,
      date: map['date'] as String,
      totalCost: map['total_cost'] as int,
      places: map['places'] != null
          ? (map['places'] as List)
              .map((place) => PlaceItineraryModel.fromMap(place))
              .toList()
          : null,
      status: map['status'] as String? ?? 'planned',
      weatherInfo: map['weather_info'] != null
          ? json.decode(map['weather_info'] as String)
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itinerary_id': itineraryId,
      'date': date,
      'total_cost': totalCost,
      'status': status,
      'weather_info': weatherInfo,
    };
  }

  DayItineraryModel copyWith({
    int? id,
    int? itineraryId,
    String? date,
    int? totalCost,
    List<PlaceItineraryModel>? places,
    String? status,
    Map<String, dynamic>? weatherInfo,
  }) {
    return DayItineraryModel(
      id: id ?? this.id,
      itineraryId: itineraryId ?? this.itineraryId,
      date: date ?? this.date,
      totalCost: totalCost ?? this.totalCost,
      places: places ?? this.places,
      status: status ?? this.status,
      weatherInfo: weatherInfo ?? json.decode(this.weatherInfo),
    );
  }

  // Helper methods
  int get numberOfPlaces => places?.length ?? 0;

  bool get hasRestaurant =>
      places?.any((place) => place.placeType == 'restaurant') ?? false;

  List<PlaceItineraryModel> get attractions =>
      places?.where((place) => place.placeType == 'attraction').toList() ?? [];

  List<PlaceItineraryModel> get restaurants =>
      places?.where((place) => place.placeType == 'restaurant').toList() ?? [];

  String get firstPlaceTime => places?.first.time ?? '';

  String get lastPlaceTime => places?.last.time ?? '';

  // Helper getter for decoded weather info
  Map<String, dynamic> get weatherInfoMap => json.decode(weatherInfo);
}
