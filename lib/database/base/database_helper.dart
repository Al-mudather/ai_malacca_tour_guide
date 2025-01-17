import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  DatabaseHelper();

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String dbName = 'malacca_guide.db';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Create the directory if it doesn't exist
    try {
      await Directory(dbPath).create(recursive: true);
    } catch (error) {}

    // Open or create the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Handle future database upgrades here
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const realType = 'REAL';

    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id $idType,
        email $textType UNIQUE NOT NULL,
        password $textType NOT NULL,
        name $textType,
        default_budget $intType,
        preferences $textType
      )
    ''');

    // Create itineraries table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS itineraries (
        id $idType,
        user_id $intType,
        title $textType,
        start_date $textType,
        end_date $textType,
        total_budget $intType,
        preferences $textType,
        status $textType DEFAULT 'draft',
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Create day_itineraries table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS day_itineraries (
        id $idType,
        itinerary_id $intType,
        date $textType,
        total_cost $intType,
        status $textType DEFAULT 'planned',
        weather_info $textType DEFAULT '{}',
        FOREIGN KEY (itinerary_id) REFERENCES itineraries (id)
      )
    ''');

    // Create place_itineraries table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS place_itineraries (
        id $idType,
        day_itinerary_id $intType,
        place_name $textType,
        place_type $textType,
        cost $intType,
        time $textType,
        notes $textType,
        address $textType,
        rating $realType,
        image_url $textType,
        place_details $textType DEFAULT '{}',
        opening_hours $textType DEFAULT '{}',
        duration $textType DEFAULT '{}',
        location $textType DEFAULT '{}',
        FOREIGN KEY (day_itinerary_id) REFERENCES day_itineraries (id)
        UNIQUE(day_itinerary_id, place_name)
      )
    ''');

    // Create default admin user if not exists
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: ['a@a.com'],
    );

    if (users.isEmpty) {
      await db.insert('users', {
        'email': 'a@a.com',
        'password': 'a',
        'name': 'Admin',
        'default_budget': 1000,
        'preferences': '{}'
      });
    }
  }

  Future<void> dropAndRestorePlaceItineraries() async {
    final db = await database;
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const realType = 'REAL';

    // Begin transaction
    await db.transaction((txn) async {
      try {
        // 1. Backup existing data
        final List<Map<String, dynamic>> existingData =
            await txn.query('place_itineraries');

        // 2. Drop the existing table
        await txn.execute('DROP TABLE IF EXISTS place_itineraries');

        // 3. Create the new table with updated schema
        await txn.execute('''
          CREATE TABLE IF NOT EXISTS place_itineraries (
            id $idType,
            day_itinerary_id $intType,
            place_name $textType,
            place_type $textType,
            cost $intType,
            time $textType,
            notes $textType,
            address $textType,
            rating $realType,
            image_url $textType,
            place_details $textType DEFAULT '{}',
            opening_hours $textType DEFAULT '{}',
            duration $textType DEFAULT '{}',
            location $textType DEFAULT '{}',
            FOREIGN KEY (day_itinerary_id) REFERENCES day_itineraries (id),
            UNIQUE(day_itinerary_id, place_name)
          )
        ''');

        // 4. Restore the data
        for (var record in existingData) {
          await txn.insert(
            'place_itineraries',
            record,
            conflictAlgorithm: ConflictAlgorithm.ignore, // Skip duplicates
          );
        }

        print(
            'Successfully recreated place_itineraries table with unique constraint');
      } catch (e) {
        print('Error during table recreation: $e');
        rethrow;
      }
    });
  }

  // Call this method when initializing your app
  Future<void> performMigration() async {
    try {
      await dropAndRestorePlaceItineraries();
    } catch (e) {
      print('Migration failed: $e');
      rethrow;
    }
  }

  // Method to delete the entire database
  Future<void> deleteDatabase() async {
    try {
      // Get the database path
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, dbName);

      // Close the database connection if it's open
      final db = await database;
      await db.close();

      // Delete the database file
      await databaseFactory.deleteDatabase(path);

      print('Database deleted successfully');
    } catch (e) {
      print('Error deleting database: $e');
      rethrow;
    }
  }

  // Method to clear specific tables without deleting the database
  Future<void> clearTables() async {
    final db = await database;

    await db.transaction((txn) async {
      try {
        // Delete data from tables in correct order (respecting foreign keys)
        await txn.execute('DELETE FROM place_itineraries');
        await txn.execute('DELETE FROM day_itineraries');
        await txn.execute('DELETE FROM itineraries');
        // Add other tables as needed

        // Drop and restor the tables
        await performMigration();

        print('All tables cleared successfully');
      } catch (e) {
        print('Error clearing tables: $e');
        rethrow;
      }
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
