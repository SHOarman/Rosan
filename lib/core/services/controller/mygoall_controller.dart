import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
class GoalItem {
  final String? id;
  final String title;
  final String deadline;
  final String iconType;
  final RxDouble progress;

  GoalItem({
    this.id,
    required this.title,
    required this.deadline,
    required this.iconType,
    double progress = 0.0,
  }) : progress = progress.obs;
}

class MygoallController extends GetxController {
  final RxList<GoalItem> goals = <GoalItem>[].obs;
  final RxInt totalGoalsCount = 0.obs;
  final RxBool isLoading = false.obs;

  void _triggerDashboardUpdates() {
    try {
      if (Get.isRegistered<WinsController>()) {
        Get.find<WinsController>().fetchWinsDashboard();
      }
      if (Get.isRegistered<Authcontroller>()) {
        Get.find<Authcontroller>().fetchDashboard();
      }
    } catch (_) {}
  }

  @override
  void onInit() {
    super.onInit();
    fetchGoals();
  }

  double get overallProgress {
    if (goals.isEmpty) return 0.0;
    double sum = goals.fold(0.0, (previous, goal) => previous + goal.progress.value);
    return sum / goals.length;
  }

  int get activeGoalsCount => totalGoalsCount.value > 0 ? totalGoalsCount.value : goals.length;

  Future<void> fetchGoals() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        return; // Don't fetch if not logged in
      }

      final response = await http.get(
        Uri.parse(Apiservices.listgetgoals),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print("===== GET GOALS RESPONSE =====");
        print("StatusCode: ${response.statusCode}");
        print("Body: ${response.body}");
        print("================================");
        if (decodedData['success'] == true) {
          final List dataList = decodedData['data'] ?? [];
          final meta = decodedData['meta'];
          
          if (meta != null && meta['total'] != null) {
            totalGoalsCount.value = meta['total'] as int;
          } else {
             totalGoalsCount.value = dataList.length;
          }

          goals.clear();
          
          final iconTypes = ['rocket', 'run', 'book', 'money'];

          for (int i = 0; i < dataList.length; i++) {
            final item = dataList[i];
            
            // Format deadline if necessary
            String rawDeadline = item['deadline'] ?? '';
            String formattedDeadline = 'N/A';
            if (rawDeadline.isNotEmpty) {
               try {
                 final dt = DateTime.parse(rawDeadline).toLocal();
                 final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                 formattedDeadline = '${monthNames[dt.month - 1]} ${dt.year}';
               } catch(e) {
                 formattedDeadline = rawDeadline;
               }
            }
            
            double prog = 0.0;
            if (item['progress'] != null) {
              prog = (item['progress'] is int) ? (item['progress'] as int).toDouble() / 100.0 : (item['progress'] as double) / 100.0;
            }

            goals.add(GoalItem(
              id: item['id'],
              title: item['title'] ?? 'No Title',
              deadline: formattedDeadline,
              iconType: iconTypes[i % iconTypes.length],
              progress: prog,
            ));
          }
        }
      } else {
        print("===== GET GOALS ERROR =====");
        print("Error fetching goals: ${response.statusCode}");
        print("Body: ${response.body}");
        print("===========================");
      }
    } catch (e) {
      print("Error fetching goals: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> incrementProgress(GoalItem goal) async {
    if (goal.id == null || goal.id!.isEmpty) {
      print("Error: Cannot increment progress, goal ID is missing.");
      return;
    }

    if (goal.progress.value < 1.0) {
      // Optimistic UI update
      goal.progress.value = (goal.progress.value + 0.10).clamp(0.0, 1.0);
      goals.refresh();

      try {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken') ?? '';

        final String url = '${Apiservices.goals}/${goal.id}/progress';
        final Map<String, dynamic> requestBody = {
          "increment": 10,
          "note": "Completed daily goal milestone"
        };

        print("===== INCREMENT GOAL PROGRESS PAYLOAD =====");
        print("URL: $url");
        print(jsonEncode(requestBody));
        print("===========================================");

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'ngrok-skip-browser-warning': 'true',
            'bypass-tunnel-reminder': 'true',
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("===== INCREMENT GOAL PROGRESS SUCCESS =====");
          print("StatusCode: ${response.statusCode}");
          print("Body: ${response.body}");
          print("===========================================");
          _triggerDashboardUpdates();
        } else {
          print("===== INCREMENT GOAL PROGRESS ERROR =====");
          print("StatusCode: ${response.statusCode}");
          print("Body: ${response.body}");
          print("=========================================");
          // Optional: Revert optimistic update here if needed
        }
      } catch (e) {
        print("Error incrementing goal progress: $e");
        // Optional: Revert optimistic update here if needed
      }
    }
  }

  DateTime? _parseDeadline(String input) {
    try {
      return DateTime.parse(input);
    } catch (e) {
      final parts = input.trim().split(' ');
      if (parts.length >= 2) {
        String monthStr = '';
        String yearStr = '';

        if (int.tryParse(parts[0]) != null && parts[0].length == 4) {
          yearStr = parts[0];
          monthStr = parts[1].toLowerCase();
        } else {
          monthStr = parts[0].toLowerCase();
          yearStr = parts[1];
        }

        int year = int.tryParse(yearStr) ?? DateTime.now().year;
        int month = 1;
        if (monthStr.startsWith('jan')) month = 1;
        else if (monthStr.startsWith('feb')) month = 2;
        else if (monthStr.startsWith('mar')) month = 3;
        else if (monthStr.startsWith('apr')) month = 4;
        else if (monthStr.startsWith('may')) month = 5;
        else if (monthStr.startsWith('jun')) month = 6;
        else if (monthStr.startsWith('jul')) month = 7;
        else if (monthStr.startsWith('aug')) month = 8;
        else if (monthStr.startsWith('sep')) month = 9;
        else if (monthStr.startsWith('oct')) month = 10;
        else if (monthStr.startsWith('nov')) month = 11;
        else if (monthStr.startsWith('dec')) month = 12;
        
        return DateTime(year, month + 1, 0, 23, 59, 59);
      }
    }
    return null;
  }

  Future<void> addGoal(String title, String deadline) async {
    final parsedDate = _parseDeadline(deadline);
    if (parsedDate != null && parsedDate.isBefore(DateTime.now())) {
      print("===== CREATE GOAL ERROR =====");
      print("Error: Past deadline given! ($deadline)");
      print("=============================");
      return;
    }

    final String finalDeadlineIso = parsedDate != null 
        ? parsedDate.toUtc().toIso8601String()
        : DateTime.now().add(const Duration(days: 30)).toUtc().toIso8601String();

    final iconTypes = ['rocket', 'run', 'book', 'money'];
    final iconType = iconTypes[goals.length % iconTypes.length];
    
    // Optimistic UI update
    goals.add(
      GoalItem(
        title: title,
        deadline: deadline,
        iconType: iconType,
        progress: 0.0,
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final Map<String, dynamic> requestBody = {
        "title": title,
        "description": "",
        "deadline": finalDeadlineIso
      };

      print("===== CREATE GOAL PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("===============================");

      final response = await http.post(
        Uri.parse(Apiservices.goals),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print("===== CREATE GOAL RESPONSE =====");
      print("StatusCode: ${response.statusCode}");
      print(response.body);
      print("================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _triggerDashboardUpdates();
      }

    } catch (e) {
      print("Error creating goal: $e");
    }
  }

  Future<void> deleteGoal(GoalItem goal) async {
    if (goal.id == null || goal.id!.isEmpty) {
      print("Error: Cannot delete goal, goal ID is missing.");
      // Still remove locally if it has no ID (like an optimistic un-synced goal)
      goals.remove(goal);
      return;
    }

    // Optimistic UI update
    goals.remove(goal);
    if (totalGoalsCount.value > 0) {
      totalGoalsCount.value--;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final String url = '${Apiservices.goals}/${goal.id}';
      
      print("===== DELETE GOAL =====");
      print("URL: $url");
      print("=======================");

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("===== DELETE GOAL SUCCESS =====");
        print("Goal deleted successfully on server.");
        print("===============================");
        _triggerDashboardUpdates();
      } else {
        print("===== DELETE GOAL ERROR =====");
        print("StatusCode: ${response.statusCode}");
        print("Body: ${response.body}");
        print("=============================");
        // Optional: Re-add the goal to the list if API fails
      }
    } catch (e) {
      print("Error deleting goal: $e");
      // Optional: Re-add the goal to the list if API fails
    }
  }
}