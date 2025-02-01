import 'package:ai_malacca_tour_guide/features/place/controllers/place_details_controller.dart';
import 'package:ai_malacca_tour_guide/services/day_itinerary_service.dart';
import 'package:ai_malacca_tour_guide/services/itinerary_service.dart';
import 'package:ai_malacca_tour_guide/services/place_itinerary_service.dart';
import 'package:get/get.dart';

class PlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlaceDetailsController());
    Get.lazyPut(() => ItineraryService());
    Get.lazyPut(() => DayItineraryService());
    Get.lazyPut(() => PlaceItineraryService());
  }
}
