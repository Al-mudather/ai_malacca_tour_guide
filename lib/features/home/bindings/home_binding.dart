import 'package:ai_malacca_tour_guide/services/category_service.dart';
import 'package:ai_malacca_tour_guide/services/place_service.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryService());
    Get.lazyPut(() => PlaceService());
    Get.lazyPut(() => HomeController());
  }
}
