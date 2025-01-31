import '../base/database_helper.dart';
import '../../models/user_model.dart';

class UsersCRUD {
  final DatabaseHelper dbHelper;

  UsersCRUD({DatabaseHelper? dbHelper})
      : dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Create
  Future<UserModel> createUser(UserModel user) async {
    final id = dbHelper.getNewUserId();
    final userData = user.toMap()..['id'] = id;
    dbHelper.users[user.email] = userData;
    return UserModel.fromMap(userData);
  }

  // Read
  Future<List<UserModel>> getAllUsers() async {
    return dbHelper.users.values
        .map((userData) => UserModel.fromMap(userData))
        .toList();
  }

  Future<UserModel?> getUserById(int id) async {
    final user = dbHelper.users.values
        .firstWhere((user) => user['id'] == id, orElse: () => {});
    return user.isNotEmpty ? UserModel.fromMap(user) : null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final userData = dbHelper.users[email];
    return userData != null ? UserModel.fromMap(userData) : null;
  }

  Future<UserModel?> authenticateUser(String email, String password) async {
    final userData = dbHelper.users[email];
    if (userData != null && userData['password'] == password) {
      return UserModel.fromMap(userData);
    }
    return null;
  }

  Future<bool> isEmailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Update
  Future<int> updateUser(UserModel user) async {
    if (dbHelper.users.containsKey(user.email)) {
      dbHelper.users[user.email] = user.toMap();
      return 1;
    }
    return 0;
  }

  // Delete
  Future<int> deleteUser(int id) async {
    final entry = dbHelper.users.entries.firstWhere(
      (entry) => entry.value['id'] == id,
      orElse: () => MapEntry('', {}),
    );
    if (entry.value.isNotEmpty) {
      dbHelper.users.remove(entry.key);
      return 1;
    }
    return 0;
  }
}
