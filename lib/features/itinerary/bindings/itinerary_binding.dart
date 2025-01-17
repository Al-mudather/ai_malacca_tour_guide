import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import '../../../database/crud/itineraries_crud.dart';
import '../../../database/crud/day_itineraries_crud.dart';
import '../../../database/crud/place_itineraries_crud.dart';

class ItineraryBinding extends Bindings {
  @override
  void dependencies() {
    // Register CRUD dependencies if not already registered
    if (!Get.isRegistered<ItinerariesCRUD>()) {
      Get.put(ItinerariesCRUD());
    }
    if (!Get.isRegistered<DayItinerariesCRUD>()) {
      Get.put(DayItinerariesCRUD());
    }
    if (!Get.isRegistered<PlaceItinerariesCRUD>()) {
      Get.put(PlaceItinerariesCRUD());
    }

    // Register the controller
    Get.lazyPut<ItineraryController>(() => ItineraryController());
  }
}
