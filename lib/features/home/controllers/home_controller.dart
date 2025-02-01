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

  final RxDouble _currentBudget = 0.0.obs;
  double get currentBudget => _currentBudget.value;

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

  void searchPlacesByBudget(double budget) {
    _currentBudget.value = budget;
    _isLoading.value = true;
    _error.value = '';

    try {
      // Filter places based on budget
      final affordablePlaces = _places.where((place) {
        // If the place is free, include it
        if (place.isFree) return true;
        // If the place has a price, check against budget
        if (place.price != null) {
          return place.price! <= budget;
        }
        // If no price info available, exclude it
        return false;
      }).toList();

      if (affordablePlaces.isEmpty) {
        _error.value =
            'No destinations found within your budget of MYR ${budget.toStringAsFixed(2)}';
      }

      _places.value = affordablePlaces;
    } catch (e) {
      _error.value = 'Error searching for places: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  void clearBudgetSearch() {
    _currentBudget.value = 0.0;
    _error.value = '';
    // Reload all places
    _loadPlaces();
  }

  @override
  void onInit() {
    super.onInit();
    _loadPlaces();
  }
}
