import 'dart:convert';
import 'package:ai_malacca_tour_guide/models/day_itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';

class PlaceItineraryModel {
  final int? id;
  final int order;
  final int dayId;
  final int placeId;
  final DayItineraryModel? day;
  final Place? place;
  final String time; // Keep this from existing model as it's useful for UI

  PlaceItineraryModel({
    this.id,
    required this.order,
    required this.dayId,
    required this.placeId,
    this.day,
    this.place,
    required this.time,
  });

  factory PlaceItineraryModel.fromJson(Map<String, dynamic> json) {
    return PlaceItineraryModel(
      id: json['id'],
      order: json['order'],
      dayId: json['day_id'],
      placeId: json['place_id'],
      day: json['DayItineraryModel'] != null
          ? DayItineraryModel.fromJson(json['DayItineraryModel'])
          : null,
      place: json['Place'] != null ? Place.fromJson(json['Place']) : null,
      time: json['time'] ?? '', // Keep time field for UI purposes
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'day_id': dayId,
      'place_id': placeId,
      'time': time,
    };
  }

  String get placeType => place?.toString() ?? '';

  PlaceItineraryModel copyWith({
    int? id,
    int? order,
    int? dayId,
    int? placeId,
    DayItineraryModel? day,
    Place? place,
    String? time,
  }) {
    return PlaceItineraryModel(
      id: id ?? this.id,
      order: order ?? this.order,
      dayId: dayId ?? this.dayId,
      placeId: placeId ?? this.placeId,
      day: day ?? this.day,
      place: place ?? this.place,
      time: time ?? this.time,
    );
  }
}
