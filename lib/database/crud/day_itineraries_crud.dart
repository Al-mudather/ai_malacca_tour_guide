import 'package:ai_malacca_tour_guide/database/base/database_helper.dart';
import 'package:ai_malacca_tour_guide/models/day_itinerary_model.dart';

class DayItinerariesCRUD {
  final dbHelper = DatabaseHelper.instance;

  // Create
  Future<DayItineraryModel> createDayItinerary(
      DayItineraryModel dayItinerary) async {
    final db = await dbHelper.database;
    final id = await db.insert('day_itineraries', dayItinerary.toMap());
    return dayItinerary.copyWith(id: id);
  }

  // Read
  Future<DayItineraryModel?> getDayItineraryById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'day_itineraries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DayItineraryModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DayItineraryModel>> getDayItinerariesByItineraryId(
      int itineraryId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'day_itineraries',
      where: 'itinerary_id = ?',
      whereArgs: [itineraryId],
      orderBy: 'date ASC',
    );

    return maps.map((map) => DayItineraryModel.fromMap(map)).toList();
  }

  // Update
  Future<int> updateDayItinerary(DayItineraryModel dayItinerary) async {
    final db = await dbHelper.database;
    return db.update(
      'day_itineraries',
      dayItinerary.toMap(),
      where: 'id = ?',
      whereArgs: [dayItinerary.id],
    );
  }

  // Delete
  Future<int> deleteDayItinerary(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'day_itineraries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all day itineraries for an itinerary
  Future<int> deleteItineraryDays(int itineraryId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'day_itineraries',
      where: 'itinerary_id = ?',
      whereArgs: [itineraryId],
    );
  }
}
