import 'dart:convert';

import 'package:ai_malacca_tour_guide/models/day_itinerary_model.dart';

class ItineraryModel {
  final int? id;
  final int userId;
  final String title;
  final String startDate;
  final String endDate;
  final int totalBudget;
  final Map<String, dynamic> preferences;
  final String status; // draft, generated, finalized
  final List<DayItineraryModel>? days;

  ItineraryModel({
    this.id,
    required this.userId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    this.preferences = const {},
    this.status = 'draft',
    this.days,
  });

  factory ItineraryModel.fromMap(Map<String, dynamic> map) {
    return ItineraryModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      startDate: map['start_date'] as String,
      endDate: map['end_date'] as String,
      totalBudget: map['total_budget'] as int,
      preferences: map['preferences'] != null
          ? json.decode(map['preferences'] as String)
          : {},
      status: map['status'] as String? ?? 'draft',
      days: map['days'] != null
          ? (map['days'] as List)
              .map((day) => DayItineraryModel.fromMap(day))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'total_budget': totalBudget,
      'preferences': json.encode(preferences),
      'status': status,
    };
  }

  ItineraryModel copyWith({
    int? id,
    int? userId,
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
      userId: userId ?? this.userId,
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
  int get numberOfDays => days?.length ?? 0;

  int get totalSpent =>
      days?.fold<int>(0, (sum, day) => sum + day.totalCost) ?? 0;

  int get remainingBudget => totalBudget - totalSpent;

  bool get isWithinBudget => totalSpent <= totalBudget;

  // Factory method to create from JSON string
  factory ItineraryModel.fromJsonString(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return ItineraryModel.fromMap(json);
  }
}
