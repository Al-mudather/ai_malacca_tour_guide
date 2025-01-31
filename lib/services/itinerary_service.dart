import '../models/itinerary_model.dart';
import 'api_service.dart';

class ItineraryService {
  final ApiService _api;

  ItineraryService({ApiService? api}) : _api = api ?? ApiService();

  // Create a new itinerary
  Future<ItineraryModel> createItinerary({
    required String name,
    required String description,
    required int userId,
    required String title,
    required String startDate,
    required String endDate,
    required int totalBudget,
    Map<String, dynamic>? preferences,
  }) async {
    final response = await _api.post('/api/itineraries/create', {
      'name': name,
      'description': description,
      'user_id': userId,
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'total_budget': totalBudget,
      if (preferences != null) 'preferences': preferences,
    });
    return ItineraryModel.fromJson(response);
  }

  // Get all itineraries
  Future<List<ItineraryModel>> getAllItineraries() async {
    final response = await _api.get('/api/itineraries');
    return (response['data'] as List)
        .map((json) => ItineraryModel.fromJson(json))
        .toList();
  }

  // Get itinerary by ID
  Future<ItineraryModel> getItineraryById(int id) async {
    final response = await _api.get('/api/itineraries/$id');
    return ItineraryModel.fromJson(response);
  }

  // Update itinerary
  Future<ItineraryModel> updateItinerary({
    required int id,
    String? name,
    String? description,
    String? title,
    String? startDate,
    String? endDate,
    int? totalBudget,
    Map<String, dynamic>? preferences,
    String? status,
  }) async {
    final Map<String, dynamic> data = {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (totalBudget != null) 'total_budget': totalBudget,
      if (preferences != null) 'preferences': preferences,
      if (status != null) 'status': status,
    };

    final response = await _api.put('/api/itineraries/update/$id', data);
    return ItineraryModel.fromJson(response);
  }

  // Delete itinerary
  Future<void> deleteItinerary(int id) async {
    await _api.delete('/api/itineraries/delete/$id');
  }

  // Get user's itineraries
  Future<List<ItineraryModel>> getUserItineraries(int userId) async {
    final response = await _api.get('/api/itineraries?user_id=$userId');
    return (response['data'] as List)
        .map((json) => ItineraryModel.fromJson(json))
        .toList();
  }
}
