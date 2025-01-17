import 'package:ai_malacca_tour_guide/agents/attraction_agent.dart';
import 'package:ai_malacca_tour_guide/agents/budget_filter_agent.dart';
import 'package:ai_malacca_tour_guide/agents/itinerary_agent.dart';
import 'package:ai_malacca_tour_guide/agents/restaurant_agent.dart';
import 'package:ai_malacca_tour_guide/config/env.dart';
import 'package:ai_malacca_tour_guide/models/itinerary_model.dart';
import 'package:get/get.dart';
import 'package:langchain_openai/langchain_openai.dart';

class AgentController extends GetxController {
  late ChatOpenAI llm;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    print('AgentController onInit called');
    if (!_isInitialized) {
      try {
        print('Initializing LLM with API key...');
        if (Environment.openAIKey.isEmpty) {
          print('Error: OpenAI API key is empty');
          return;
        }

        llm = ChatOpenAI(
          apiKey: Environment.openAIKey,
          defaultOptions: const ChatOpenAIOptions(
            model: 'gpt-3.5-turbo',
            temperature: 0.7,
          ),
        );
        _isInitialized = true;
        print('LLM initialized successfully');
      } catch (e) {
        print('Error initializing LLM: $e');
      }
    } else {
      print('LLM already initialized, skipping initialization');
    }
  }

  Future<ItineraryModel> generateItinerary({
    required String city,
    required double budget,
    required int days,
    required Map<String, dynamic> preferences,
    DateTime? startDate,
  }) async {
    try {
      // final actualStartDate = startDate ?? DateTime.now();
      final actualStartDate = DateTime.now();

      // 1. Get attractions
      final attractionAgent = AttractionAgent(
        llm,
        city,
        preferences['activities'] ?? [],
      );
      final attractions = await attractionAgent.execute();

      // 2. Get restaurants
      final restaurantAgent = RestaurantAgent(
        llm,
        city,
        preferences['cuisine'] ?? 'local',
        budget / days,
      );
      final restaurants = await restaurantAgent.execute();

      // 3. Filter by budget
      final budgetAgent = BudgetFilterAgent(
        llm,
        [...attractions, ...restaurants],
        budget,
        days,
      );
      final filteredPlaces = await budgetAgent.execute();

      // 4. Generate itinerary with start date
      final itineraryAgent = ItineraryAgent(
        llm,
        filteredPlaces,
        days,
        preferences,
        actualStartDate,
      );
      return await itineraryAgent.execute();
    } catch (e) {
      throw Exception('Failed to generate itinerary: $e');
    }
  }
}
