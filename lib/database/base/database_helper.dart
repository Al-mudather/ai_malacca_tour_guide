import 'dart:async';

// Mock data storage using in-memory maps
class DatabaseHelper {
  // Singleton pattern
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  // In-memory storage
  static final Map<String, dynamic> _users = {};
  static final Map<int, Map<String, dynamic>> _itineraries = {};
  static final Map<int, Map<String, dynamic>> _dayItineraries = {};
  static final Map<int, Map<String, dynamic>> _placeItineraries = {};

  // Counter for generating IDs
  static int _userCounter = 1;
  static int _itineraryCounter = 1;
  static int _dayItineraryCounter = 1;
  static int _placeItineraryCounter = 1;

  DatabaseHelper();

  // Initialize with mock data
  Future<void> initializeMockData() async {
    // Add default admin user if not exists
    if (!_users.containsKey('a@a.com')) {
      _users['a@a.com'] = {
        'id': _userCounter++,
        'email': 'a@a.com',
        'password': 'a',
        'name': 'Admin',
        'default_budget': 1000,
        'preferences': '{}'
      };
    }
  }

  // Helper methods to access mock data
  Map<String, dynamic> get users => _users;
  Map<int, Map<String, dynamic>> get itineraries => _itineraries;
  Map<int, Map<String, dynamic>> get dayItineraries => _dayItineraries;
  Map<int, Map<String, dynamic>> get placeItineraries => _placeItineraries;

  // Method to clear all mock data
  Future<void> clearTables() async {
    _users.clear();
    _itineraries.clear();
    _dayItineraries.clear();
    _placeItineraries.clear();
    await initializeMockData();
  }

  // Method to "delete" the mock database
  Future<void> deleteDatabase() async {
    await clearTables();
  }

  // Generate new IDs for each table
  int getNewUserId() => _userCounter++;
  int getNewItineraryId() => _itineraryCounter++;
  int getNewDayItineraryId() => _dayItineraryCounter++;
  int getNewPlaceItineraryId() => _placeItineraryCounter++;

  // No need to close anything since we're using in-memory storage
  Future<void> close() async {}
}
