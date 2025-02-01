import 'dart:convert';

import 'package:ai_malacca_tour_guide/models/day_itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/user_model.dart';

class ItineraryModel {
  final int? id;
  final String name;
  final String? description;
  final int userId;
  final String? title;
  final String? startDate;
  final String? endDate;
  final int? totalBudget;
  final Map<String, dynamic>? preferences;
  final List<DayItineraryModel> days;
  final String? createdAt;
  final String? updatedAt;
  final String status; // draft, generated, finalized

  ItineraryModel({
    this.id,
    required this.name,
    this.description,
    required this.userId,
    this.title,
    this.startDate,
    this.endDate,
    this.totalBudget,
    this.preferences,
    this.days = const [],
    this.createdAt,
    this.updatedAt,
    this.status = 'draft', // default value
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as int,
      title: json['title'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      totalBudget: json['total_budget'] as int?,
      preferences: json['preferences'] as Map<String, dynamic>?,
      days: json['days'] != null
          ? (json['days'] as List)
              .map((day) => DayItineraryModel.fromJson(day))
              .toList()
          : [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      status: json['status'] as String? ?? 'draft',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'user_id': userId,
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'total_budget': totalBudget,
      'preferences': preferences,
      'days': days.map((day) => day.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  ItineraryModel copyWith({
    int? id,
    String? name,
    String? description,
    int? userId,
    String? title,
    String? startDate,
    String? endDate,
    int? totalBudget,
    Map<String, dynamic>? preferences,
    List<DayItineraryModel>? days,
    String? createdAt,
    String? updatedAt,
    String? status,
  }) {
    return ItineraryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalBudget: totalBudget ?? this.totalBudget,
      preferences: preferences ?? this.preferences,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
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
