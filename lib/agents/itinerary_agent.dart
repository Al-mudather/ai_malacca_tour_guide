import 'package:ai_malacca_tour_guide/agents/base_agent.dart';
import 'package:ai_malacca_tour_guide/models/itinerary_model.dart';
import 'package:ai_malacca_tour_guide/models/place_model.dart';
import 'package:ai_malacca_tour_guide/utils/date_utils.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class ItineraryAgent extends BaseAgent {
  final List<Place> filteredPlaces;
  final int days;
  final Map<String, dynamic> preferences;
  final DateTime startDate;

  ItineraryAgent(
    ChatOpenAI llm,
    this.filteredPlaces,
    this.days,
    this.preferences,
    this.startDate,
  ) : super(llm);

  @override
  Future<ItineraryModel> execute() async {
    // Calculate end date based on start date and number of days
    final endDate = startDate.add(Duration(days: days - 1));

    // Use DateUtils to ensure consistent date formatting
    final formattedStartDate = DateUtils.formatDate(startDate);
    final formattedEndDate = DateUtils.formatDate(endDate);

    final promptTemplate = PromptTemplate.fromTemplate("""
      Create a {days}-day itinerary for dates {startDate} to {endDate} using these places: {places}
      User preferences: {preferences}
      
      Consider:
      - Opening hours
      - Travel time between locations
      - Time needed at each place
      - Logical order of visits
      - IMPORTANT: Use EXACTLY these dates:
        * Start date: {startDate}
        * End date: {endDate}
      
      Group into daily plans with time slots.
      Format as JSON with structure:
      {
        "startDate": "{startDate}",
        "endDate": "{endDate}",
        "days": [{
          "date": "YYYY-MM-DD",  // Must be sequential starting from {startDate}
          "places": [{
            "name": "Place Name",
            "timeSlot": "HH:MM-HH:MM",
            "estimatedCost": 0.0
          }]
        }]
      }

      Rules:
      1. The startDate MUST be exactly: {startDate}
      2. The endDate MUST be exactly: {endDate}
      3. Each day's date MUST be between startDate and endDate
      4. Dates MUST be in YYYY-MM-DD format
      """);

    final chain = LLMChain(
      prompt: promptTemplate,
      llm: llm,
    );

    final response = await chain.run({
      'days': days.toString(),
      'startDate': formattedStartDate,
      'endDate': formattedEndDate,
      'places': filteredPlaces.map((p) => p.toJson()).toList().toString(),
      'preferences': preferences.toString(),
    });

    return ItineraryModel.fromJsonString(response);
  }
}



// class ItineraryAgent extends BaseAgent {
//   final List<Place> filteredPlaces;
//   final int days;
//   final Map<String, dynamic> preferences;
//   final DateTime startDate;

//   ItineraryAgent(
//     ChatOpenAI llm,
//     this.filteredPlaces,
//     this.days,
//     this.preferences,
//     this.startDate,
//   ) : super(llm);

//   @override
//   Future<ItineraryModel> execute() async {
//     // Calculate end date based on start date and number of days
//     final endDate = startDate.add(Duration(days: days - 1));

//     final promptTemplate = PromptTemplate.fromTemplate("""
//       Create a {days}-day itinerary for dates {startDate} to {endDate} using these places: {places}
//       User preferences: {preferences}
      
//       Consider:
//       - Opening hours
//       - Travel time between locations
//       - Time needed at each place
//       - Logical order of visits
//       - IMPORTANT: Use EXACTLY these dates:
//         * Start date: {startDate}
//         * End date: {endDate}
      
//       Group into daily plans with time slots.
//       Format as JSON with structure:
//       {
//         "startDate": "{startDate}",
//         "endDate": "{endDate}",
//         "days": [{
//           "date": "YYYY-MM-DD",  // Must be sequential starting from {startDate}
//           "places": [{
//             "name": "Place Name",
//             "timeSlot": "HH:MM-HH:MM",
//             "estimatedCost": 0.0
//           }]
//         }]
//       }

//       Rules:
//       1. The startDate MUST be exactly: {startDate}
//       2. The endDate MUST be exactly: {endDate}
//       3. Each day's date MUST be between startDate and endDate
//       4. Dates MUST be in YYYY-MM-DD format
//       """);

//     final chain = LLMChain(
//       prompt: promptTemplate,
//       llm: llm,
//     );

//     final response = await chain.run({
//       'days': days.toString(),
//       'startDate': startDate.toIso8601String().split('T')[0],
//       'endDate': endDate.toIso8601String().split('T')[0],
//       'places': filteredPlaces.map((p) => p.toJson()).toList().toString(),
//       'preferences': preferences.toString(),
//     });

//     return ItineraryModel.fromJsonString(response);
//   }
// }
