import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/presention/wins/widget/stackcard.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:intl/intl.dart';

class Achievements extends StatelessWidget {
  final int? limit;
  const Achievements({super.key, this.limit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<WinsController>() ? Get.find<WinsController>() : Get.put(WinsController());

    return Obx(() {
      List<dynamic> achievements = List.from(controller.todaysAchievements);
      if (achievements.isEmpty) {
        return const Center(child: Text("No achievements today"));
      }

      // Sort newest achievements first (descending by createdAt)
      achievements.sort((a, b) {
        final aTime = a['createdAt'] != null ? DateTime.tryParse(a['createdAt'].toString()) : null;
        final bTime = b['createdAt'] != null ? DateTime.tryParse(b['createdAt'].toString()) : null;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      if (limit != null && limit! > 0 && achievements.length > limit!) {
        achievements = achievements.take(limit!).toList();
      }

      return Column(
        children: achievements.map((achievement) {
          final title = achievement['title'] ?? '';
          final points = '+${achievement['points'] ?? 0}';
          String timeStr = '';
          try {
            if (achievement['createdAt'] != null) {
              final dt = DateTime.parse(achievement['createdAt']).toLocal();
              timeStr = DateFormat('h:mm a').format(dt);
            }
          } catch (_) {}
          
          final String emoji = achievement['icon']?.toString() ?? '🏆';

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
                      // Text Title & Subtitle column
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
                      // Trailing points chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E3F5),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Color(0xFFC5B8E8),
                            width: 1.2
                          )
                        ),
                        child: Text(
                          points,
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            gradientColors: [
                              Color(0xff9B85CF),
                              Color(0xff5E4B8B)
                              
                            ]
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

class AchievementGridItem {
  final Widget icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color? badgeColor;
  final bool isUnlocked;

  const AchievementGridItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.badgeColor,
    this.isUnlocked = false,
  });
}

class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({super.key});

  static const List<List<Color>> _colorPalette = [
    [Color(0xFFA1E7B9), Color(0xFFB5F2CC)],
    [Color(0xFFFFDF9F), Color(0xFFFFC374)],
    [Color(0xFFC4C1E0), Color(0xFFAB9FD5)],
    [Color(0xFFCBD6E2), Color(0xFFA9BCCF)],
    [Color(0xFFECC1DD), Color(0xFFDB95C7)],
    [Color(0xFFECA3A3), Color(0xFFD57474)],
  ];

  static const List<Color> _badgePalette = [
    Color(0xFF5DBB80),
    Color(0xFFFFB33A),
    Color(0xFF7E57C2),
    Color(0xFF5A9FBF),
    Color(0xFFC2579A),
    Color(0xFFD35400),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<WinsController>() ? Get.find<WinsController>() : Get.put(WinsController());

    return Obx(() {
      final apiAchievements = controller.allAchievements;
      
      if (apiAchievements.isEmpty) {
        return const Center(child: Text("No achievements available"));
      }

      final uniqueAchievements = <String, dynamic>{};
      for (var a in apiAchievements) {
        final title = (a['title'] ?? '').toString();
        final lowerTitle = title.toLowerCase().replaceAll('_', ' ');
        if (!uniqueAchievements.containsKey(lowerTitle)) {
          uniqueAchievements[lowerTitle] = a;
        } else {
          final existing = uniqueAchievements[lowerTitle];
          if (existing['isUnlocked'] == false && a['isUnlocked'] == true) {
             uniqueAchievements[lowerTitle] = a;
          } else if (existing['title'] == existing['title'].toString().toUpperCase() && title != title.toUpperCase()) {
             if (existing['isUnlocked'] == a['isUnlocked']) {
                 uniqueAchievements[lowerTitle] = a;
             }
          }
        }
      }

      final displayItems = uniqueAchievements.values.toList();

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final apiItem = displayItems[index];
          
          final String title = apiItem['title']?.toString().replaceAll('_', ' ') ?? 'Achievement';
          final String formattedTitle = title.split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '').join(' ');

          final colors = _colorPalette[index % _colorPalette.length];
          final badgeColor = _badgePalette[index % _badgePalette.length];

          final item = AchievementGridItem(
            icon: Text(apiItem['icon']?.toString() ?? '🏆', style: const TextStyle(fontSize: 24)),
            title: formattedTitle,
            subtitle: apiItem['description']?.toString() ?? '',
            gradientColors: colors,
            badgeColor: badgeColor,
            isUnlocked: apiItem['isUnlocked'] == true,
          );
          return _buildCard(item);
        },
      );
    });
  }

  Widget _buildCard(AchievementGridItem item) {
    return StackCard(
      gradientColors: item.gradientColors,
      icon: item.icon,
      title: item.title,
      subtitle: item.subtitle,
      titleColor: const Color(0xFF161022),
      subtitleColor: const Color(0xFFFFFFFF),
      titleFontSize: 12.0,
      subtitleFontSize: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      trailing: item.isUnlocked ? _buildCheckBadge(item.badgeColor ?? const Color(0xFF5DBB80)) : null,
    );
  }

  Widget _buildCheckBadge(Color badgeColor) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}
