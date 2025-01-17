import 'package:ai_malacca_tour_guide/models/chat_message_model.dart' as app;
import 'package:ai_malacca_tour_guide/models/chat_response_model.dart';
import 'package:ai_malacca_tour_guide/controllers/agent_controller.dart';
import 'package:ai_malacca_tour_guide/utils/date_utils.dart';
import 'package:ai_malacca_tour_guide/utils/types.dart';
import 'package:get/get.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'dart:convert';

class ChatController extends GetxController {
  final AgentController _agentController = Get.find<AgentController>();
  final RxList<app.ChatMessage> messages = <app.ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  LLMChain? _chain;

  @override
  void onInit() {
    super.onInit();
    print('ChatController onInit called');
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      print('Initializing chat...');
      if (_agentController.llm == null) {
        print('Error: AgentController LLM is null');
        _showError('Chat service is not initialized properly.');
        return;
      }

      // Create a prompt template for the chat
      final promptTemplate = PromptTemplate.fromTemplate("""
You are alex an expert tour guide for Malacca city in Malaysia. Your role is to construct an itinerary for the user based on his budget and duration of stay.

IMPORTANT: You must ALWAYS respond in valid JSON format with the following structure for normal conversations:

{{
  "type": "conversation",
  "message": "Your response message here"
}}

OR for itineraries:

{{
  "type": "itinerary",
  "title": "Amazing title for the itinerary",
  "startDate": "The start date of the itinerary",
  "endDate": "The end date of the itinerary",
  "totalBudget": "The total budget of the itinerary",
  "message": "Your response message here",
  "itinerary": [
    {{
      "day": "Day 1",
      "title": "Title for this day",
      "activities": [
        {{
          "name": "Activity name",
          "description": "Activity description",
          "imageUrl": "URL to activity image",
          "entranceFee": "Entrance fee info",
          "duration": "Duration info",
          "rating": rating number,
          "openingHours": "Opening hours info",
          "tips": "Tips for visitors",
          "location": {{"latitude": 0.0, "longitude": 0.0}}
        }}
      ]
    }}
  ]
}}

Your role is to:
1. When creating itineraries, you need:
   - Budget (ask if not provided)
   - Duration of stay (ask if not provided)
2. Start immediatly and provide the itinerary for the user based on his budget and duration of stay.

# Remember: 
- ALL responses must be in valid JSON format as shown above.
- convert all the currency to Malaysian Ringgit (RM).
- Make sure the all date are correct.
- Do not give any inforamtion about any city or country except Malacca.
- If the user ask about any other city or country, you must respond with respect politely and ask if they want to know about Malacca as you are a local city guide.

the current date is : {currentDate}

Previous conversation:
{history}

Current user message: {input}
""");

      print('Creating LLMChain...');
      _chain = LLMChain(
        prompt: promptTemplate,
        llm: _agentController.llm,
      );

      // Send initial greeting
      print('Sending initial greeting...');
      final response = await _chain?.run({
        'history': '',
        'input': 'Start the conversation with a friendly greeting.',
        'currentDate': DateUtils.formatDate(DateTime.now()),
      });

      if (response != null) {
        print('Initial greeting response received: $response');
        final content = _extractContent(response);
        // print('Extracted content: $content');

        if (_isValidResponse(content)) {
          messages.add(app.ChatMessage(
            role: MessageRole.assistant,
            content: content,
          ));
        } else {
          _showError('Received invalid response format from the service.');
        }
      }
    } catch (e, stackTrace) {
      print('Error in _initializeChat: $e');
      print('Stack trace: $stackTrace');
      _showError('Failed to initialize chat service.');
    }
  }

  String _extractContent(String response) {
    try {
      // Check if the response is an AIChatMessage
      if (response.contains('content:') && response.contains('toolCalls:')) {
        // Find the start of the JSON content
        final contentStart =
            response.indexOf('{', response.indexOf('content:'));
        if (contentStart < 0) return response;

        // Count braces to find the matching end brace
        int braceCount = 1;
        int position = contentStart + 1;

        while (braceCount > 0 && position < response.length) {
          if (response[position] == '{') {
            braceCount++;
          } else if (response[position] == '}') {
            braceCount--;
          }
          position++;
        }

        if (braceCount == 0) {
          final jsonContent = response.substring(contentStart, position);
          print('Extracted JSON content: $jsonContent');
          return jsonContent;
        }
      }

      // If not an AIChatMessage format or extraction failed, return as is
      return response;
    } catch (e) {
      print('Error in _extractContent: $e');
      return response;
    }
  }

  bool _isValidResponse(String content) {
    try {
      final decoded = json.decode(content);
      return decoded['type'] != null &&
          decoded['message'] != null &&
          (decoded['type'] == 'conversation' ||
              (decoded['type'] == 'itinerary' && decoded['itinerary'] != null));
    } catch (e) {
      print('Error validating response: $e');
      return false;
    }
  }

  void _showError(String message) {
    messages.add(app.ChatMessage(
      role: MessageRole.assistant,
      content: json.encode({'type': 'conversation', 'message': message}),
    ));
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    print('Sending message: $content');
    isLoading.value = true;

    try {
      // Add user message
      final userMessage = app.ChatMessage(
        role: MessageRole.user,
        content:
            json.encode({'type': 'conversation', 'message': content.trim()}),
      );
      messages.add(userMessage);

      // Verify initialization
      if (_chain == null || _agentController.llm == null) {
        print('Chat service not initialized, attempting to initialize...');
        await _initializeChat();
        if (_chain == null || _agentController.llm == null) {
          throw Exception('Chat service failed to initialize');
        }
      }

      // Get conversation history
      final history = messages.map((m) {
        try {
          final decoded = json.decode(m.content);
          return '${m.role == MessageRole.user ? "User" : "Assistant"}: ${decoded['message']}';
        } catch (e) {
          return '${m.role == MessageRole.user ? "User" : "Assistant"}: ${m.content}';
        }
      }).join('\n');

      print('Sending request to LLM...');
      final response = await _chain!.run({
        'history': history,
        'input': content,
        'currentDate': DateUtils.formatDate(DateTime.now()),
      });

      print('Received response: $response');
      final extractedContent = _extractContent(response);
      print('Extracted content: $extractedContent');

      if (_isValidResponse(extractedContent)) {
        messages.add(app.ChatMessage(
          role: MessageRole.assistant,
          content: extractedContent,
        ));
      } else {
        print('Invalid JSON response: $extractedContent');
        _showError('Received invalid response format from the service.');
      }
    } catch (e, stackTrace) {
      print('Error in sendMessage: $e');
      print('Stack trace: $stackTrace');
      _showError(
          'An error occurred while processing your message. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void clearMessages() {
    messages.clear();
    _initializeChat();
  }
}
