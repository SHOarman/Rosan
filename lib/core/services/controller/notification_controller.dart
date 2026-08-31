import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notifications = [].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      // Typically the inbox is just /notifications
      final response = await http.get(
        Uri.parse("${Apiservices.baseUrl}/notifications?page=1&pageSize=30"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        if (decodedData is List) {
          notifications.value = decodedData;
        } else if (decodedData.containsKey('notifications') && decodedData['notifications'] != null) {
          notifications.value = decodedData['notifications'];
        } else if (decodedData['success'] == true && decodedData['data'] != null) {
          if (decodedData['data']['notifications'] != null) {
             notifications.value = decodedData['data']['notifications'];
          } else {
             notifications.value = decodedData['data'];
          }
        }
      } else {
        errorMessage.value = "Status Code: ${response.statusCode}\nBody: ${response.body}";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id, int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.patch(
        Uri.parse(Apiservices.read_single_notification(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        // Update local state instantly
        var updatedList = List.from(notifications);
        if (updatedList[index] is Map) {
           updatedList[index]['readAt'] = DateTime.now().toIso8601String();
        }
        notifications.value = updatedList;
      }
    } catch (e) {
      print("Mark as read error: $e");
    }
  }

  Future<void> deleteNotification(String id, int index) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final url = Apiservices.delete_notification(id);
      print("---- DELETE NOTIFICATION START ----");
      print("Attempting to delete notification with index: $index");
      print("Raw ID passed from item: $id");
      print("Endpoint URL: $url");
      
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print("Delete Response Status Code: ${response.statusCode}");
      print("Delete Response Body: ${response.body}");
      print("---- DELETE NOTIFICATION END ----");

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Update local state instantly
        var updatedList = List.from(notifications);
        updatedList.removeWhere((element) => (element['id']?.toString() ?? element['_id']?.toString() ?? '') == id);
        notifications.value = updatedList;
      } else if (response.statusCode == 201) {
         var updatedList = List.from(notifications);
         updatedList.removeWhere((element) => (element['id']?.toString() ?? element['_id']?.toString() ?? '') == id);
         notifications.value = updatedList;
      } else {
        Get.snackbar("Error", "Failed to delete notification.");
      }

    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print("Delete notification error: $e");

    }
  }

  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.patch(
        Uri.parse(Apiservices.read_all_notifications),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        // Update local state instantly
        var updatedList = List.from(notifications);
        final nowStr = DateTime.now().toIso8601String();
        for (int i = 0; i < updatedList.length; i++) {
          if (updatedList[i] is Map) {
             updatedList[i]['readAt'] = updatedList[i]['readAt'] ?? nowStr;
          }
        }
        notifications.value = updatedList;
      }
    } catch (e) {
      print("Mark all as read error: $e");
    }
  }
}
