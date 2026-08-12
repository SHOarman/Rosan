import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class ChatMessage {
  final String id;
  final bool isUser;
  final String text;
  final String time;

  ChatMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.time,
  });
}

class AiCoachController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      print("===== FETCH CHAT HISTORY =====");
      final url = Apiservices.aiHistory;
      print("GET $url");
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("==============================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List dataList = decoded['data'];
          
          final List<ChatMessage> fetchedMessages = [];
          for (var item in dataList) {
            final id = item['id']?.toString() ?? '';
            final prompt = item['prompt']?.toString() ?? '';
            final responseText = item['response']?.toString() ?? '';
            final createdAt = item['createdAt']?.toString() ?? '';
            
            String timeStr = '';
            try {
              if (createdAt.isNotEmpty) {
                final dt = DateTime.parse(createdAt).toLocal();
                final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
                final m = dt.minute.toString().padLeft(2, '0');
                final period = dt.hour >= 12 ? 'PM' : 'AM';
                timeStr = '$h:$m $period';
              }
            } catch (_) {}

            if (responseText.isNotEmpty) {
              fetchedMessages.add(ChatMessage(
                id: '${id}_ai',
                isUser: false,
                text: responseText,
                time: timeStr,
              ));
            }
            if (prompt.isNotEmpty) {
              fetchedMessages.add(ChatMessage(
                id: '${id}_user',
                isUser: true,
                text: prompt,
                time: timeStr,
              ));
            }
          }
          
          // Add default welcome message if there are no messages
          if (fetchedMessages.isEmpty) {
            fetchedMessages.add(ChatMessage(
              id: 'welcome_ai',
              isUser: false,
              text: "Hey there! I'm so glad you're here. 🌟 I'm your Rise AI coach — I'm here to cheer you on, help you think clearly, and keep you moving forward. What's on your mind today?",
              time: '9:41 AM',
            ));
          } else {
            // Also append the welcome message at the very end of history (oldest)
            fetchedMessages.add(ChatMessage(
              id: 'welcome_ai',
              isUser: false,
              text: "Hey there! I'm so glad you're here. 🌟 I'm your Rise AI coach — I'm here to cheer you on, help you think clearly, and keep you moving forward. What's on your mind today?",
              time: '9:41 AM',
            ));
          }
          
          messages.value = fetchedMessages;
        }
      }
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;
    
    try {
      isSending.value = true;
      
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final m = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? 'PM' : 'AM';
      final timeStr = '$h:$m $period';

      // Insert User message at index 0 (bottom of reverse list)
      messages.insert(0, ChatMessage(
        id: '${tempId}_user',
        isUser: true,
        text: prompt,
        time: timeStr,
      ));

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      print("===== SEND AI CHAT MESSAGE =====");
      final url = Apiservices.aiChat;
      print("POST $url");
      
      final body = jsonEncode({
        "prompt": prompt,
      });

      final request = http.Request('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.body = body;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          final responseText = data['response']?.toString() ?? '';
          
          if (responseText.isNotEmpty) {
            // Insert AI response at index 0 (so it appears below the user message in reverse list)
            messages.insert(0, ChatMessage(
              id: '${data['id']}_ai',
              isUser: false,
              text: responseText,
              time: timeStr,
            ));
          }
        }
      } else {
        // If failed, remove the optimistically inserted user message or show error
        print("Failed to send message: ${response.body}");
      }
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      isSending.value = false;
    }
  }
}
