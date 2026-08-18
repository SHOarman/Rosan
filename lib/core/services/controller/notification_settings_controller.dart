import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class NotificationSettingsController extends GetxController {
  var isLoading = false.obs;

  // Toggles
  var pushNotificationsEnabled = false.obs;
  var emailNotificationsEnabled = false.obs;
  var habitRemindersEnabled = false.obs;
  var taskRemindersEnabled = false.obs;
  var dailySummaryEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationSettings();
  }

  Future<void> fetchNotificationSettings() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      
      if (token.isEmpty) return;

      var url = Uri.parse(Apiservices.notification_settings);
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          var settings = data['data'];
          pushNotificationsEnabled.value = settings['pushNotificationsEnabled'] ?? false;
          emailNotificationsEnabled.value = settings['emailNotificationsEnabled'] ?? false;
          habitRemindersEnabled.value = settings['habitRemindersEnabled'] ?? false;
          taskRemindersEnabled.value = settings['taskRemindersEnabled'] ?? false;
          dailySummaryEnabled.value = settings['dailySummaryEnabled'] ?? false;
        }
      } else {
        print("Failed to fetch notification settings: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notification settings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      
      if (token.isEmpty) return;

      var url = Uri.parse(Apiservices.notification_settings);
      
      var body = {
        "pushNotificationsEnabled": pushNotificationsEnabled.value,
        "emailNotificationsEnabled": emailNotificationsEnabled.value,
        "habitRemindersEnabled": habitRemindersEnabled.value,
        "taskRemindersEnabled": taskRemindersEnabled.value,
        "dailySummaryEnabled": dailySummaryEnabled.value,
        "reminderFrequency": "SMART" // Per the postman screenshot
      };

      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Notification settings updated successfully!");
      } else {
        print("Failed to update notification settings: ${response.statusCode} - ${response.body}");
        // Optionally revert state if save fails by re-fetching
      }
    } catch (e) {
      print("Error updating notification settings: $e");
    }
  }

  // Toggle helpers
  void togglePushNotifications(bool value) {
    pushNotificationsEnabled.value = value;
    updateNotificationSettings();
  }
  
  void toggleEmailNotifications(bool value) {
    emailNotificationsEnabled.value = value;
    updateNotificationSettings();
  }
  
  void toggleHabitReminders(bool value) {
    habitRemindersEnabled.value = value;
    updateNotificationSettings();
  }
  
  void toggleTaskReminders(bool value) {
    taskRemindersEnabled.value = value;
    updateNotificationSettings();
  }
  
  void toggleDailySummary(bool value) {
    dailySummaryEnabled.value = value;
    updateNotificationSettings();
  }
}
