import 'package:ai_malacca_tour_guide/services/day_itinerary_service.dart';
import 'package:ai_malacca_tour_guide/services/itinerary_service.dart';
import 'package:ai_malacca_tour_guide/services/place_itinerary_service.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';

class ItineraryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ItineraryService>()) {
      Get.put(ItineraryService());
    }
    if (!Get.isRegistered<DayItineraryService>()) {
      Get.put(DayItineraryService());
    }
    if (!Get.isRegistered<PlaceItineraryService>()) {
      Get.put(PlaceItineraryService());
    }

    // Register the controller
    Get.lazyPut<ItineraryController>(() => ItineraryController());
  }
}
