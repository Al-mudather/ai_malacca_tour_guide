import 'place_model.dart';
import 'user_model.dart';

class ReviewModel {
  final int? id;
  final double rating;
  final String comment;
  final int userId;
  final int placeId;
  final UserModel? user;
  final Place? place;

  ReviewModel({
    this.id,
    required this.rating,
    required this.comment,
    required this.userId,
    required this.placeId,
    this.user,
    this.place,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      rating: json['rating']?.toDouble() ?? 0.0,
      comment: json['comment'],
      userId: json['user_id'],
      placeId: json['place_id'],
      user: json['User'] != null ? UserModel.fromMap(json['User']) : null,
      place: json['Place'] != null ? Place.fromJson(json['Place']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user_id': userId,
      'place_id': placeId,
    };
  }

  ReviewModel copyWith({
    int? id,
    double? rating,
    String? comment,
    int? userId,
    int? placeId,
    UserModel? user,
    Place? place,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      userId: userId ?? this.userId,
      placeId: placeId ?? this.placeId,
      user: user ?? this.user,
      place: place ?? this.place,
    );
  }
}
