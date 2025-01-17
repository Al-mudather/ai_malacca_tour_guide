import 'package:ai_malacca_tour_guide/agents/base_agent.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class RestaurantAgent extends BaseAgent {
  final String location;
  final String cuisinePreference;
  final double budgetRange;

  RestaurantAgent(
    ChatOpenAI llm,
    this.location,
    this.cuisinePreference,
    this.budgetRange,
  ) : super(llm);

  @override
  Future<List<Place>> execute() async {
    final promptTemplate = PromptTemplate.fromTemplate("""
      Find restaurants in {location} with:
      - Cuisine type: {cuisine}
      - Budget range: {budget}
      For each restaurant, provide:
      - Name
      - Average meal cost
      - Cuisine type
      - Rating
      - Opening hours
      Format as JSON.
      """);

    final chain = LLMChain(
      prompt: promptTemplate,
      llm: llm,
    );

    final response = await chain.run({
      'location': location,
      'cuisine': cuisinePreference,
      'budget': budgetRange.toString(),
    });

    return Place.listFromJson(response);
  }
}
