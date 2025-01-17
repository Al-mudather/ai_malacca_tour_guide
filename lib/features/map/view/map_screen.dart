import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/route_service.dart';

class MapScreen extends StatefulWidget {
  final double destinationLatitude;
  final double destinationLongitude;

  const MapScreen({
    super.key,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  static const double _defaultZoom = 14.0;
  Position? _currentPosition;
  List<LatLng>? _routePoints;
  bool _isLoadingRoute = false;
  bool _isStraightLine = false;
  double? _distance;
  double? _duration;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _errorMessage = null;
    });

    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage =
              'Location services are disabled. Please enable them in your device settings.';
        });
        return;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage =
                'Location permissions are denied. Please enable them to use navigation.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied. Please enable them in your device settings.';
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _errorMessage = null;
      });

      // Get route after getting location
      await _getRoute();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
      });
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _getRoute() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoadingRoute = true;
      _errorMessage = null;
    });

    try {
      final routeDetails = await RouteService.getRouteDetails(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(widget.destinationLatitude, widget.destinationLongitude),
      );

      setState(() {
        _routePoints = routeDetails['coordinates'] as List<LatLng>;
        _distance = routeDetails['distance'] as double;
        _duration = routeDetails['duration'] as double;
        _isStraightLine = routeDetails['isStraightLine'] as bool? ?? false;
        _isLoadingRoute = false;
        _errorMessage = null;
      });

      // Adjust map to show both points
      if (_routePoints != null && _routePoints!.isNotEmpty) {
        final center = LatLng(
          (_currentPosition!.latitude + widget.destinationLatitude) / 2,
          (_currentPosition!.longitude + widget.destinationLongitude) / 2,
        );
        _mapController.move(center, 12);
      }
    } catch (e) {
      setState(() {
        _isLoadingRoute = false;
        _errorMessage =
            'Could not find a route to the destination. Please try again.';
      });
      debugPrint('Error getting route: $e');
    }
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    } else {
      return '${meters.toStringAsFixed(0)} m';
    }
  }

  String _formatDuration(double seconds) {
    final Duration duration = Duration(seconds: seconds.round());
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}min';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}min';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final destination =
        LatLng(widget.destinationLatitude, widget.destinationLongitude);
    final currentLocation = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
            tooltip: 'Refresh route',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: destination,
              initialZoom: _defaultZoom,
              minZoom: 3,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ai_malacca_tour_guide',
              ),
              if (_routePoints != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints!,
                      color: _isStraightLine ? Colors.red : Colors.blue,
                      strokeWidth: _isStraightLine ? 2.0 : 4.0,
                    ),
                  ],
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
                  if (currentLocation != null)
                    Marker(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      point: currentLocation,
                      width: 40,
                      height: 40,
                    ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          if (_isLoadingRoute)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (_isStraightLine && _routePoints != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing approximate direct route. Actual walking/driving route may vary significantly.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_distance != null && _duration != null)
            Positioned(
              top: _isStraightLine ? 80 : 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(_isStraightLine
                              ? Icons.straight_outlined
                              : Icons.directions_walk),
                          const SizedBox(height: 4),
                          Text(_formatDistance(_distance!)),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(height: 4),
                          Text(_formatDuration(_duration!)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  onPressed: () {
                    final newZoom = _mapController.camera.zoom + 1;
                    _mapController.move(
                      _mapController.camera.center,
                      newZoom.clamp(3, 18),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  onPressed: () {
                    final newZoom = _mapController.camera.zoom - 1;
                    _mapController.move(
                      _mapController.camera.center,
                      newZoom.clamp(3, 18),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'myLocation',
                  mini: true,
                  onPressed: () async {
                    await _getCurrentLocation();
                    if (_currentPosition != null) {
                      _mapController.move(
                        LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        _defaultZoom,
                      );
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'centerLocation',
                  onPressed: () {
                    _mapController.move(destination, _defaultZoom);
                  },
                  child: const Icon(Icons.center_focus_strong),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
