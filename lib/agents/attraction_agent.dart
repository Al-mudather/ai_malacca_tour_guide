import 'package:ai_malacca_tour_guide/agents/base_agent.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class AttractionAgent extends BaseAgent {
  final String city;
  final List<String> preferences;

  AttractionAgent(ChatOpenAI llm, this.city, this.preferences) : super(llm);

  @override
  Future<List<Place>> execute() async {
    // Create prompt template for attraction search
    final promptTemplate = PromptTemplate.fromTemplate("""
      Find tourist attractions in {city} that match these preferences: {preferences}
      For each attraction, provide:
      - Name
      - Description
      - Estimated cost
      - Opening hours
      - Rating
      Format as JSON.
      """);

    // Create chain
    final chain = LLMChain(
      prompt: promptTemplate,
      llm: llm,
    );

    // Run chain with inputs
    final response = await chain.run({
      'city': city,
      'preferences': preferences.join(', '),
    });

    // Parse JSON response
    return Place.listFromJson(response);
  }
}
