import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;
  final url = "http://localhost:5000";

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ??
            dotenv.env['API_URL'] ??
            'http://localhost:5000', // Using 10.0.2.2 for Android emulator
        // 'http://10.0.2.2:5000', // Using 10.0.2.2 for Android emulator
        _dio = Dio() {
    _dio.options.baseUrl = this.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add logging interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        print('Response: ${error.response}');
        return handler.next(error);
      },
    ));
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(url + endpoint);
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is List) {
        return {'data': response.data};
      } else {
        throw FormatException(
            'Unexpected response format: ${response.data.runtimeType}');
      }
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url + endpoint, data: data);
      return response.data;
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadFile(
      String endpoint, String filePath, Map<String, dynamic> fields,
      {bool isUpdating = false}) async {
    try {
      final formData = FormData.fromMap({
        ...fields,
        'image': await MultipartFile.fromFile(filePath),
      });

      final response = isUpdating
          ? await _dio.put(url + endpoint, data: formData)
          : await _dio.post(url + endpoint, data: formData);
      return response.data;
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(url + endpoint, data: data);
      return response.data;
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      await _dio.delete(url + endpoint);
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioError e) {
    if (e.response != null) {
      throw HttpException(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        uri: Uri.parse(e.requestOptions.path),
        statusCode: e.response?.statusCode ?? 500,
      );
    } else {
      throw HttpException(
        e.message ?? 'Network error',
        uri: Uri.parse(e.requestOptions.path),
        statusCode: 500,
      );
    }
  }

  // Update token for authenticated requests
  void updateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
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
