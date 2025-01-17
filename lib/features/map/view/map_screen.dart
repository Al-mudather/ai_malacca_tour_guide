import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final double destinationLatitude;
  final double destinationLongitude;

  const MapScreen({
    super.key,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  @override
  Widget build(BuildContext context) {
    final destination = LatLng(destinationLatitude, destinationLongitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: destination,
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.ai_malacca_tour_guide',
          ),
          MarkerLayer(
            markers: [
              Marker(
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
                point: destination,
                width: 40,
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
