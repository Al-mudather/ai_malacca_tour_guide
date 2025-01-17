import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:ai_malacca_tour_guide/models/transportation_details_model.dart';

class PlaceVisit {
  final int? id;
  final int? dayItineraryId;
  final Place place;
  final String timeSlot;
  final double estimatedCost;
  final Map<String, dynamic> notes;
  final TransportationDetails? transportation;

  PlaceVisit({
    this.id,
    this.dayItineraryId,
    required this.place,
    required this.timeSlot,
    required this.estimatedCost,
    this.notes = const {},
    this.transportation,
  });

  factory PlaceVisit.fromJson(Map<String, dynamic> json) {
    return PlaceVisit(
      id: json['id'],
      dayItineraryId: json['day_itinerary_id'],
      place: Place.fromJson(json['place']),
      timeSlot: json['time_slot'],
      estimatedCost: json['estimated_cost']?.toDouble() ?? 0.0,
      notes: json['notes'] ?? {},
      transportation: json['transportation'] != null
          ? TransportationDetails.fromJson(json['transportation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_itinerary_id': dayItineraryId,
      'place': place.toJson(),
      'time_slot': timeSlot,
      'estimated_cost': estimatedCost,
      'notes': notes,
      'transportation': transportation?.toJson(),
    };
  }
}
