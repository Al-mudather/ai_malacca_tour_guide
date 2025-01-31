import '../base/database_helper.dart';
import '../../models/place_itinerary_model.dart';

class PlaceItinerariesCRUD {
  final DatabaseHelper dbHelper;

  PlaceItinerariesCRUD({DatabaseHelper? dbHelper})
      : dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Create
  Future<PlaceItineraryModel> createPlaceItinerary(
      PlaceItineraryModel placeItinerary) async {
    // Check for uniqueness by place name in the day
    final existingPlace = dbHelper.placeItineraries.values.firstWhere(
      (place) =>
          place['day_itinerary_id'] == placeItinerary.dayId &&
          place['place_name'] == placeItinerary.place,
      orElse: () => {},
    );

    if (existingPlace.isNotEmpty) {
      throw Exception('Place already exists in this day itinerary');
    }

    final id = dbHelper.getNewPlaceItineraryId();
    final placeData = placeItinerary.toJson()..['id'] = id;
    dbHelper.placeItineraries[id] = placeData;
    return placeItinerary.copyWith(id: id);
  }

  // Read
  Future<PlaceItineraryModel?> getPlaceItineraryById(int id) async {
    final data = dbHelper.placeItineraries[id];
    return data != null ? PlaceItineraryModel.fromJson(data) : null;
  }

  Future<List<PlaceItineraryModel>> getPlaceItinerariesByDayId(
      int dayItineraryId) async {
    return dbHelper.placeItineraries.values
        .where((data) => data['day_itinerary_id'] == dayItineraryId)
        .map((data) => PlaceItineraryModel.fromJson(data))
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  // Update
  Future<int> updatePlaceItinerary(PlaceItineraryModel placeItinerary) async {
    if (placeItinerary.id != null &&
        dbHelper.placeItineraries.containsKey(placeItinerary.id)) {
      dbHelper.placeItineraries[placeItinerary.id!] = placeItinerary.toJson();
      return 1;
    }
    return 0;
  }

  // Delete
  Future<int> deletePlaceItinerary(int id) async {
    if (dbHelper.placeItineraries.containsKey(id)) {
      dbHelper.placeItineraries.remove(id);
      return 1;
    }
    return 0;
  }

  Future<int> deleteDayPlaces(int dayItineraryId) async {
    final toRemove = dbHelper.placeItineraries.entries
        .where((entry) => entry.value['day_itinerary_id'] == dayItineraryId)
        .map((e) => e.key)
        .toList();

    for (var id in toRemove) {
      dbHelper.placeItineraries.remove(id);
    }
    return toRemove.length;
  }

  Future<int> getDayTotalCost(int dayItineraryId) async {
    return dbHelper.placeItineraries.values
        .where((data) => data['day_itinerary_id'] == dayItineraryId)
        .fold<int>(0, (sum, place) => sum + (place['cost'] as int? ?? 0));
  }
}
