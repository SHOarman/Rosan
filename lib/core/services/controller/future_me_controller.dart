import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class FutureJourneyItem {
  final String id;
  final String title;
  final String status;
  final String date;
  final String icon; 
  final String? description;

  FutureJourneyItem({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    required this.icon,
    this.description,
  });

  factory FutureJourneyItem.fromJson(Map<String, dynamic> json) {
    return FutureJourneyItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 'UPCOMING',
      date: json['date'] ?? 'Upcoming',
      icon: json['icon'] ?? 'CHECK',
      description: json['description'],
    );
  }
}

class FutureMeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSavingLetter = false.obs;

  final RxString vision = "In 5 years, I am living with freedom, health, and purpose.".obs;
  final RxMap<String, dynamic> latestLetter = <String, dynamic>{}.obs;
  final RxList<FutureJourneyItem> journeyList = <FutureJourneyItem>[].obs;

  // Growth Snapshot Metrics
  final RxInt daysActive = 0.obs;
  final RxInt tasksDone = 0.obs;
  final RxInt goalsSet = 0.obs;

  int get completedJourneyCount =>
      journeyList.where((item) => item.status.toUpperCase() == 'COMPLETED').length;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  // ── GET /future-me/dashboard ───────────────────────────────────
  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      print("===== FETCH FUTURE ME DASHBOARD =====");
      print("GET ${Apiservices.futureMeDashboard}");

      final response = await http.get(
        Uri.parse(Apiservices.futureMeDashboard),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];

          // Parse vision
          if (data['vision'] != null && data['vision'].toString().isNotEmpty) {
            vision.value = data['vision'].toString();
          }

          // Parse latestLetter
          if (data['latestLetter'] != null && data['latestLetter'] is Map) {
            latestLetter.value = Map<String, dynamic>.from(data['latestLetter']);
          } else {
            latestLetter.clear();
          }

          // Parse journey list
          if (data['journey'] != null && data['journey'] is List) {
            final List jList = data['journey'];
            journeyList.value = jList
                .map((item) => FutureJourneyItem.fromJson(Map<String, dynamic>.from(item)))
                .toList();
          }

          // Parse growthSnapshot
          if (data['growthSnapshot'] != null && data['growthSnapshot'] is Map) {
            final snapshot = data['growthSnapshot'];
            daysActive.value = snapshot['daysActive'] ?? 0;
            tasksDone.value = snapshot['tasksDone'] ?? 0;
            goalsSet.value = snapshot['goalsSet'] ?? 0;
          }
        }
      }
    } catch (e) {
      print("Error fetching Future Me dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── POST /future-me/letters ───────────────────────────────────
  Future<bool> createLetter({required String content, required DateTime unlockAt}) async {
    if (content.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter letter content",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isSavingLetter.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isSavingLetter.value = false;
        return false;
      }

      final body = jsonEncode({
        "content": content.trim(),
        "unlockAt": unlockAt.toUtc().toIso8601String(),
      });

      print("===== POST FUTURE ME LETTER =====");
      print("URL: ${Apiservices.futureMeLetters}");
      print("Body: $body");

      final response = await http.post(
        Uri.parse(Apiservices.futureMeLetters),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: body,
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        vision.value = content.trim();
        Get.snackbar(
          "Success",
          "Letter created for your future self! ✉️",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF7B64B0),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        await fetchDashboard();
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to save letter (${response.statusCode})",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print("Error creating Future Me letter: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSavingLetter.value = false;
    }
  }
}
