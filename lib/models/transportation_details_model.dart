import '../utils/types.dart';

class TransportationDetails {
  final TransportationType type;
  final double estimatedCost;
  final int estimatedMinutes;
  final String? details;

  TransportationDetails({
    required this.type,
    required this.estimatedCost,
    required this.estimatedMinutes,
    this.details,
  });

  factory TransportationDetails.fromJson(Map<String, dynamic> json) {
    return TransportationDetails(
      type: TransportationType.values.firstWhere(
        (e) => e.toString() == 'TransportationType.${json['type']}',
      ),
      estimatedCost: json['estimated_cost']?.toDouble() ?? 0.0,
      estimatedMinutes: json['estimated_minutes'] ?? 0,
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'estimated_cost': estimatedCost,
      'estimated_minutes': estimatedMinutes,
      'details': details,
    };
  }
}
