import 'place_model.dart';

class FavoriteModel {
  final int? id;
  final int userId;
  final int placeId;
  final Place? place;

  FavoriteModel({
    this.id,
    required this.userId,
    required this.placeId,
    this.place,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['user_id'],
      placeId: json['place_id'],
      place: json['Place'] != null ? Place.fromJson(json['Place']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'place_id': placeId,
    };
  }

  FavoriteModel copyWith({
    int? id,
    int? userId,
    int? placeId,
    Place? place,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
    );
  }
}
