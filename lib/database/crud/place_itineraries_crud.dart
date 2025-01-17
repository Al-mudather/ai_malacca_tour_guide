import 'package:ai_malacca_tour_guide/database/base/database_helper.dart';
import 'package:ai_malacca_tour_guide/models/place_itinerary_model.dart';

class PlaceItinerariesCRUD {
  final dbHelper = DatabaseHelper.instance;

  // Create
  Future<PlaceItineraryModel> createPlaceItinerary(
    PlaceItineraryModel placeItinerary,
  ) async {
    final db = await dbHelper.database;
    final id = await db.insert('place_itineraries', placeItinerary.toMap());
    return placeItinerary.copyWith(id: id);
  }

  // Read
  Future<PlaceItineraryModel?> getPlaceItineraryById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'place_itineraries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PlaceItineraryModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<PlaceItineraryModel>> getPlaceItinerariesByDayId(
      int dayItineraryId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'place_itineraries',
      where: 'day_itinerary_id = ?',
      whereArgs: [dayItineraryId],
      orderBy: 'time ASC',
    );

    return maps.map((map) => PlaceItineraryModel.fromMap(map)).toList();
  }

  // Update
  Future<int> updatePlaceItinerary(PlaceItineraryModel placeItinerary) async {
    final db = await dbHelper.database;
    return db.update(
      'place_itineraries',
      placeItinerary.toMap(),
      where: 'id = ?',
      whereArgs: [placeItinerary.id],
    );
  }

  // Delete
  Future<int> deletePlaceItinerary(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'place_itineraries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all place itineraries for a day
  Future<int> deleteDayPlaces(int dayItineraryId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'place_itineraries',
      where: 'day_itinerary_id = ?',
      whereArgs: [dayItineraryId],
    );
  }

  // Get total cost for a day
  Future<int> getDayTotalCost(int dayItineraryId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(cost) as total_cost
      FROM place_itineraries
      WHERE day_itinerary_id = ?
    ''', [dayItineraryId]);

    return (result.first['total_cost'] as int?) ?? 0;
  }
}
