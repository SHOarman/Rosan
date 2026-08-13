import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:intl/intl.dart';

class TodayAchievements extends StatelessWidget {
  const TodayAchievements({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<WinsController>() ? Get.find<WinsController>() : Get.put(WinsController());

    return Obx(() {
      final achievements = controller.todaysAchievements;
      if (achievements.isEmpty) {
        return const Center(child: Text("No achievements today"));
      }

      return Column(
        children: achievements.map((achievement) {
          final title = achievement['title']?.toString() ?? '';
          final points = '+${achievement['points'] ?? 0}';
          final emoji = achievement['icon']?.toString() ?? '🏆';
          String timeStr = '';
          try {
            if (achievement['createdAt'] != null) {
              final dt = DateTime.parse(achievement['createdAt']).toLocal();
              timeStr = DateFormat('h:mm a').format(dt);
            }
          } catch (_) {}

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: double.infinity,
              height: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset.zero,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xFFF3F3F3).withValues(alpha: 0.40),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Emoji leading container
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFF3F3F3),
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF161022),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                timeStr,
                                style: AppTextStyles.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFB5AEC4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E3F5),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: const Color(0xFFC5B8E8),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            points,
                            style: AppTextStyles.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              gradientColors: const [
                                Color(0xFF9B85CF),
                                Color(0xFF5E4B8B),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
