import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class GratitudeEntry {
  final String? id;
  final String text;
  final String emoji;
  final String dateLabel;
  final DateTime? createdAt;

  GratitudeEntry({
    this.id,
    required this.text,
    required this.emoji,
    required this.dateLabel,
    this.createdAt,
  });
}

class GratitudeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  final RxList<GratitudeEntry> entries = <GratitudeEntry>[].obs;
  final RxInt totalEntriesCount = 0.obs;
  final RxInt dayStreakCount = 0.obs;
  final RxInt daysThisMonthCount = 0.obs;

  int get totalEntries => totalEntriesCount.value;
  int get dayStreak => dayStreakCount.value;
  int get daysThisMonth => daysThisMonthCount.value;

  @override
  void onInit() {
    super.onInit();
    fetchGratitudeEntries();
  }

  // ── GET /gratitude?page=1&pageSize=10 ──────────────────────────
  Future<void> fetchGratitudeEntries() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      final url = '${Apiservices.get_gratitude}?page=1&pageSize=10';
      print("===== FETCH GRATITUDE ENTRIES =====");
      print("GET $url");

      final response = await http.get(
        Uri.parse(url),
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
          List dataList = [];

          if (data is List) {
            dataList = data;
          } else if (data is Map) {
            if (data['entries'] is List) {
              dataList = data['entries'];
            } else if (data['list'] is List) {
              dataList = data['list'];
            } else if (data['gratitudes'] is List) {
              dataList = data['gratitudes'];
            } else if (data['data'] is List) {
              dataList = data['data'];
            } else if (data['recentEntries'] is List) {
              dataList = data['recentEntries'];
            }
          }

          // ── Parse meta ──
          if (decoded['meta'] != null && decoded['meta'] is Map) {
            final meta = decoded['meta'];
            if (meta['total'] != null) {
              totalEntriesCount.value = meta['total'];
            }
          }

          if (totalEntriesCount.value == 0) {
            totalEntriesCount.value = dataList.length;
          }

          // ── Calculate streak & days this month from entries ──
          _calculateStats(dataList);

          // ── Parse entries ──
          final List<GratitudeEntry> fetchedEntries = [];
          for (var item in dataList) {
            if (item is Map) {
              final id = item['id']?.toString() ?? item['_id']?.toString();
              final content = item['content'] ?? item['text'] ?? item['message'] ?? '';
              final rawDate = item['createdAt'] ?? item['created_at'] ?? item['date'];

              String dateLabel = 'Today';
              DateTime? parsedDate;

              if (rawDate != null) {
                try {
                  parsedDate = DateTime.parse(rawDate.toString()).toLocal();
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final entryDay = DateTime(
                      parsedDate.year, parsedDate.month, parsedDate.day);
                  final diff = today.difference(entryDay).inDays;

                  if (diff == 0) {
                    dateLabel = 'Today';
                  } else if (diff == 1) {
                    dateLabel = 'Yesterday';
                  } else {
                    final monthNames = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                    ];
                    dateLabel =
                        '${monthNames[parsedDate.month - 1]} ${parsedDate.day}';
                  }
                } catch (_) {
                  dateLabel = rawDate.toString();
                }
              }

              fetchedEntries.add(GratitudeEntry(
                id: id,
                text: content,
                emoji: '☕',
                dateLabel: dateLabel,
                createdAt: parsedDate,
              ));
            }
          }

          entries.value = fetchedEntries;
        }
      } else {
        print("Error fetching gratitude entries: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching gratitude entries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculate day streak & days this month from entries list
  void _calculateStats(List<dynamic> dataList) {
    final now = DateTime.now();
    final Set<String> uniqueDays = {};

    for (var item in dataList) {
      final rawDate = item['createdAt'];
      if (rawDate != null) {
        try {
          final dt = DateTime.parse(rawDate.toString()).toLocal();
          uniqueDays.add('${dt.year}-${dt.month}-${dt.day}');
        } catch (_) {}
      }
    }

    // Days this month
    int monthDays = 0;
    for (var dayStr in uniqueDays) {
      final parts = dayStr.split('-');
      if (int.parse(parts[0]) == now.year &&
          int.parse(parts[1]) == now.month) {
        monthDays++;
      }
    }
    daysThisMonthCount.value = monthDays;

    // Day streak (consecutive days ending today)
    int streak = 0;
    DateTime checkDate = DateTime(now.year, now.month, now.day);
    while (uniqueDays
        .contains('${checkDate.year}-${checkDate.month}-${checkDate.day}')) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    dayStreakCount.value = streak;
  }

  // ── POST /gratitude ────────────────────────────────────────────
  Future<bool> addGratitudeEntry(String text, {String emoji = '✨'}) async {
    if (text.trim().isEmpty) return false;

    try {
      isSaving.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final body = jsonEncode({
        "content": text.trim(),
      });

      print("===== ADD GRATITUDE ENTRY =====");
      print("POST ${Apiservices.add_gratitude}");
      print("Body: $body");

      final response = await http.post(
        Uri.parse(Apiservices.add_gratitude),
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
        isSaving.value = false;
        Get.snackbar(
          'Success',
          'Gratitude logged successfully! (+15 XP)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF7B64B0),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        fetchGratitudeEntries(); // run in background
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to add gratitude entry (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print("Exception adding gratitude entry: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ── DELETE /gratitude/{id} ─────────────────────────────────────
  Future<void> deleteEntry(GratitudeEntry entry) async {
    // Optimistic removal
    final originalEntries = List<GratitudeEntry>.from(entries);
    entries.remove(entry);

    if (entry.id == null || entry.id!.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final url = '${Apiservices.add_gratitude}/${entry.id}';
      print("===== DELETE GRATITUDE ENTRY =====");
      print("DELETE $url");

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 204) {
        // Rollback on failure
        entries.value = originalEntries;
        Get.snackbar(
          'Error',
          'Failed to delete entry (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Exception deleting gratitude entry: $e");
      entries.value = originalEntries;
      Get.snackbar(
        'Error',
        'Could not delete entry. Check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
