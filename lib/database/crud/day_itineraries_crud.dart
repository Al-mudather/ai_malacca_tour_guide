import '../base/database_helper.dart';
import '../../models/day_itinerary_model.dart';

class DayItinerariesCRUD {
  final DatabaseHelper dbHelper;

  DayItinerariesCRUD({DatabaseHelper? dbHelper})
      : dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Create
  Future<DayItineraryModel> createDayItinerary(
      DayItineraryModel dayItinerary) async {
    final id = dbHelper.getNewDayItineraryId();
    final dayData = dayItinerary.toMap()..['id'] = id;
    dbHelper.dayItineraries[id] = dayData;
    return dayItinerary.copyWith(id: id);
  }

  // Read
  Future<DayItineraryModel?> getDayItineraryById(int id) async {
    final data = dbHelper.dayItineraries[id];
    return data != null ? DayItineraryModel.fromMap(data) : null;
  }

  Future<List<DayItineraryModel>> getDayItinerariesByItineraryId(
      int itineraryId) async {
    return dbHelper.dayItineraries.values
        .where((data) => data['itinerary_id'] == itineraryId)
        .map((data) => DayItineraryModel.fromMap(data))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Update
  Future<int> updateDayItinerary(DayItineraryModel dayItinerary) async {
    if (dayItinerary.id != null &&
        dbHelper.dayItineraries.containsKey(dayItinerary.id)) {
      dbHelper.dayItineraries[dayItinerary.id!] = dayItinerary.toMap();
      return 1;
    }
    return 0;
  }

  // Delete
  Future<int> deleteDayItinerary(int id) async {
    if (dbHelper.dayItineraries.containsKey(id)) {
      dbHelper.dayItineraries.remove(id);
      return 1;
    }
    return 0;
  }

  Future<int> deleteItineraryDays(int itineraryId) async {
    final toRemove = dbHelper.dayItineraries.entries
        .where((entry) => entry.value['itinerary_id'] == itineraryId)
        .map((e) => e.key)
        .toList();

    for (final id in toRemove) {
      dbHelper.dayItineraries.remove(id);
    }
    return toRemove.length;
  }
}
