import 'package:get/get.dart';
import '../../../services/place_service.dart';
import '../../../services/category_service.dart';

class PlaceManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlaceService());
    Get.lazyPut(() => CategoryService());
  }
}
