import '../base/database_helper.dart';
import '../../models/itinerary_model.dart';

class ItinerariesCRUD {
  final DatabaseHelper dbHelper;

  ItinerariesCRUD({DatabaseHelper? dbHelper})
      : dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Create
  Future<ItineraryModel> createItinerary(ItineraryModel itinerary) async {
    final id = dbHelper.getNewItineraryId();
    final itineraryData = itinerary.toJson()..['id'] = id;
    dbHelper.itineraries[id] = itineraryData;
    return itinerary.copyWith(id: id);
  }

  // Read
  Future<ItineraryModel?> getItineraryById(int id) async {
    final data = dbHelper.itineraries[id];
    return data != null ? ItineraryModel.fromJson(data) : null;
  }

  Future<List<ItineraryModel>> getItinerariesByUserId(int userId) async {
    return dbHelper.itineraries.values
        .where((data) => data['user_id'] == userId)
        .map((data) => ItineraryModel.fromJson(data))
        .toList();
  }

  Future<List<ItineraryModel>> getAllItineraries() async {
    return dbHelper.itineraries.values
        .map((data) => ItineraryModel.fromJson(data))
        .toList();
  }

  // Update
  Future<int> updateItinerary(ItineraryModel itinerary) async {
    if (itinerary.id != null &&
        dbHelper.itineraries.containsKey(itinerary.id)) {
      dbHelper.itineraries[itinerary.id!] = itinerary.toJson();
      return 1;
    }
    return 0;
  }

  // Delete
  Future<int> deleteItinerary(int id) async {
    if (dbHelper.itineraries.containsKey(id)) {
      dbHelper.itineraries.remove(id);
      return 1;
    }
    return 0;
  }

  Future<int> deleteUserItineraries(int userId) async {
    final toRemove = dbHelper.itineraries.entries
        .where((entry) => entry.value['user_id'] == userId)
        .map((e) => e.key)
        .toList();

    for (var id in toRemove) {
      dbHelper.itineraries.remove(id);
    }
    return toRemove.length;
  }
}
