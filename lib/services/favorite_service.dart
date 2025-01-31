import '../models/favorite_model.dart';
import 'api_service.dart';

class FavoriteService {
  final ApiService _api;

  FavoriteService({ApiService? api}) : _api = api ?? ApiService();

  // Add a place to favorites
  Future<FavoriteModel> addToFavorites({
    required int userId,
    required int placeId,
  }) async {
    final response = await _api.post('/api/favorites/add', {
      'user_id': userId,
      'place_id': placeId,
    });
    return FavoriteModel.fromJson(response['favorite']);
  }

  // Get all favorites for a user
  Future<List<FavoriteModel>> getUserFavorites(int userId) async {
    final response = await _api.get('/api/favorites/$userId');
    return (response['data'] as List)
        .map((json) => FavoriteModel.fromJson(json))
        .toList();
  }

  // Get a single favorite record
  Future<FavoriteModel> getFavoriteById(int id) async {
    final response = await _api.get('/api/favorites/record/$id');
    return FavoriteModel.fromJson(response);
  }

  // Update a favorite record
  Future<FavoriteModel> updateFavorite({
    required int id,
    required int placeId,
  }) async {
    final response = await _api.put('/api/favorites/update/$id', {
      'place_id': placeId,
    });
    return FavoriteModel.fromJson(response['favorite']);
  }

  // Remove a place from favorites
  Future<void> removeFavorite(int id) async {
    await _api.delete('/api/favorites/remove/$id');
  }

  // Check if a place is favorited by user
  Future<bool> isPlaceFavorited({
    required int userId,
    required int placeId,
  }) async {
    final favorites = await getUserFavorites(userId);
    return favorites.any((favorite) => favorite.placeId == placeId);
  }

  // Toggle favorite status
  Future<bool> toggleFavorite({
    required int userId,
    required int placeId,
  }) async {
    final favorites = await getUserFavorites(userId);
    final existingFavorite = favorites.firstWhere(
      (favorite) => favorite.placeId == placeId,
      orElse: () => FavoriteModel(id: -1, userId: userId, placeId: placeId),
    );

    if (existingFavorite.id == -1) {
      // Not favorited yet, add to favorites
      await addToFavorites(userId: userId, placeId: placeId);
      return true;
    } else {
      // Already favorited, remove from favorites
      await removeFavorite(existingFavorite.id!);
      return false;
    }
  }
}
