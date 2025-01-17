import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class RouteService {
  static const String _baseUrl = 'https://router.project-osrm.org/route/v1/';

  static Future<List<LatLng>> getRoutePoints(
    LatLng start,
    LatLng destination, {
    String profile = 'walking', // or 'driving'
  }) async {
    final url = Uri.parse(
      '$_baseUrl$profile/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates =
            data['routes'][0]['geometry']['coordinates'] as List;

        return coordinates.map((coord) {
          final list = coord as List;
          return LatLng(list[1] as double, list[0] as double);
        }).toList();
      } else {
        throw Exception('Failed to get route');
      }
    } catch (e) {
      throw Exception('Failed to get route: $e');
    }
  }

  static Future<Map<String, dynamic>> getRouteDetails(
    LatLng start,
    LatLng destination, {
    String profile = 'walking', // or 'driving'
  }) async {
    final url = Uri.parse(
      '$_baseUrl$profile/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );

    try {
      debugPrint('Fetching route from: $url');
      final response = await http.get(url);
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final coordinates = route['geometry']['coordinates'] as List;

          return {
            'distance': route['distance'] as double,
            'duration': route['duration'] as double,
            'coordinates': coordinates.map((coord) {
              final list = coord as List;
              return LatLng(list[1] as double, list[0] as double);
            }).toList(),
          };
        }
      }

      // If route not found or any error occurs, return straight line
      debugPrint('Using straight line fallback');
      final straightLineDistance = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        destination.latitude,
        destination.longitude,
      );

      // Estimate duration based on average walking speed (5 km/h)
      final estimatedDuration =
          (straightLineDistance / 1.4) as double; // meters per second

      return {
        'distance': straightLineDistance,
        'duration': estimatedDuration,
        'coordinates': [start, destination],
        'isStraightLine': true,
      };
    } catch (e) {
      debugPrint('Error in getRouteDetails: $e');

      // Return straight line in case of any error
      final straightLineDistance = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        destination.latitude,
        destination.longitude,
      );

      final estimatedDuration = (straightLineDistance / 1.4) as double;

      return {
        'distance': straightLineDistance,
        'duration': estimatedDuration,
        'coordinates': [start, destination],
        'isStraightLine': true,
      };
    }
  }
}
