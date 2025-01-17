import 'dart:convert';

class ChatResponseModel {
  final String type; // 'conversation' or 'itinerary'
  final String message; // For normal conversation
  final List<DayPlan>? itinerary; // For itinerary type

  ChatResponseModel({
    required this.type,
    required this.message,
    this.itinerary,
  });

  factory ChatResponseModel.fromJson(String jsonStr) {
    final data = json.decode(jsonStr);
    return ChatResponseModel(
      type: data['type'],
      message: data['message'],
      itinerary: data['itinerary'] != null
          ? List<DayPlan>.from(
              data['itinerary'].map((x) => DayPlan.fromJson(x)))
          : null,
    );
  }

  static bool isValidJson(String str) {
    try {
      json.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class DayPlan {
  final String day;
  final String title;
  final List<Activity> activities;

  DayPlan({
    required this.day,
    required this.title,
    required this.activities,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'],
      title: json['title'],
      activities: List<Activity>.from(
          json['activities'].map((x) => Activity.fromJson(x))),
    );
  }
}

class Activity {
  final String name;
  final String description;
  final String? imageUrl;
  final String? entranceFee;
  final String? duration;
  final double? rating;
  final String? tips;
  final Map<String, double>? location;

  Activity({
    required this.name,
    required this.description,
    this.imageUrl,
    this.entranceFee,
    this.duration,
    this.tips,
    this.rating,
    this.location,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      entranceFee: json['entranceFee'],
      duration: json['duration'],
      tips: json['tips'],
      rating: json['rating'],
      location: json['location'] != null
          ? Map<String, double>.from(json['location'])
          : null,
    );
  }
}
