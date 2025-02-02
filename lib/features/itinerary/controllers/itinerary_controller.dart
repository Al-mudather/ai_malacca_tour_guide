import 'package:get/get.dart';
import '../../../models/itinerary_model.dart';
import '../../../models/place_itinerary_model.dart';
import '../../../models/day_itinerary_model.dart';
import '../../../models/chat_response_model.dart';
import '../../../models/place_model.dart';
import '../../../services/itinerary_service.dart';
import '../../../services/day_itinerary_service.dart';
import '../../../services/place_itinerary_service.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../utils/place_images.dart';
import 'dart:convert';

class ItineraryController extends GetxController {
  final _itineraryService = ItineraryService();
  final _dayItineraryService = DayItineraryService();
  final _placeItineraryService = PlaceItineraryService();
  final _authController = Get.find<AuthController>();

  final currentItinerary = Rx<ItineraryModel?>(null);
  final currentDayPlaces = <PlaceItineraryModel>[].obs;
  final isLoading = false.obs;
  final userItineraries = <ItineraryModel>[].obs;
  final currentDayIndex = 1.obs;
  final days = <DayItineraryModel>[].obs;

  // Store the raw decoded itinerary data from chat
  Map<String, dynamic>? currentChatItinerary;

  String get startDate => currentItinerary.value?.startDate ?? '';
  String get endDate => currentItinerary.value?.endDate ?? '';

  @override
  void onInit() {
    super.onInit();
    loadUserItineraries();
  }

  Future<void> loadUserItineraries() async {
    try {
      isLoading.value = true;
      if (_authController.currentUser.value?.id == null) {
        throw Exception('User not logged in');
      }

      final itineraries = await _itineraryService.getUserItineraries(
        _authController.currentUser.value!.id!,
      );
      userItineraries.value = itineraries;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load itineraries: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCurrentItinerary() async {
    try {
      isLoading.value = true;
      final itineraryId = Get.arguments['itineraryId'] as int?;
      if (itineraryId == null) {
        Get.back();
        return;
      }

      final itinerary = await _itineraryService.getItineraryById(itineraryId);
      currentItinerary.value = itinerary;
      await loadDays(itineraryId);

      // Load first day by default
      if (days.isNotEmpty) {
        currentDayIndex.value = 1; // Set to first day
        await loadDayPlaces(1); // Load places for first day
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load itinerary: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDays(int itineraryId) async {
    try {
      final daysData =
          await _dayItineraryService.getDayItineraries(itineraryId);
      days.value = daysData;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load days: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadDayPlaces(int dayIndex) async {
    try {
      if (days.isEmpty) {
        currentDayPlaces.clear();
        return;
      }

      // Ensure dayIndex is within bounds
      if (dayIndex < 1 || dayIndex > days.length) {
        Get.snackbar(
          'Error',
          'Invalid day index',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      currentDayIndex.value = dayIndex;
      final dayItinerary = days[dayIndex - 1];
      final places = await _placeItineraryService.getPlaceItineraries(
        dayItinerary.id!,
      );
      currentDayPlaces.value = places;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load places: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> saveItinerary() async {
    try {
      if (currentItinerary.value == null) return;

      await _itineraryService.updateItinerary(
        id: currentItinerary.value!.id!,
        name: currentItinerary.value!.name,
        description: currentItinerary.value!.description,
        title: currentItinerary.value!.title,
        startDate: currentItinerary.value!.startDate,
        endDate: currentItinerary.value!.endDate,
        totalBudget: currentItinerary.value!.totalBudget,
        preferences: currentItinerary.value!.preferences,
      );
      Get.snackbar('Success', 'Itinerary saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save itinerary: $e');
    }
  }

  Future<void> deleteItinerary(int itineraryId) async {
    try {
      await _itineraryService.deleteItinerary(itineraryId);
      userItineraries.removeWhere((itinerary) => itinerary.id == itineraryId);
      Get.snackbar(
        'Success',
        'Itinerary deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete itinerary',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error deleting itinerary: $e');
    }
  }

  Future<ItineraryModel> getOrCreateItinerary(int userId) async {
    try {
      final userItineraries =
          await _itineraryService.getUserItineraries(userId);

      if (userItineraries.isEmpty) {
        final startDate = DateTime.now();

        if (currentChatItinerary != null) {
          final status =
              (currentChatItinerary?['status'] as String?) ?? 'draft';

          return await _itineraryService.createItinerary(
            name: currentChatItinerary?['title'] ?? 'My Malacca Trip',
            description: 'Generated from chat',
            userId: userId,
            title: currentChatItinerary?['title'] ?? 'My Malacca Trip',
            startDate: currentChatItinerary?['startDate'] ??
                startDate.toIso8601String(),
            endDate:
                currentChatItinerary?['endDate'] ?? startDate.toIso8601String(),
            totalBudget: int.parse(currentChatItinerary?['totalBudget']
                    .replaceAll(RegExp(r'[^\d]'), '') ??
                '0'),
            preferences: currentChatItinerary?['preferences'],
          );
        }

        throw Exception('Failed to create new itinerary');
      }
      return userItineraries.first;
    } catch (e) {
      print('Error in getOrCreateItinerary: $e');
      rethrow;
    }
  }

  Future<DayItineraryModel> getOrCreateDayItinerary(
    int itineraryId,
    int dayNumber,
    String? startDate,
  ) async {
    try {
      final days = await _dayItineraryService.getDayItineraries(itineraryId);

      if (days.isEmpty || days.length < dayNumber) {
        return await _dayItineraryService.createDayItinerary(
          dayNumber: dayNumber,
          itineraryId: itineraryId,
        );
      }

      return days[dayNumber - 1];
    } catch (e) {
      print('Error in getOrCreateDayItinerary: $e');
      rethrow;
    }
  }

  Future<void> addPlaceToDay(
    int dayItineraryId,
    PlaceItineraryModel place,
  ) async {
    try {
      // Check if place already exists for this day
      final existingPlaces =
          await _placeItineraryService.getPlaceItineraries(dayItineraryId);
      final placeExists = existingPlaces
          .any((existingPlace) => existingPlace.placeId == place.placeId);

      if (placeExists) {
        throw Exception('Place already added to this day');
      }

      await _placeItineraryService.createPlaceItinerary(
        order: place.order,
        dayId: dayItineraryId,
        placeId: place.placeId,
        time: place.time,
      );
    } catch (e) {
      print('Error in addPlaceToDay: $e');
      rethrow;
    }
  }

  Future<void> updateItinerary(ItineraryModel itinerary) async {
    try {
      isLoading.value = true;
      await _itineraryService.updateItinerary(
        id: itinerary.id!,
        name: itinerary.name,
        description: itinerary.description,
        title: itinerary.title,
        startDate: itinerary.startDate,
        endDate: itinerary.endDate,
        totalBudget: itinerary.totalBudget,
        preferences: itinerary.preferences,
      );
      await loadUserItineraries();
      Get.snackbar(
        'Success',
        'Itinerary updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update itinerary',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  storeItineraryFromChat(Map<String, dynamic> decoded) {
    currentChatItinerary = decoded;
    print('Stored chat itinerary data');
  }

  Future<void> addActivityToTrip(Activity activity, int dayNumber) async {
    try {
      if (_authController.currentUser.value == null) {
        throw Exception('User not authenticated');
      }

      final userId = _authController.currentUser.value!.id!;
      final itinerary = await getOrCreateItinerary(userId);
      final dayItinerary = await getOrCreateDayItinerary(
        itinerary.id!,
        dayNumber,
        itinerary.startDate,
      );

      try {
        // Get existing places to determine the order
        final existingPlaces =
            await _placeItineraryService.getPlaceItineraries(dayItinerary.id!);

        // Extract location data
        final location = activity.location ?? {'lat': 0.0, 'lng': 0.0};
        final latitude = (location['lat'] as num?)?.toDouble() ?? 0.0;
        final longitude = (location['lng'] as num?)?.toDouble() ?? 0.0;

        // Create a Place model from the activity
        final place = Place(
          id: activity.name.hashCode,
          name: activity.name,
          location: 'Malacca', // Default location
          latitude: latitude,
          longitude: longitude,
          openingDuration: activity.duration ?? '1:00',
          isFree: activity.entranceFee == null ||
              activity.entranceFee!.toLowerCase().contains('free'),
          price: double.tryParse(
              activity.entranceFee?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'),
          description: activity.description,
          imageUrl: activity.imageUrl,
          categoryId: 1, // Default category
        );

        // Create a PlaceItineraryModel
        final placeItinerary = PlaceItineraryModel(
          dayId: dayItinerary.id!,
          placeId: place.id!,
          order: existingPlaces.length + 1,
          time: activity.duration ?? '1:00',
          place: place,
        );

        await addPlaceToDay(dayItinerary.id!, placeItinerary);

        // Refresh the current view if needed
        if (currentItinerary.value?.id == itinerary.id) {
          await loadDayPlaces(dayNumber);
        }
      } catch (e) {
        if (e.toString().contains('already added')) {
          Get.snackbar(
            'Error',
            '${activity.name} is already added to this day',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      print('Error in addActivityToTrip: $e');
      rethrow;
    }
  }
}
