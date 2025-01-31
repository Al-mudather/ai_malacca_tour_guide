import '../models/qna_model.dart';
import 'api_service.dart';

class QnAService {
  final ApiService _api;

  QnAService({ApiService? api}) : _api = api ?? ApiService();

  // Create a new QnA
  Future<QnAModel> createQnA({
    required String question,
    required String answer,
    required int placeId,
  }) async {
    final response = await _api.post('/api/qna/create', {
      'question': question,
      'answer': answer,
      'place_id': placeId,
    });
    return QnAModel.fromJson(response);
  }

  // Get all QnAs
  Future<List<QnAModel>> getAllQnAs() async {
    final response = await _api.get('/api/qna');
    return (response['data'] as List)
        .map((json) => QnAModel.fromJson(json))
        .toList();
  }

  // Get QnA by ID
  Future<QnAModel> getQnAById(int id) async {
    final response = await _api.get('/api/qna/$id');
    return QnAModel.fromJson(response);
  }

  // Update QnA
  Future<QnAModel> updateQnA({
    required int id,
    String? question,
    String? answer,
    int? placeId,
  }) async {
    final Map<String, dynamic> data = {
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (placeId != null) 'place_id': placeId,
    };

    final response = await _api.put('/api/qna/update/$id', data);
    return QnAModel.fromJson(response);
  }

  // Delete QnA
  Future<void> deleteQnA(int id) async {
    await _api.delete('/api/qna/delete/$id');
  }

  // Get QnAs by place
  Future<List<QnAModel>> getQnAsByPlace(int placeId) async {
    final response = await _api.get('/api/qna?place_id=$placeId');
    return (response['data'] as List)
        .map((json) => QnAModel.fromJson(json))
        .toList();
  }

  // Search QnAs
  Future<List<QnAModel>> searchQnAs(String query) async {
    final response = await _api.get('/api/qna/search?q=$query');
    return (response['data'] as List)
        .map((json) => QnAModel.fromJson(json))
        .toList();
  }
}
