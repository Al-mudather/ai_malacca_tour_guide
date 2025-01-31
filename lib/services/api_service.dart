import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env['API_URL'] ?? 'http://localhost:5000',
        defaultHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );
    _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    }

    throw HttpException(
      response.body,
      uri: response.request?.url,
      statusCode: response.statusCode,
    );
  }
}

class HttpException implements Exception {
  final String message;
  final Uri? uri;
  final int statusCode;

  HttpException(this.message, {this.uri, required this.statusCode});

  @override
  String toString() =>
      'HttpException: $statusCode - $message${uri != null ? ' for $uri' : ''}';
}
