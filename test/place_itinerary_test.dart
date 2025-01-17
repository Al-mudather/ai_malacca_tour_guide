import 'package:flutter_test/flutter_test.dart';
import 'package:ai_malacca_tour_guide/models/place_itinerary_model.dart';
import 'package:ai_malacca_tour_guide/database/crud/place_itineraries_crud.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';
import 'place_itinerary_test.mocks.dart';

@GenerateMocks([PlaceItinerariesCRUD])
void main() {
  group('Place Itinerary Tests', () {
    late PlaceItinerariesCRUD mockCRUD;

    setUp(() {
      mockCRUD = MockPlaceItinerariesCRUD();
    });

    test('Add place to day itinerary', () async {
      // Arrange
      final placeDetails = json.encode({
        'description': 'A test place',
        'entranceFee': '10',
        'duration': '2 hours',
      });
      final openingHours = json.encode({'default': '09:00-17:00'});
      final location = json.encode({'latitude': 0.0, 'longitude': 0.0});

      final placeItinerary = PlaceItineraryModel(
        dayItineraryId: 1,
        placeName: 'Test Place',
        placeType: 'attraction',
        cost: 100,
        time: '09:00',
        notes: 'Test notes',
        address: 'Test address',
        rating: 4.5,
        imageUrl: 'http://example.com/image.jpg',
        placeDetails: placeDetails,
        openingHours: openingHours,
        location: location,
      );

      // Act
      when(mockCRUD.createPlaceItinerary(placeItinerary))
          .thenAnswer((_) async => placeItinerary);
      final result = await mockCRUD.createPlaceItinerary(placeItinerary);

      // Assert
      verify(mockCRUD.createPlaceItinerary(placeItinerary)).called(1);

      // Test basic fields
      expect(result.dayItineraryId, equals(1));
      expect(result.placeName, equals('Test Place'));

      // Test JSON string fields
      expect(result.placeDetails, equals(placeDetails));
      expect(result.openingHours, equals(openingHours));
      expect(result.location, equals(location));

      // Test decoded maps
      expect(result.placeDetailsMap['description'], equals('A test place'));
      expect(result.openingHoursMap['default'], equals('09:00-17:00'));
      expect(result.locationMap['latitude'], equals(0.0));

      // Test helper getters
      expect(result.latitude, equals(0.0));
      expect(result.longitude, equals(0.0));
    });

    test('PlaceItineraryModel handles empty JSON strings', () {
      final model = PlaceItineraryModel(
        dayItineraryId: 1,
        placeName: 'Test',
        placeType: 'attraction',
        cost: 0,
        time: '09:00',
      );

      expect(model.placeDetailsMap, equals({}));
      expect(model.openingHoursMap, equals({}));
      expect(model.locationMap, equals({'latitude': 0.0, 'longitude': 0.0}));
    });
  });
}
