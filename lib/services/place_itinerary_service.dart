import '../models/place_itinerary_model.dart';
import 'api_service.dart';

class PlaceItineraryService {
  final ApiService _api;

  PlaceItineraryService({ApiService? api}) : _api = api ?? ApiService();

  // Create a new place itinerary
  Future<PlaceItineraryModel> createPlaceItinerary({
    required int order,
    required int dayId,
    required int placeId,
    required String time,
  }) async {
    final response = await _api.post('/api/place-itineraries/create', {
      'order': order,
      'day_id': dayId,
      'place_id': placeId,
      'time': time,
    });
    return PlaceItineraryModel.fromJson(response);
  }

  // Get all place itineraries for a day
  Future<List<PlaceItineraryModel>> getPlaceItineraries(int dayId) async {
    final response = await _api.get('/api/place-itineraries?day_id=$dayId');
    return (response['data'] as List)
        .map((json) => PlaceItineraryModel.fromJson(json))
        .toList();
  }

  // Get place itinerary by ID
  Future<PlaceItineraryModel> getPlaceItineraryById(int id) async {
    final response = await _api.get('/api/place-itineraries/$id');
    return PlaceItineraryModel.fromJson(response);
  }

  // Update place itinerary
  Future<PlaceItineraryModel> updatePlaceItinerary({
    required int id,
    int? order,
    String? time,
  }) async {
    final Map<String, dynamic> data = {
      if (order != null) 'order': order,
      if (time != null) 'time': time,
    };

    final response = await _api.put('/api/place-itineraries/update/$id', data);
    return PlaceItineraryModel.fromJson(response);
  }

  // Delete place itinerary
  Future<void> deletePlaceItinerary(int id) async {
    await _api.delete('/api/place-itineraries/delete/$id');
  }

  // Get place itineraries with place details
  Future<List<PlaceItineraryModel>> getPlaceItinerariesWithDetails(
      int dayId) async {
    final response =
        await _api.get('/api/place-itineraries?day_id=$dayId&include=place');
    return (response['data'] as List)
        .map((json) => PlaceItineraryModel.fromJson(json))
        .toList();
  }

  // Reorder places in a day
  Future<List<PlaceItineraryModel>> reorderPlaces({
    required int dayId,
    required List<Map<String, dynamic>> newOrder,
  }) async {
    final response = await _api.put('/api/place-itineraries/reorder', {
      'day_id': dayId,
      'places': newOrder,
    });

    return (response['data'] as List)
        .map((json) => PlaceItineraryModel.fromJson(json))
        .toList();
  }
}
