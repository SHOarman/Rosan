import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class WinsController extends GetxController {
  final RxBool isLoading = false.obs;


  final RxInt dayStreak = 0.obs;
  final RxInt pointsToday = 0.obs;
  final RxInt totalPoints = 0.obs;
  final RxInt unlockedBadgesCount = 0.obs;
  final RxInt totalBadgesCount = 0.obs;
  final RxInt currentLevel = 1.obs;
  final RxInt progressPoints = 0.obs;
  final RxInt nextLevelTarget = 100.obs;
  final RxInt pointsRemaining = 0.obs;
  final RxString progressText = ''.obs;

  final RxString bannerTitle = ''.obs;
  final RxString bannerSubtitle = ''.obs;

  final RxList<dynamic> todaysAchievements = <dynamic>[].obs;
  final RxList<dynamic> allAchievements = <dynamic>[].obs;


  final RxString streakMotivationTitle = ''.obs;
  final RxString streakMotivationText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWinsDashboard();
  }

  Future<void> fetchWinsDashboard() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(Apiservices.win_deshbord),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("===== WINS API RESPONSE =====");
        print("StatusCode: ${response.statusCode}");
        print("Body: ${response.body}");
        print("=============================");
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];

          // Parse metrics
          if (data['metrics'] != null) {
            final metrics = data['metrics'];
            dayStreak.value = metrics['dayStreak'] ?? 0;
            pointsToday.value = metrics['pointsToday'] ?? 0;
            totalPoints.value = metrics['totalPoints'] ?? 0;
            unlockedBadgesCount.value = metrics['unlockedBadgesCount'] ?? 0;
            totalBadgesCount.value = metrics['totalBadgesCount'] ?? 0;
            currentLevel.value = metrics['currentLevel'] ?? 1;
            progressPoints.value = metrics['progressPoints'] ?? 0;
            nextLevelTarget.value = metrics['nextLevelTarget'] ?? 100;
            pointsRemaining.value = metrics['pointsRemaining'] ?? 0;
            progressText.value = metrics['progressText'] ?? '';
          }

          if (data['banner'] != null) {
            bannerTitle.value = data['banner']['title'] ?? '';
            bannerSubtitle.value = data['banner']['subtitle'] ?? '';
          }

          if (data['todaysAchievements'] != null) {
            todaysAchievements.value = data['todaysAchievements'];
          } else {
             todaysAchievements.clear();
          }

          if (data['achievements'] != null) {
            allAchievements.value = data['achievements'];
          } else {
            allAchievements.clear();
          }

          if (data['streakMotivation'] != null) {
            streakMotivationTitle.value = data['streakMotivation']['title'] ?? '';
            streakMotivationText.value = data['streakMotivation']['text'] ?? '';
          }
        }
      } else {
        print("Error fetching wins dashboard: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching wins dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
