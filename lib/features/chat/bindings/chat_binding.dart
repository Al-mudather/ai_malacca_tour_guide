import 'package:ai_malacca_tour_guide/controllers/agent_controller.dart';
import 'package:ai_malacca_tour_guide/controllers/chat_controller.dart';
import 'package:ai_malacca_tour_guide/features/itinerary/controllers/itinerary_controller.dart';
import 'package:ai_malacca_tour_guide/database/crud/itineraries_crud.dart';
import 'package:ai_malacca_tour_guide/database/crud/day_itineraries_crud.dart';
import 'package:ai_malacca_tour_guide/database/crud/place_itineraries_crud.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    print('ChatBinding: Setting up dependencies');

    // Register CRUD dependencies if not already registered
    if (!Get.isRegistered<ItinerariesCRUD>()) {
      print('ChatBinding: ItinerariesCRUD not found, creating new instance');
      Get.put(ItinerariesCRUD(), permanent: true);
    }
    if (!Get.isRegistered<DayItinerariesCRUD>()) {
      print('ChatBinding: DayItinerariesCRUD not found, creating new instance');
      Get.put(DayItinerariesCRUD(), permanent: true);
    }
    if (!Get.isRegistered<PlaceItinerariesCRUD>()) {
      print(
          'ChatBinding: PlaceItinerariesCRUD not found, creating new instance');
      Get.put(PlaceItinerariesCRUD(), permanent: true);
    }

    // Verify AgentController exists
    if (!Get.isRegistered<AgentController>()) {
      print('ChatBinding: AgentController not found, creating new instance');
      Get.put(AgentController(), permanent: true);
    } else {
      print('ChatBinding: Found existing AgentController');
    }

    // Verify ItineraryController exists
    if (!Get.isRegistered<ItineraryController>()) {
      print(
          'ChatBinding: ItineraryController not found, creating new instance');
      Get.put(ItineraryController(), permanent: true);
    } else {
      print('ChatBinding: Found existing ItineraryController');
    }

    // Create ChatController
    print('ChatBinding: Creating ChatController');
    Get.lazyPut(() => ChatController());
    print('ChatBinding: Dependencies setup complete');
  }
}
