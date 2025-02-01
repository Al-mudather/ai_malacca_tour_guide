import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/models/category_model.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:ai_malacca_tour_guide/services/place_service.dart';

class HomeController extends GetxController {
  final _placeService = Get.find<PlaceService>();

  final Rx<CategoryModel?> _selectedCategory = Rx<CategoryModel?>(null);
  CategoryModel? get selectedCategory => _selectedCategory.value;

  final RxList<Place> _places = <Place>[].obs;
  List<Place> get places => _places;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _error = RxString('');
  String get error => _error.value;

  void selectCategory(CategoryModel? category) {
    if (_selectedCategory.value?.id == category?.id)
      return; // Don't reload if same category
    _selectedCategory.value = category;
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      _places.clear(); // Clear existing places before loading new ones

      if (_selectedCategory.value == null) {
        // Load all places if no category is selected
        final allPlaces = await _placeService.getAllPlaces();
        _places.assignAll(allPlaces);
      } else {
        // Load places for the selected category
        final categoryPlaces = await _placeService
            .getPlacesByCategory(_selectedCategory.value!.id!);
        _places.assignAll(categoryPlaces);
      }
    } catch (e) {
      print('Error loading places: $e');
      _error.value = 'Failed to load places. Please try again.';
      _places.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadPlaces();
  }
}
