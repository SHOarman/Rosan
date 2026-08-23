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
  final RxBool isLoading;

  GoalItem({
    this.id,
    required this.title,
    required this.deadline,
    required this.iconType,
    double progress = 0.0,
    bool isLoading = false,
  }) : progress = progress.obs,
       isLoading = isLoading.obs;
}

class MygoallController extends GetxController {
  final RxList<GoalItem> goals = <GoalItem>[].obs;
  final RxInt totalGoalsCount = 0.obs;
  final RxBool isLoading = false.obs;

  // Pagination
  final RxBool isLoadingMore = false.obs;
  final RxBool isCreatingGoal = false.obs;
  int currentPage = 1;
  final int pageSize = 15;
  bool hasMoreData = true;

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

  Future<void> fetchGoals({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isLoadingMore.value || !hasMoreData) return;
      isLoadingMore.value = true;
      currentPage++;
    } else {
      if (goals.isEmpty) isLoading.value = true;
      currentPage = 1;
      hasMoreData = true;
      // Do not clear immediately to avoid UI blinking empty
      // goals.clear(); 
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        isLoadingMore.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('${Apiservices.listgetgoals}?page=$currentPage&pageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['success'] == true) {
          final dataOrList = decodedData['data'];
          final List dataList = (dataOrList is Map) ? (dataOrList['goals'] as List? ?? []) : (dataOrList as List? ?? []);
          
          if (dataList.length < pageSize) {
            hasMoreData = false;
          }

          final meta = decodedData['meta'] ?? (dataOrList is Map ? dataOrList['meta'] : null);
          
          if (!isLoadMore) {
            goals.clear();
            if (meta != null && meta['total'] != null) {
              totalGoalsCount.value = meta['total'] as int;
            } else {
               totalGoalsCount.value = dataList.length;
            }
          }

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

            final idStr = item['id'] != null ? item['id'].toString() : (item['title'] ?? 'No Title');
            final hash = idStr.hashCode.abs();

            goals.add(GoalItem(
              id: item['id'],
              title: item['title'] ?? 'No Title',
              deadline: formattedDeadline,
              iconType: iconTypes[hash % iconTypes.length],
              progress: prog,
            ));
          }
        }
      } else {
        print("Error fetching goals: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching goals: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMoreGoals() {
    fetchGoals(isLoadMore: true);
  }

  Future<void> incrementProgress(GoalItem goal) async {
    if (goal.id == null || goal.id!.isEmpty || goal.isLoading.value) {
      return;
    }

    if (goal.progress.value < 1.0) {
      goal.isLoading.value = true;
      goals.refresh();

      try {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken') ?? '';

        final String url = '${Apiservices.goals}/${goal.id}/progress';
        final Map<String, dynamic> requestBody = {
          "increment": 10,
          "note": "Completed daily goal milestone"
        };

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
          goal.progress.value = (goal.progress.value + 0.10).clamp(0.0, 1.0);
          _triggerDashboardUpdates();
        } else {
          print("Failed to increment progress: ${response.body}");
        }
      } catch (e) {
        print("Error incrementing goal progress: $e");
      } finally {
        goal.isLoading.value = false;
        goals.refresh();
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

  Future<bool> addGoal(String title, String deadline) async {
    final parsedDate = _parseDeadline(deadline);
    if (parsedDate != null && parsedDate.isBefore(DateTime.now())) {
      print("===== CREATE GOAL ERROR =====");
      print("Error: Past deadline given! ($deadline)");
      print("=============================");
      return false;
    }

    final String finalDeadlineIso = parsedDate != null 
        ? parsedDate.toUtc().toIso8601String()
        : DateTime.now().add(const Duration(days: 30)).toUtc().toIso8601String();
    
    isCreatingGoal.value = true;

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
        await fetchGoals();
        _triggerDashboardUpdates();
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print("Error creating goal: $e");
      return false;
    } finally {
      isCreatingGoal.value = false;
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