import '../models/day_itinerary_model.dart';
import 'api_service.dart';

class DayItineraryService {
  final ApiService _api;

  DayItineraryService({ApiService? api}) : _api = api ?? ApiService();

  // Create a new day itinerary
  Future<DayItineraryModel> createDayItinerary({
    required int dayNumber,
    required int itineraryId,
  }) async {
    final response = await _api.post('/api/day-itineraries/create', {
      'day_number': dayNumber,
      'itinerary_id': itineraryId,
    });
    return DayItineraryModel.fromJson(response);
  }

  // Get all day itineraries for an itinerary
  Future<List<DayItineraryModel>> getDayItineraries(int itineraryId) async {
    final response = await _api.get('/api/day-itineraries/$itineraryId');

    return (response['data'] as List)
        .map((json) => DayItineraryModel.fromJson(json))
        .toList();
  }

  // Get day itinerary by ID
  Future<DayItineraryModel> getDayItineraryById(int id) async {
    final response = await _api.get('/api/day-itineraries/$id');
    return DayItineraryModel.fromJson(response);
  }

  // Update day itinerary
  Future<DayItineraryModel> updateDayItinerary({
    required int id,
    int? dayNumber,
  }) async {
    final Map<String, dynamic> data = {
      if (dayNumber != null) 'day_number': dayNumber,
    };

    final response = await _api.put('/api/day-itineraries/update/$id', data);
    return DayItineraryModel.fromJson(response);
  }

  // Delete day itinerary
  Future<void> deleteDayItinerary(int id) async {
    await _api.delete('/api/day-itineraries/delete/$id');
  }

  // Get day itineraries with places
  Future<List<DayItineraryModel>> getDayItinerariesWithPlaces(
      int itineraryId) async {
    final response = await _api
        .get('/api/day-itineraries/itinerary_id/$itineraryId?include=places');
    return (response['data'] as List)
        .map((json) => DayItineraryModel.fromJson(json))
        .toList();
  }
}
