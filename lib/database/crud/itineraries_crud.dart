import 'package:ai_malacca_tour_guide/database/base/database_helper.dart';
import 'package:ai_malacca_tour_guide/models/itinerary_model.dart';

class ItinerariesCRUD {
  final dbHelper = DatabaseHelper.instance;

  // Create
  Future<ItineraryModel> createItinerary(ItineraryModel itinerary) async {
    final db = await dbHelper.database;
    final id = await db.insert('itineraries', itinerary.toMap());
    return itinerary.copyWith(id: id);
  }

  // Read
  Future<ItineraryModel?> getItineraryById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'itineraries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItineraryModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ItineraryModel>> getItinerariesByUserId(int userId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'itineraries',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return maps.map((map) => ItineraryModel.fromMap(map)).toList();
  }

  Future<List<ItineraryModel>> getAllItineraries() async {
    final db = await dbHelper.database;
    final maps = await db.query('itineraries');
    return maps.map((map) => ItineraryModel.fromMap(map)).toList();
  }

  // Update
  Future<int> updateItinerary(ItineraryModel itinerary) async {
    final db = await dbHelper.database;
    return db.update(
      'itineraries',
      itinerary.toMap(),
      where: 'id = ?',
      whereArgs: [itinerary.id],
    );
  }

  // Delete
  Future<int> deleteItinerary(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'itineraries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all itineraries for a user
  Future<int> deleteUserItineraries(int userId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'itineraries',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
