import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';

class TaskItem {
  final String? id;
  final String title;
  final String priority;
  final String category;
  final bool showDailyToggle;
  final RxBool isCompleted;
  final RxBool isDaily;

  TaskItem({
    this.id,
    required this.title,
    required this.priority,
    required this.category,
    this.showDailyToggle = false,
    bool isCompleted = false,
    bool isDaily = false,
  })  : isCompleted = isCompleted.obs,
        isDaily = isDaily.obs;
}

class Todaytaskcontroller extends GetxController {
  final RxList<TaskItem> tasks = <TaskItem>[].obs;

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
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        return; // Don't fetch if not logged in
      }

      final response = await http.get(
        Uri.parse('${Apiservices.taks}?pageSize=100'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("===== FETCH TASKS RESPONSE =====");
        print(response.body);
        print("================================");
        
        final decoded = jsonDecode(response.body);
        final dataList = decoded['data'] as List;
        
        tasks.clear();
        for (var item in dataList) {
          tasks.add(TaskItem(
            id: item['id'],
            title: item['title'] ?? '',
            priority: _capitalize(item['priority'] ?? 'Low'),
            category: _capitalize(item['category'] ?? 'Work'),
            isCompleted: item['status'] == 'DONE' || item['status'] == 'COMPLETED',
            isDaily: item['isDaily'] ?? false,
            showDailyToggle: true,
          ));
        }
      } else {
        print("Failed to fetch tasks: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  int get doneCount => tasks.where((task) => task.isCompleted.value).length;

  double get progressPercentage => tasks.isEmpty ? 0.0 : doneCount / tasks.length;

  Future<void> toggleTask(TaskItem task) async {
    task.isCompleted.value = !task.isCompleted.value;
    tasks.refresh();

    if (task.id == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final newStatus = task.isCompleted.value ? 'COMPLETED' : 'TODO';
      final Map<String, dynamic> requestBody = {
        "status": newStatus,
      };

      print("===== TOGGLE STATUS PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("=================================");

      final response = await http.patch(
        Uri.parse('${Apiservices.baseUrl}/tasks/${task.id}/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print("===== TOGGLE STATUS RESPONSE =====");
      print("StatusCode: ${response.statusCode}");
      print(response.body);
      print("==================================");

      if (response.statusCode != 200 && response.statusCode != 201) {
        task.isCompleted.value = !task.isCompleted.value;
        tasks.refresh();
        print("Failed to update status: ${response.body}");
      } else {
        _triggerDashboardUpdates();
      }
    } catch (e) {
      task.isCompleted.value = !task.isCompleted.value;
      tasks.refresh();
      print("Error updating status: $e");
    }
  }

  Future<void> toggleDaily(TaskItem task) async {
    task.isDaily.value = !task.isDaily.value;
    tasks.refresh();

    if (task.id == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      print("===== TOGGLE DAILY PAYLOAD =====");
      print("Endpoint: /tasks/${task.id}");
      final Map<String, dynamic> requestBody = {
        "isDaily": task.isDaily.value
      };
      print(jsonEncode(requestBody));
      print("=================================");

      final response = await http.patch(
        Uri.parse('${Apiservices.taks}/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print("===== TOGGLE DAILY RESPONSE =====");
      print("StatusCode: ${response.statusCode}");
      print(response.body);
      print("==================================");

      if (response.statusCode != 200 && response.statusCode != 201) {
        task.isDaily.value = !task.isDaily.value;
        tasks.refresh();
        print("Failed to update daily status: ${response.body}");
      } else {
        _triggerDashboardUpdates();
      }
    } catch (e) {
      task.isDaily.value = !task.isDaily.value;
      tasks.refresh();
      print("Error updating daily status: $e");
    }
  }

  Future<void> addTask(String title, String priority, String category, bool showDailyToggle) async {
    // Add to local list first for quick UI update
    tasks.add(
      TaskItem(
        title: title,
        priority: priority,
        category: category,
        showDailyToggle: showDailyToggle,
        isCompleted: false,
        isDaily: false,
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      final Map<String, dynamic> requestBody = {
        "title": title,
        "description": "",
        "priority": priority.toUpperCase(),
        "category": category.toUpperCase(),
        "dueDate": DateTime.now().add(const Duration(days: 3)).toUtc().toIso8601String()
      };
      
      print("===== CREATE TASK PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("===============================");

      final response = await http.post(
        Uri.parse(Apiservices.taks),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print("===== CREATE TASK RESPONSE =====");
      print(response.statusCode);
      print(response.body);
      print("================================");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTasks();
        _triggerDashboardUpdates();
      }
    } catch (e) {
      print("Error creating task: $e");
    }
  }

  Future<void> deleteTask(TaskItem task) async {
    tasks.remove(task);

    if (task.id == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      print("===== DELETE TASK PAYLOAD =====");
      print("Endpoint: /tasks/${task.id}");
      print("=================================");

      final response = await http.delete(
        Uri.parse('${Apiservices.taks}/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("===== DELETE TASK RESPONSE =====");
      print("StatusCode: ${response.statusCode}");
      print(response.body);
      print("==================================");

      if (response.statusCode != 200 && response.statusCode != 204) {
        tasks.add(task);
        print("Failed to delete task: ${response.body}");
      } else {
        _triggerDashboardUpdates();
      }
    } catch (e) {
      tasks.add(task);
      print("Error deleting task: $e");
    }
  }
}