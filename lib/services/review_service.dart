import '../models/review_model.dart';
import 'api_service.dart';

class ReviewService {
  final ApiService _api;

  ReviewService({ApiService? api}) : _api = api ?? ApiService();

  // Create a new review
  Future<ReviewModel> createReview({
    required double rating,
    required String comment,
    required int placeId,
    required int userId,
  }) async {
    final response = await _api.post('/api/reviews/create', {
      'rating': rating,
      'comment': comment,
      'place_id': placeId,
      'user_id': userId,
    });
    return ReviewModel.fromJson(response);
  }

  // Get all reviews
  Future<List<ReviewModel>> getAllReviews() async {
    final response = await _api.get('/api/reviews');
    return (response['data'] as List)
        .map((json) => ReviewModel.fromJson(json))
        .toList();
  }

  // Get review by ID
  Future<ReviewModel> getReviewById(int id) async {
    final response = await _api.get('/api/reviews/$id');
    return ReviewModel.fromJson(response);
  }

  // Get reviews by place
  Future<List<ReviewModel>> getReviewsByPlace(int placeId) async {
    final response = await _api.get('/api/reviews/place/$placeId');
    return (response['data'] as List)
        .map((json) => ReviewModel.fromJson(json))
        .toList();
  }

  // Get reviews by user
  Future<List<ReviewModel>> getReviewsByUser(int userId) async {
    final response = await _api.get('/api/reviews/user/$userId');
    return (response['data'] as List)
        .map((json) => ReviewModel.fromJson(json))
        .toList();
  }

  // Update review
  Future<ReviewModel> updateReview({
    required int id,
    double? rating,
    String? comment,
  }) async {
    final Map<String, dynamic> data = {
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
    };

    final response = await _api.put('/api/reviews/update/$id', data);
    return ReviewModel.fromJson(response);
  }

  // Delete review
  Future<void> deleteReview(int id) async {
    await _api.delete('/api/reviews/delete/$id');
  }

  // Get average rating for a place
  Future<double> getPlaceAverageRating(int placeId) async {
    final reviews = await getReviewsByPlace(placeId);
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );
    return totalRating / reviews.length;
  }

  // Check if user has reviewed a place
  Future<bool> hasUserReviewedPlace({
    required int userId,
    required int placeId,
  }) async {
    final userReviews = await getReviewsByUser(userId);
    return userReviews.any((review) => review.placeId == placeId);
  }
}
