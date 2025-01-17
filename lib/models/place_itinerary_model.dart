import 'dart:convert';

class PlaceItineraryModel {
  final int? id;
  final int dayItineraryId;
  final String placeName;
  final String placeType; // 'attraction' or 'restaurant'
  final int cost;
  final String time;
  final String? notes;
  final String? address;
  final double? rating;
  final String? imageUrl;
  final String placeDetails; // JSON string
  final String openingHours; // JSON string
  final String duration; // JSON string
  final String location; // JSON string

  PlaceItineraryModel({
    this.id,
    required this.dayItineraryId,
    required this.placeName,
    required this.placeType,
    required this.cost,
    required this.time,
    this.notes,
    this.address,
    this.rating,
    this.imageUrl,
    String? placeDetails,
    String? openingHours,
    String? duration,
    String? location,
  })  : this.placeDetails = placeDetails ?? '{}',
        this.openingHours = openingHours ?? '{}',
        this.duration = duration ?? '{}',
        this.location = location ?? '{"latitude": 0.0, "longitude": 0.0}';

  factory PlaceItineraryModel.fromMap(Map<String, dynamic> map) {
    return PlaceItineraryModel(
      id: map['id'] as int?,
      dayItineraryId: map['day_itinerary_id'] as int,
      placeName: map['place_name'] as String,
      placeType: map['place_type'] as String,
      cost: map['cost'] as int,
      time: map['time'] as String,
      notes: map['notes'] as String?,
      address: map['address'] as String?,
      rating: map['rating'] as double?,
      imageUrl: map['image_url'] as String?,
      placeDetails: map['place_details'] as String? ?? '{}',
      openingHours: map['opening_hours'] as String? ?? '{}',
      duration: map['duration'] as String? ?? '{}',
      location:
          map['location'] as String? ?? '{"latitude": 0.0, "longitude": 0.0}',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day_itinerary_id': dayItineraryId,
      'place_name': placeName,
      'place_type': placeType,
      'cost': cost,
      'time': time,
      'notes': notes,
      'address': address,
      'rating': rating,
      'image_url': imageUrl,
      'place_details': placeDetails,
      'opening_hours': openingHours,
      'duration': duration,
      'location': location,
    };
  }

  // Helper methods
  bool get isAttraction => placeType == 'attraction';
  bool get isRestaurant => placeType == 'restaurant';

  Map<String, dynamic> get placeDetailsMap =>
      json.decode(placeDetails) as Map<String, dynamic>;

  Map<String, String> get openingHoursMap {
    final map = json.decode(openingHours) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value.toString()));
  }

  Map<String, double> get locationMap {
    final map = json.decode(location) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value.toDouble()));
  }

  double get latitude => locationMap['latitude'] ?? 0.0;
  double get longitude => locationMap['longitude'] ?? 0.0;
  String get openingTime => openingHoursMap['open'] ?? '';
  String get closingTime => openingHoursMap['close'] ?? '';

  PlaceItineraryModel copyWith({
    int? id,
    int? dayItineraryId,
    String? placeName,
    String? placeType,
    int? cost,
    String? time,
    String? notes,
    String? address,
    double? rating,
    String? imageUrl,
    String? placeDetails,
    String? openingHours,
    String? duration,
    String? location,
  }) {
    return PlaceItineraryModel(
      id: id ?? this.id,
      dayItineraryId: dayItineraryId ?? this.dayItineraryId,
      placeName: placeName ?? this.placeName,
      placeType: placeType ?? this.placeType,
      cost: cost ?? this.cost,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      placeDetails: placeDetails ?? this.placeDetails,
      openingHours: openingHours ?? this.openingHours,
      duration: duration ?? this.duration,
      location: location ?? this.location,
    );
  }
}
