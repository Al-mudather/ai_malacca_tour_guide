import 'package:ai_malacca_tour_guide/services/category_service.dart';
import 'package:get/get.dart';

class CategoryManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryService());
  }
}
