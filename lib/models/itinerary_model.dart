import 'dart:convert';

import 'package:ai_malacca_tour_guide/models/day_itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/user_model.dart';

class ItineraryModel {
  final int? id;
  final String name;
  final String? description;
  final int userId;
  final UserModel? user;
  final String title;
  final String startDate;
  final String endDate;
  final int totalBudget;
  final Map<String, dynamic> preferences;
  final String status; // draft, generated, finalized
  final List<DayItineraryModel> days;

  ItineraryModel({
    this.id,
    required this.name,
    this.description,
    required this.userId,
    this.user,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    this.preferences = const {},
    this.status = 'draft',
    this.days = const [],
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      userId: json['user_id'],
      user: json['User'] != null ? UserModel.fromMap(json['User']) : null,
      title: json['title'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalBudget: json['total_budget'],
      preferences:
          json['preferences'] != null ? jsonDecode(json['preferences']) : {},
      status: json['status'] ?? 'draft',
      days: json['days'] != null
          ? (json['days'] as List)
              .map((day) => DayItineraryModel.fromJson(day))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_id': userId,
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'total_budget': totalBudget,
      'preferences': jsonEncode(preferences),
      'status': status,
    };
  }

  ItineraryModel copyWith({
    int? id,
    String? name,
    String? description,
    int? userId,
    UserModel? user,
    String? title,
    String? startDate,
    String? endDate,
    int? totalBudget,
    Map<String, dynamic>? preferences,
    String? status,
    List<DayItineraryModel>? days,
  }) {
    return ItineraryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalBudget: totalBudget ?? this.totalBudget,
      preferences: preferences ?? this.preferences,
      status: status ?? this.status,
      days: days ?? this.days,
    );
  }

  // Helper methods
  int get numberOfDays => days.length;

  // Factory method to create from JSON string
  factory ItineraryModel.fromJsonString(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return ItineraryModel.fromJson(json);
  }
}
