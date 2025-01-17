import 'package:ai_malacca_tour_guide/agents/base_agent.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class BudgetFilterAgent extends BaseAgent {
  final List<Place> places;
  final double budget;
  final int days;

  BudgetFilterAgent(ChatOpenAI llm, this.places, this.budget, this.days)
      : super(llm);

  @override
  Future<List<Place>> execute() async {
    final promptTemplate = PromptTemplate.fromTemplate("""
      Filter and rank these places to fit a {budget} budget over {days} days.
      Places: {places}
      Consider:
      - Cost per place
      - Rating and popularity
      - Value for money
      Return only places that fit within budget.
      Format as JSON array of places.
      """);

    final chain = LLMChain(
      prompt: promptTemplate,
      llm: llm,
    );

    final response = await chain.run({
      'budget': budget.toString(),
      'days': days.toString(),
      'places': places.map((p) => p.toJson()).toList().toString(),
    });

    return Place.listFromJson(response);
  }
}
