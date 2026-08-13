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
  final RxBool hasMore = false.obs;

  int currentPage = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory({bool isRefresh = true}) async {
    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage = 1;
      }

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      final url = '${Apiservices.aiHistory}?page=$currentPage&pageSize=$pageSize';
      print("===== FETCH CHAT HISTORY =====");
      print("GET $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("==============================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          List dataList = [];
          if (decoded['data'] is List) {
            dataList = decoded['data'];
          } else if (decoded['data'] is Map && decoded['data']['history'] != null) {
            dataList = decoded['data']['history'];
          }

          if (decoded['meta'] != null && decoded['meta']['hasMore'] != null) {
            hasMore.value = decoded['meta']['hasMore'] == true;
          } else {
            hasMore.value = dataList.length >= pageSize;
          }

          final List<ChatMessage> fetchedMessages = [];
          for (var item in dataList) {
            if (item is Map) {
              final id = item['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
              final prompt = item['prompt']?.toString() ?? '';
              final responseText = item['response']?.toString() ?? '';
              final createdAt = item['createdAt']?.toString() ?? item['created_at']?.toString() ?? '';

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
          }

          if (isRefresh) {
            // Append welcome message at top of old messages (end of reverse list)
            fetchedMessages.add(ChatMessage(
              id: 'welcome_ai',
              isUser: false,
              text: "Hey there! I'm so glad you're here. 🌟 I'm your Rise AI coach — I'm here to cheer you on, help you think clearly, and keep you moving forward. What's on your mind today?",
              time: '9:41 AM',
            ));
            messages.value = fetchedMessages;
          } else {
            messages.addAll(fetchedMessages);
          }
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

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: body,
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          final responseText = data['response']?.toString() ?? '';

          if (responseText.isNotEmpty) {
            messages.insert(0, ChatMessage(
              id: '${data['id']}_ai',
              isUser: false,
              text: responseText,
              time: timeStr,
            ));
          }
        }
      } else {
        print("Failed to send message: ${response.body}");
      }
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      isSending.value = false;
    }
  }
}
