import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';
import 'package:rosannalie/core/route/app_routes.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:audioplayers/audioplayers.dart';

class WinsController extends GetxController {
  final RxBool isLoading = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();


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
            
            int parsedLevel = metrics['currentLevel'] ?? 1;
            int lastCelebratedLevel = prefs.getInt('last_celebrated_level') ?? parsedLevel; 
            
            if (parsedLevel > lastCelebratedLevel) {
               prefs.setInt('last_celebrated_level', parsedLevel);
               _showCelebration('🎮', 'Level $parsedLevel');
            } else if (prefs.getInt('last_celebrated_level') == null) {
               prefs.setInt('last_celebrated_level', parsedLevel);
            }
            
            currentLevel.value = parsedLevel;
            int pPoints = metrics['progressPoints'] ?? 0;
            int nTarget = metrics['nextLevelTarget'] ?? 100;
            
            progressPoints.value = pPoints;
            nextLevelTarget.value = nTarget;
            pointsRemaining.value = metrics['pointsRemaining'] ?? 0;

            int lastSavedTarget = prefs.getInt('saved_next_level_target') ?? nTarget;
            if (nTarget > lastSavedTarget) {
               prefs.setInt('saved_next_level_target', nTarget);
               _showCelebration('🎯', 'Target Completed!');
            } else if (prefs.getInt('saved_next_level_target') == null) {
               prefs.setInt('saved_next_level_target', nTarget);
            }
            
            if (pPoints > 0 && pPoints >= nTarget) {
               int lastTarget = prefs.getInt('celebrated_target_reached') ?? 0;
               if (lastTarget < pPoints) { 
                  prefs.setInt('celebrated_target_reached', pPoints);
                  _showCelebration('🎯', 'Goal Reached!');
               }
            }
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
            _checkAndCelebrateAchievements(data['achievements']);
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

  Future<void> _checkAndCelebrateAchievements(List<dynamic> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> celebrated = prefs.getStringList('celebrated_achievements') ?? [];
    
    for (var ach in achievements) {
      if (ach is Map<String, dynamic>) {
        bool isUnlocked = ach['isUnlocked'] == true || ach['unlocked'] == true || ach['completed'] == true;
        
        if (!isUnlocked && ach['progress'] != null) {
          isUnlocked = (ach['progress'].toString() == '100' || ach['progress'].toString() == '100.0');
        }
        
        String achId = ach['id']?.toString() ?? ach['title']?.toString() ?? '';
        
        if (isUnlocked && achId.isNotEmpty && !celebrated.contains(achId)) {
          String title = ach['title']?.toString() ?? 'New Achievement';
          String emoji = '🎉';
          final titleLower = title.toLowerCase();
          
          if (titleLower.contains('roll')) emoji = '🔥';
          else if (titleLower.contains('step')) emoji = '🌱';
          else if (titleLower.contains('setter')) emoji = '🎯';
          else if (titleLower.contains('gratitude') || titleLower.contains('pro')) emoji = '🙏';
          else if (titleLower.contains('habit')) emoji = '⭐';
          else if (titleLower.contains('champion')) emoji = '🏆';
          
          _showCelebration(emoji, title);
          
          celebrated.add(achId);
          await prefs.setStringList('celebrated_achievements', celebrated);
          
          await Future.delayed(const Duration(milliseconds: 2500));
        }
      }
    }
  }

  void _showCelebration(String emoji, String title) {
    if (Get.context == null) return;

    if (Get.currentRoute == AppRoutes.subscriptionPromotion || 
        Get.currentRoute == AppRoutes.subscriptionPromotionProfile) {
      Future.delayed(const Duration(seconds: 2), () {
        _showCelebration(emoji, title);
      });
      return;
    }

    try {
      _audioPlayer.play(AssetSource('audio/achimentandlevelup.mp3'));
    } catch (e) {
      print("Error playing celebration sound: $e");
    }

    Get.dialog(
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.1, end: 1.0),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.elasticOut,
        builder: (context, val, child) {
          return Transform.scale(
            scale: val,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 110), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(
                    "Unlocked:\n$title!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 15.0,
                          color: Colors.black87,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: true,
      barrierColor: Colors.black54,
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });
  }
}
