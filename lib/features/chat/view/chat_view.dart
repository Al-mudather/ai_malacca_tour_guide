import 'package:ai_malacca_tour_guide/controllers/chat_controller.dart';
import 'package:ai_malacca_tour_guide/features/chat/widgets/chat_bubble.dart';
import 'package:ai_malacca_tour_guide/features/chat/widgets/itinerary_card.dart';
import 'package:ai_malacca_tour_guide/models/chat_response_model.dart';
import 'package:ai_malacca_tour_guide/utils/types.dart';
import 'package:ai_malacca_tour_guide/features/itinerary/controllers/itinerary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final ChatController _chatController = Get.find<ChatController>();
  final ItineraryController _itineraryController =
      Get.find<ItineraryController>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final message = _textController.text;
    if (message.trim().isEmpty) return;

    _chatController.sendMessage(message);
    _textController.clear();

    // Scroll to bottom after message is sent
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageWidget(String content, bool isUser) {
    try {
      final decoded = json.decode(content);

      if (isUser) {
        return ChatBubble(
          message: decoded['message'],
          isUser: true,
        );
      }

      if (decoded['type'] == 'itinerary' && decoded['itinerary'] != null) {
        // Store the itinerary data
        _itineraryController.storeItineraryFromChat(decoded);

        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    decoded['message'],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                ...List<DayPlan>.from(
                  decoded['itinerary'].map((x) => DayPlan.fromJson(x)),
                ).map((day) => ItineraryCard(dayPlan: day)),
              ],
            ),
          ),
        );
      } else {
        return ChatBubble(
          message: decoded['message'],
          isUser: false,
        );
      }
    } catch (e) {
      print('Error building message widget: $e');
      print('Content was: $content');
      return ChatBubble(
        message: "Error displaying message",
        isUser: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tour Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chatController.clearMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = _chatController.messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildMessageWidget(
                      message.content,
                      message.role == MessageRole.user,
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(() {
            if (_chatController.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
