import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/presention/wins/widget/stackcard.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:intl/intl.dart';

class AchievementItem {
  final String emoji;
  final String title;
  final String time;
  final String points;

  const AchievementItem({
    required this.emoji,
    required this.title,
    required this.time,
    required this.points,
  });
}

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  static const List<AchievementItem> _defaultAchievements = [
    AchievementItem(
      emoji: '💪',
      title: 'Completed morning workout',
      time: '7:30 AM',
      points: '+50',
    ),
    AchievementItem(
      emoji: '💧',
      title: 'Drank 8 glasses of water',
      time: '4:00 PM',
      points: '+30',
    ),
    AchievementItem(
      emoji: '📚',
      title: 'Read for 20 minutes',
      time: '9:00 PM',
      points: '+40',
    ),
  ];

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
          final title = achievement['title'] ?? '';
          final points = '+${achievement['points'] ?? 0}';
          String timeStr = '';
          try {
            if (achievement['createdAt'] != null) {
              final dt = DateTime.parse(achievement['createdAt']).toLocal();
              timeStr = DateFormat('h:mm a').format(dt);
            }
          } catch (_) {}
          
          final String emoji = title.toLowerCase().contains('task') ? '💪' : (title.toLowerCase().contains('welcome') ? '👋' : '🏆');

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

  static final List<AchievementGridItem> _gridItems = [
    AchievementGridItem(
      icon: const Text('🌱', style: TextStyle(fontSize: 24)),
      title: 'First Step',
      subtitle: 'Completed your first task',
      gradientColors: const [
        Color(0xFFA1E7B9),
        Color(0xFFB5F2CC),
      ],
      badgeColor: const Color(0xFF5DBB80),
    ),
    AchievementGridItem(
      icon: SvgPicture.asset(
        'assets/icon/streak_icon.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Color(0xFFE67E22), BlendMode.srcIn),
      ),
      title: 'On a Roll',
      subtitle: '3-day streak',
      gradientColors: const [
        Color(0xFFFFDF9F),
        Color(0xFFFFC374),
      ],
      badgeColor: const Color(0xFFFFB33A),
    ),
    AchievementGridItem(
      icon: SvgPicture.asset(
        'assets/icon/TargetIcon.svg',
        width: 24,
        height: 24,
      ),
      title: 'Goal Setter',
      subtitle: 'Created your first goal',
      gradientColors: const [
        Color(0xFFC4C1E0),
        Color(0xFFAB9FD5),
      ],
      badgeColor: const Color(0xFF7E57C2),
    ),
    AchievementGridItem(
      icon: const Text('🙏', style: TextStyle(fontSize: 24)),
      title: 'Gratitude Pro',
      subtitle: '7 gratitude entries',
      gradientColors: const [
        Color(0xFFCBD6E2),
        Color(0xFFA9BCCF),
      ],
    ),
    AchievementGridItem(
      icon: const Text('⭐', style: TextStyle(fontSize: 24)),
      title: 'Habit Builder',
      subtitle: '14-day streak',
      gradientColors: const [
        Color(0xFFECC1DD),
        Color(0xFFDB95C7),
      ],
    ),
    AchievementGridItem(
      icon: SvgPicture.asset(
        'assets/icon/badge_icon.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Color(0xFFD35400), BlendMode.srcIn),
      ),
      title: 'Champion',
      subtitle: 'Complete a big goal',
      gradientColors: const [
        Color(0xFFECA3A3),
        Color(0xFFD57474),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<WinsController>() ? Get.find<WinsController>() : Get.put(WinsController());

    return Obx(() {
      final apiAchievements = controller.allAchievements;
      
      if (apiAchievements.isEmpty) {
        return const Center(child: Text("No achievements available"));
      }

      // Filter out duplicate all-caps ones if there are proper cased ones
      final uniqueAchievements = <String, dynamic>{};
      for (var a in apiAchievements) {
        final title = (a['title'] ?? '').toString();
        final lowerTitle = title.toLowerCase().replaceAll('_', ' ');
        // If we already have it, only replace if the new one is properly cased (not all caps) or unlocked
        if (!uniqueAchievements.containsKey(lowerTitle)) {
          uniqueAchievements[lowerTitle] = a;
        } else {
          final existing = uniqueAchievements[lowerTitle];
          if (existing['isUnlocked'] == false && a['isUnlocked'] == true) {
             uniqueAchievements[lowerTitle] = a;
          } else if (existing['title'] == existing['title'].toString().toUpperCase() && title != title.toUpperCase()) {
             // prefer proper case
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
          // Use modulo to cycle through predefined colors/icons if there are more items than defaults
          final defaultItem = _gridItems[index % _gridItems.length];
          
          final String title = apiItem['title']?.toString().replaceAll('_', ' ') ?? defaultItem.title;
          final String formattedTitle = title.split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '').join(' ');

          final item = AchievementGridItem(
            icon: Text(apiItem['icon']?.toString() ?? '🏆', style: const TextStyle(fontSize: 24)),
            title: formattedTitle,
            subtitle: apiItem['description'] ?? defaultItem.subtitle,
            gradientColors: defaultItem.gradientColors,
            badgeColor: defaultItem.badgeColor ?? const Color(0xFF5DBB80),
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
      subtitleColor: Colors.white.withValues(alpha: 0.9),
      titleFontSize: 13.0,
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
