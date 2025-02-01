import 'package:get/get.dart';
import '../../../models/itinerary_model.dart';
import '../../../models/place_itinerary_model.dart';
import '../../../models/day_itinerary_model.dart';
import '../../../models/chat_response_model.dart';
import '../../../database/crud/itineraries_crud.dart';
import '../../../database/crud/place_itineraries_crud.dart';
import '../../../database/crud/day_itineraries_crud.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../utils/place_images.dart';
import 'dart:convert';

class ItineraryController extends GetxController {
  final _itinerariesCrud = Get.find<ItinerariesCRUD>();
  final _placeItinerariesCrud = Get.find<PlaceItinerariesCRUD>();
  final _dayItinerariesCrud = Get.find<DayItinerariesCRUD>();

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
      final itineraries = await _itinerariesCrud.getAllItineraries();
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

      final itinerary = await _itinerariesCrud.getItineraryById(itineraryId);
      if (itinerary == null) {
        Get.back();
        return;
      }

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
      final daysData = await _dayItinerariesCrud.getDayItinerariesByItineraryId(
        itineraryId,
      );
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
      final places = await _placeItinerariesCrud.getPlaceItinerariesByDayId(
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

      await _itinerariesCrud.updateItinerary(currentItinerary.value!);
      Get.snackbar('Success', 'Itinerary saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save itinerary: $e');
    }
  }

  Future<void> deleteItinerary(int itineraryId) async {
    try {
      await _itinerariesCrud.deleteItinerary(itineraryId);
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
          await _itinerariesCrud.getItinerariesByUserId(userId);

      if (userItineraries.isEmpty) {
        final startDate = DateTime.now();

        if (currentChatItinerary != null) {
          // Get status from chat itinerary or use 'draft' as default
          final status =
              (currentChatItinerary?['status'] as String?) ?? 'draft';

          return await _itinerariesCrud.createItinerary(
            ItineraryModel(
              userId: userId,
              name: currentChatItinerary?['title'] ?? 'My Malacca Trip',
              title: currentChatItinerary?['title'] ?? 'My Malacca Trip',
              startDate: currentChatItinerary?['startDate'] ??
                  startDate.toIso8601String(),
              endDate: currentChatItinerary?['endDate'] ??
                  startDate.toIso8601String(),
              totalBudget: int.parse(currentChatItinerary?['totalBudget']
                      .replaceAll(RegExp(r'[^\d]'), '') ??
                  '0'),
              preferences:
                  currentChatItinerary?['preferences'] ?? <String, dynamic>{},
              status: status, // Now status is a non-nullable String
            ),
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
      final days =
          await _dayItinerariesCrud.getDayItinerariesByItineraryId(itineraryId);

      if (days.isEmpty || days.length < dayNumber) {
        final date =
            DateTime.parse(startDate ?? DateTime.now().toIso8601String())
                .add(Duration(days: dayNumber - 1));
        return await _dayItinerariesCrud.createDayItinerary(
          DayItineraryModel(
            itineraryId: itineraryId,
            dayNumber: dayNumber,
            date: date,
          ),
        );
      }
      return days[dayNumber - 1];
    } catch (e) {
      print('Error in getOrCreateDayItinerary: $e');
      rethrow;
    }
  }

  Future<void> addPlaceToDay(Activity activity, int dayItineraryId) async {
    try {
      // Check if place already exists for this day
      final existingPlaces = await _placeItinerariesCrud
          .getPlaceItinerariesByDayId(dayItineraryId);
      final placeExists =
          existingPlaces.any((place) => place.place == activity.name);

      if (placeExists) {
        throw Exception('This place is already added to this day');
      }
      // Get image URL from PlaceImages service
      final imageUrl = await PlaceImages().getUnsplashImage(activity.name);

      // Extract numeric cost from entrance fee
      final entranceFee = activity.entranceFee ?? '';
      final numericCost = entranceFee.replaceAll(RegExp(r'[^0-9]'), '');
      final cost = numericCost.isEmpty ? 0 : int.tryParse(numericCost) ?? 0;

      final place = PlaceItineraryModel(
        dayId: dayItineraryId,
        placeId: activity.name.hashCode,
        order: existingPlaces.length + 1,
        time: activity.duration ?? '00:00',
      );

      await _placeItinerariesCrud.createPlaceItinerary(place);
    } catch (e) {
      print('Error in addPlaceToDay: $e');
      rethrow;
    }
  }

  Future<void> addActivityToTrip(Activity activity, int dayNumber) async {
    try {
      final authController = Get.find<AuthController>();
      if (authController.currentUser.value == null) {
        throw Exception('User not authenticated');
      }

      final userId = authController.currentUser.value!.id!;
      final itinerary = await getOrCreateItinerary(userId);
      final dayItinerary = await getOrCreateDayItinerary(
        itinerary.id!,
        dayNumber,
        itinerary.startDate,
      );

      try {
        await addPlaceToDay(activity, dayItinerary.id!);

        // Refresh the current view if needed
        if (currentItinerary.value?.id == itinerary.id) {
          await loadDayPlaces(dayNumber);
        }

        // Get.snackbar(
        //   'Success',
        //   'Place added successfully',
        //   snackPosition: SnackPosition.BOTTOM,
        // );
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

  Future<void> updateItinerary(ItineraryModel itinerary) async {
    try {
      isLoading.value = true;
      await _itinerariesCrud.updateItinerary(itinerary);
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
}
