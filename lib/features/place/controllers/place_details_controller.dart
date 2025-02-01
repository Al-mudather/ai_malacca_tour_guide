import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:ai_malacca_tour_guide/models/itinerary_model.dart';
import 'package:ai_malacca_tour_guide/services/itinerary_service.dart';
import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:ai_malacca_tour_guide/services/place_itinerary_service.dart';
import 'package:ai_malacca_tour_guide/services/day_itinerary_service.dart';
import 'package:ai_malacca_tour_guide/features/place/widgets/create_itinerary_dialog.dart';

class PlaceDetailsController extends GetxController {
  final _itineraryService = Get.find<ItineraryService>();
  final _placeItineraryService = Get.find<PlaceItineraryService>();
  final _dayItineraryService = Get.find<DayItineraryService>();

  final Rx<List<ItineraryModel>> _itineraries = Rx<List<ItineraryModel>>([]);
  List<ItineraryModel> get itineraries => _itineraries.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    try {
      _isLoading.value = true;
      final userItineraries = await _itineraryService.getUserItineraries(
          Get.find<AuthController>().currentUser.value!.id!);
      _itineraries.value = userItineraries;
    } catch (e) {
      print('Error loading itineraries: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addToItinerary(Place place) async {
    if (itineraries.isEmpty) {
      // If no itinerary exists, show dialog to create new one
      await _showCreateItineraryDialog(place);
    } else {
      // If itineraries exist, show dialog to select one or create new
      await _showSelectItineraryDialog(place);
    }
  }

  Future<void> _showCreateItineraryDialog(Place place) async {
    await Get.dialog<void>(
      CreateItineraryDialog(
        onSubmit: (name) async {
          try {
            _isLoading.value = true;

            if (name.trim().isEmpty) {
              throw Exception('Itinerary name cannot be empty');
            }

            final currentUser = Get.find<AuthController>().currentUser.value;
            if (currentUser?.id == null) {
              throw Exception('User not logged in');
            }

            // Create new itinerary
            final newItinerary = await _itineraryService.createItinerary(
              name: name.trim(),
              description: 'Created from place details',
              userId: currentUser!.id!,
              title: name.trim(),
              startDate: DateTime.now().toIso8601String(),
              endDate:
                  DateTime.now().add(const Duration(days: 1)).toIso8601String(),
              totalBudget: 0,
              preferences: {},
            );

            if (newItinerary.id == null) {
              throw Exception(
                  'Failed to create itinerary: Invalid response from server');
            }

            // Create first day
            final day = await _dayItineraryService.createDayItinerary(
              dayNumber: 1,
              itineraryId: newItinerary.id!,
            );

            if (day.id == null) {
              throw Exception(
                  'Failed to create day: Invalid response from server');
            }

            if (place.id == null) {
              throw Exception('Invalid place ID');
            }

            // Add place to the first day
            await _placeItineraryService.createPlaceItinerary(
              order: 1,
              dayId: day.id!,
              placeId: place.id!,
              time: '10:00',
            );

            await _loadItineraries(); // Reload itineraries
            Get.snackbar(
              'Success',
              'Place added to new itinerary',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            print('----------  Error Details --------------------------');
            print('Error creating itinerary: $e');
            print('Stack trace: ${StackTrace.current}');
            print('------------------------------------------------');

            String errorMessage = 'Failed to create itinerary';
            if (e.toString().contains('User not logged in')) {
              errorMessage = 'Please log in to create an itinerary';
            } else if (e.toString().contains('name cannot be empty')) {
              errorMessage = 'Please enter an itinerary name';
            } else if (e.toString().contains(
                'type \'Null\' is not a subtype of type \'String\'')) {
              errorMessage = 'Server error: Invalid response format';
            }

            Get.snackbar(
              'Error',
              errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          } finally {
            _isLoading.value = false;
          }
        },
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showSelectItineraryDialog(Place place) async {
    final selectedItinerary = await Get.dialog<ItineraryModel>(
      AlertDialog(
        title: const Text('Select Itinerary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...itineraries.map(
              (itinerary) => ListTile(
                title: Text(itinerary.name),
                subtitle: Text('${itinerary.days.length} days'),
                onTap: () => Get.back(result: itinerary),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create New Itinerary'),
              onTap: () => Get.back(result: null),
            ),
          ],
        ),
      ),
    );

    if (selectedItinerary == null) {
      // User chose to create new itinerary
      await _showCreateItineraryDialog(place);
    } else {
      // Show day selection dialog
      await _showDaySelectionDialog(selectedItinerary, place);
    }
  }

  Future<void> _showDaySelectionDialog(
      ItineraryModel itinerary, Place place) async {
    final result = await Get.dialog<Map<String, dynamic>>(
      AlertDialog(
        title: const Text('Select Day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              itinerary.days.length,
              (index) => ListTile(
                title: Text('Day ${index + 1}'),
                onTap: () => Get.back(
                  result: {'isNewDay': false, 'dayNumber': index + 1},
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Day'),
              onTap: () => Get.back(
                result: {
                  'isNewDay': true,
                  'dayNumber': itinerary.days.length + 1
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      try {
        _isLoading.value = true;

        if (result['isNewDay']) {
          // Create new day first
          final day = await _dayItineraryService.createDayItinerary(
            dayNumber: result['dayNumber'],
            itineraryId: itinerary.id!,
          );

          // Add place to the new day
          await _placeItineraryService.createPlaceItinerary(
            order: 1,
            dayId: day.id!,
            placeId: place.id!,
            time: '10:00',
          );
        } else {
          // Add place to existing day
          final days =
              await _dayItineraryService.getDayItineraries(itinerary.id!);
          final day =
              days.firstWhere((d) => d.dayNumber == result['dayNumber']);

          // Get existing places to determine order
          final places =
              await _placeItineraryService.getPlaceItineraries(day.id!);

          await _placeItineraryService.createPlaceItinerary(
            order: places.length + 1,
            dayId: day.id!,
            placeId: place.id!,
            time: '10:00',
          );
        }

        await _loadItineraries(); // Reload itineraries
        Get.snackbar(
          'Success',
          'Place added to itinerary',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to add place to itinerary',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        _isLoading.value = false;
      }
    }
  }
}
